using Microsoft.AspNetCore.Mvc;
using CRMFiloServis.Web.Services;
using CRMFiloServis.Web.Data;
using CRMFiloServis.Shared.Entities;
using Microsoft.EntityFrameworkCore;

namespace CRMFiloServis.Web.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MobileController : ControllerBase
{
    private readonly IDbContextFactory<ApplicationDbContext> _contextFactory;
    private readonly IKullaniciService _kullaniciService;

    public MobileController(
        IDbContextFactory<ApplicationDbContext> contextFactory,
        IKullaniciService kullaniciService)
    {
        _contextFactory = contextFactory;
        _kullaniciService = kullaniciService;
    }

    [HttpGet("dashboard")]
    public async Task<IActionResult> GetDashboard()
    {
        using var context = await _contextFactory.CreateDbContextAsync();

        var now = DateTime.UtcNow;
        var ayBaslangic = new DateTime(now.Year, now.Month, 1);
        var ayBitis = ayBaslangic.AddMonths(1).AddDays(-1);

        // Genel istatistikler
        var toplamArac = await context.Araclar.CountAsync();
        var aktifArac = await context.Araclar.CountAsync(a => a.Aktif);
        var toplamSofor = await context.Soforler.CountAsync(s => s.Aktif);
        var servistekiArac = await context.Araclar.CountAsync(a => !a.Aktif);

        // Fatura istatistikleri
        var bekleyenFatura = await context.Faturalar
            .CountAsync(f => f.Durum != FaturaDurum.Odendi && !f.IsDeleted);

        // Evrak uyarilari (30 gun icinde bitecekler)
        var evrakUyariTarihi = now.AddDays(30);
        var yaklaþanEvrak = await context.AracEvraklari
            .CountAsync(e => e.BitisTarihi.HasValue && 
                           e.BitisTarihi <= evrakUyariTarihi && 
                           e.BitisTarihi > now);

        // Aylik gelir/gider
        var aylikGelir = await context.Faturalar
            .Where(f => f.FaturaTarihi >= ayBaslangic && 
                       f.FaturaTarihi <= ayBitis && 
                       f.FaturaTipi == FaturaTipi.SatisFaturasi)
            .SumAsync(f => (decimal?)f.GenelToplam) ?? 0;

        var aylikGider = await context.AracMasraflari
            .Where(m => m.MasrafTarihi >= ayBaslangic && m.MasrafTarihi <= ayBitis)
            .SumAsync(m => (decimal?)m.Tutar) ?? 0;

        // Banka bakiye - HareketTipi'ne gore hesapla
        var girisler = await context.BankaKasaHareketleri
            .Where(b => b.HareketTipi == HareketTipi.Giris)
            .SumAsync(b => (decimal?)b.Tutar) ?? 0;
        var cikislar = await context.BankaKasaHareketleri
            .Where(b => b.HareketTipi == HareketTipi.Cikis)
            .SumAsync(b => (decimal?)b.Tutar) ?? 0;
        var bankaBakiye = girisler - cikislar;

        // Son islemler
        var sonIslemler = await context.AktiviteLoglar
            .OrderByDescending(a => a.CreatedAt)
            .Take(10)
            .Select(a => new
            {
                Baslik = a.Aciklama,
                Tip = a.IslemTipi,
                Tarih = a.CreatedAt
            })
            .ToListAsync();

        // Odenmemis faturalar
        var odenmemisFaturalar = await context.Faturalar
            .Include(f => f.Cari)
            .Where(f => f.Durum != FaturaDurum.Odendi && !f.IsDeleted)
            .OrderByDescending(f => f.FaturaTarihi)
            .Take(5)
            .Select(f => new
            {
                FaturaNo = f.FaturaNo,
                CariUnvan = f.Cari.Unvan,
                Tutar = f.GenelToplam,
                Tarih = f.FaturaTarihi
            })
            .ToListAsync();

        // Son masraflar
        var sonMasraflar = await context.AracMasraflari
            .Include(m => m.MasrafKalemi)
            .OrderByDescending(m => m.MasrafTarihi)
            .Take(5)
            .Select(m => new
            {
                Aciklama = m.MasrafKalemi.MasrafAdi,
                Tutar = m.Tutar,
                Tarih = m.MasrafTarihi
            })
            .ToListAsync();

        // Gunun guzergahlari
        var bugun = DateTime.Today;
        var gununGuzergahlari = await context.ServisCalismalari
            .Include(s => s.Guzergah)
            .Include(s => s.Sofor)
            .Include(s => s.Arac)
            .Where(s => s.CalismaTarihi.Date == bugun)
            .Take(5)
            .Select(s => new
            {
                GuzergahAdi = s.Guzergah.GuzergahAdi,
                SoforAdi = s.Sofor.Ad + " " + s.Sofor.Soyad,
                Plaka = s.Arac != null ? s.Arac.AktifPlaka : "",
                Durum = s.Durum
            })
            .ToListAsync();

        // Evrak uyarilari listesi
        var evrakUyarilari = await context.AracEvraklari
            .Include(e => e.Arac)
            .Where(e => e.BitisTarihi.HasValue && 
                       e.BitisTarihi <= evrakUyariTarihi && 
                       e.BitisTarihi > now)
            .OrderBy(e => e.BitisTarihi)
            .Take(5)
            .Select(e => new
            {
                EvrakTipi = e.EvrakKategorisi,
                Plaka = e.Arac != null ? e.Arac.AktifPlaka : "",
                BitisTarihi = e.BitisTarihi,
                KalanGun = e.BitisTarihi.HasValue ? 
                    (e.BitisTarihi.Value.Date - now.Date).Days : 0
            })
            .ToListAsync();

        return Ok(new
        {
            ToplamArac = toplamArac,
            AktifArac = aktifArac,
            ToplamSofor = toplamSofor,
            ServistekiArac = servistekiArac,
            BekleyenFatura = bekleyenFatura,
            YaklaþanEvrak = yaklaþanEvrak,
            AylikGelir = aylikGelir,
            AylikGider = aylikGider,
            BankaBakiye = bankaBakiye,
            SonIslemler = sonIslemler,
            OdenmemisFaturalar = odenmemisFaturalar,
            SonMasraflar = sonMasraflar,
            GununGuzergahlari = gununGuzergahlari,
            EvrakUyarilari = evrakUyarilari
        });
    }

    [HttpGet("araclar")]
    public async Task<IActionResult> GetAraclar()
    {
        using var context = await _contextFactory.CreateDbContextAsync();
        
        var araclar = await context.Araclar
            .OrderBy(a => a.AktifPlaka)
            .Select(a => new
            {
                a.Id,
                Plaka = a.AktifPlaka ?? a.SaseNo,
                a.Marka,
                a.Model,
                a.ModelYili,
                a.KmDurumu,
                a.Aktif
            })
            .ToListAsync();

        return Ok(araclar);
    }

    [HttpGet("soforler")]
    public async Task<IActionResult> GetSoforler()
    {
        using var context = await _contextFactory.CreateDbContextAsync();
        
        var soforler = await context.Soforler
            .Where(s => s.Aktif)
            .OrderBy(s => s.Ad)
            .Select(s => new
            {
                s.Id,
                s.SoforKodu,
                AdSoyad = s.Ad + " " + s.Soyad,
                s.Telefon
            })
            .ToListAsync();

        return Ok(soforler);
    }

    [HttpGet("guzergahlar")]
    public async Task<IActionResult> GetGuzergahlar()
    {
        using var context = await _contextFactory.CreateDbContextAsync();
        
        var guzergahlar = await context.Guzergahlar
            .OrderBy(g => g.GuzergahAdi)
            .Select(g => new
            {
                g.Id,
                g.GuzergahKodu,
                g.GuzergahAdi,
                g.BaslangicNoktasi,
                g.BitisNoktasi,
                g.Mesafe
            })
            .ToListAsync();

        return Ok(guzergahlar);
    }
}
