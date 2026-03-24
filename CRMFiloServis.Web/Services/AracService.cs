using CRMFiloServis.Shared.Entities;
using CRMFiloServis.Web.Data;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.EntityFrameworkCore;

namespace CRMFiloServis.Web.Services;

public class AracService : IAracService
{
    private readonly ApplicationDbContext _context;
    private readonly IWebHostEnvironment _env;

    public AracService(ApplicationDbContext context, IWebHostEnvironment env)
    {
        _context = context;
        _env = env;
    }

    public async Task<List<Arac>> GetAllAsync()
    {
        return await _context.Araclar
            .OrderBy(a => a.Plaka)
            .ToListAsync();
    }

    public async Task<List<Arac>> GetActiveAsync()
    {
        return await _context.Araclar
            .Where(a => a.Aktif)
            .OrderBy(a => a.Plaka)
            .ToListAsync();
    }

    public async Task<int> GetActiveCountAsync()
    {
        return await _context.Araclar
            .Where(a => a.Aktif)
            .CountAsync();
    }

    public async Task<Arac?> GetByIdAsync(int id)
    {
        return await _context.Araclar.FindAsync(id);
    }

    public async Task<Arac?> GetByPlakaAsync(string plaka)
    {
        return await _context.Araclar
            .FirstOrDefaultAsync(a => a.Plaka == plaka);
    }

    public async Task<Arac> CreateAsync(Arac arac)
    {
        _context.Araclar.Add(arac);
        await _context.SaveChangesAsync();
        return arac;
    }

    public async Task<Arac> UpdateAsync(Arac arac)
    {
        _context.Araclar.Update(arac);
        await _context.SaveChangesAsync();
        return arac;
    }

    public async Task DeleteAsync(int id)
    {
        var arac = await _context.Araclar.FindAsync(id);
        if (arac != null)
        {
            arac.IsDeleted = true;
            await _context.SaveChangesAsync();
        }
    }

    #region Arac Evrak Islemleri

    public async Task<List<AracEvrak>> GetAracEvraklariAsync(int aracId)
    {
        return await _context.AracEvraklari
            .Include(e => e.Dosyalar)
            .Where(e => e.AracId == aracId)
            .OrderBy(e => e.EvrakKategorisi)
            .ThenByDescending(e => e.BitisTarihi)
            .ToListAsync();
    }

    public async Task<AracEvrak?> GetAracEvrakByIdAsync(int evrakId)
    {
        return await _context.AracEvraklari
            .Include(e => e.Dosyalar)
            .FirstOrDefaultAsync(e => e.Id == evrakId);
    }

    public async Task<AracEvrak> CreateAracEvrakAsync(AracEvrak evrak)
    {
        if (evrak.BaslangicTarihi.HasValue)
            evrak.BaslangicTarihi = DateTime.SpecifyKind(evrak.BaslangicTarihi.Value, DateTimeKind.Utc);
        if (evrak.BitisTarihi.HasValue)
            evrak.BitisTarihi = DateTime.SpecifyKind(evrak.BitisTarihi.Value, DateTimeKind.Utc);
        if (evrak.HatirlatmaTarihi.HasValue)
            evrak.HatirlatmaTarihi = DateTime.SpecifyKind(evrak.HatirlatmaTarihi.Value, DateTimeKind.Utc);

        evrak.CreatedAt = DateTime.UtcNow;
        _context.AracEvraklari.Add(evrak);
        await _context.SaveChangesAsync();
        return evrak;
    }

    public async Task<AracEvrak> UpdateAracEvrakAsync(AracEvrak evrak)
    {
        var existing = await _context.AracEvraklari.FindAsync(evrak.Id);
        if (existing == null)
            throw new Exception("Evrak bulunamadi");

        existing.EvrakKategorisi = evrak.EvrakKategorisi;
        existing.EvrakAdi = evrak.EvrakAdi;
        existing.Aciklama = evrak.Aciklama;
        existing.BaslangicTarihi = evrak.BaslangicTarihi.HasValue ? DateTime.SpecifyKind(evrak.BaslangicTarihi.Value, DateTimeKind.Utc) : null;
        existing.BitisTarihi = evrak.BitisTarihi.HasValue ? DateTime.SpecifyKind(evrak.BitisTarihi.Value, DateTimeKind.Utc) : null;
        existing.HatirlatmaTarihi = evrak.HatirlatmaTarihi.HasValue ? DateTime.SpecifyKind(evrak.HatirlatmaTarihi.Value, DateTimeKind.Utc) : null;
        existing.Tutar = evrak.Tutar;
        existing.SigortaSirketi = evrak.SigortaSirketi;
        existing.PoliceNo = evrak.PoliceNo;
        existing.Durum = evrak.Durum;
        existing.HatirlatmaAktif = evrak.HatirlatmaAktif;
        existing.HatirlatmaGunOnce = evrak.HatirlatmaGunOnce;
        existing.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();
        return existing;
    }

    public async Task DeleteAracEvrakAsync(int evrakId)
    {
        var evrak = await _context.AracEvraklari
            .Include(e => e.Dosyalar)
            .FirstOrDefaultAsync(e => e.Id == evrakId);
            
        if (evrak != null)
        {
            // Dosyalari sil
            foreach (var dosya in evrak.Dosyalar)
            {
                var dosyaYolu = Path.Combine(_env.ContentRootPath, "wwwroot", dosya.DosyaYolu);
                if (File.Exists(dosyaYolu))
                    File.Delete(dosyaYolu);
            }
            _context.AracEvrakDosyalari.RemoveRange(evrak.Dosyalar);
            _context.AracEvraklari.Remove(evrak);
            await _context.SaveChangesAsync();
        }
    }

    #endregion

    #region Evrak Dosya Islemleri

    public async Task<AracEvrakDosya> UploadEvrakDosyaAsync(int evrakId, IBrowserFile file)
    {
        var evrak = await _context.AracEvraklari.FindAsync(evrakId);
        if (evrak == null)
            throw new Exception("Evrak bulunamadi");

        // Dosya klasoru olustur
        var uploadsFolder = Path.Combine(_env.ContentRootPath, "wwwroot", "uploads", "evraklar", evrakId.ToString());
        Directory.CreateDirectory(uploadsFolder);

        // Dosya adi benzersiz yap
        var dosyaAdi = $"{Guid.NewGuid()}_{file.Name}";
        var dosyaYolu = Path.Combine(uploadsFolder, dosyaAdi);

        // Dosyayi kaydet
        using var stream = new FileStream(dosyaYolu, FileMode.Create);
        await file.OpenReadStream(maxAllowedSize: 10 * 1024 * 1024).CopyToAsync(stream);

        // DB'ye kaydet
        var evrakDosya = new AracEvrakDosya
        {
            AracEvrakId = evrakId,
            DosyaAdi = file.Name,
            DosyaYolu = $"uploads/evraklar/{evrakId}/{dosyaAdi}",
            DosyaTipi = Path.GetExtension(file.Name).TrimStart('.').ToLower(),
            DosyaBoyutu = file.Size,
            CreatedAt = DateTime.UtcNow
        };

        _context.AracEvrakDosyalari.Add(evrakDosya);
        await _context.SaveChangesAsync();
        return evrakDosya;
    }

    public async Task<byte[]> GetEvrakDosyaAsync(int dosyaId)
    {
        var dosya = await _context.AracEvrakDosyalari.FindAsync(dosyaId);
        if (dosya == null)
            throw new Exception("Dosya bulunamadi");

        var dosyaYolu = Path.Combine(_env.ContentRootPath, "wwwroot", dosya.DosyaYolu);
        if (!File.Exists(dosyaYolu))
            throw new Exception("Dosya diskte bulunamadi");

        return await File.ReadAllBytesAsync(dosyaYolu);
    }

    public async Task DeleteEvrakDosyaAsync(int dosyaId)
    {
        var dosya = await _context.AracEvrakDosyalari.FindAsync(dosyaId);
        if (dosya != null)
        {
            var dosyaYolu = Path.Combine(_env.ContentRootPath, "wwwroot", dosya.DosyaYolu);
            if (File.Exists(dosyaYolu))
                File.Delete(dosyaYolu);

            _context.AracEvrakDosyalari.Remove(dosya);
            await _context.SaveChangesAsync();
        }
    }

    #endregion

    #region Evrak Uyarilari

    public async Task<List<AracEvrak>> GetSuresiDolacakEvraklarAsync(int gunSayisi = 30)
    {
        var bugun = DateTime.UtcNow.Date;
        var bitisTarihi = bugun.AddDays(gunSayisi);

        return await _context.AracEvraklari
            .Include(e => e.Arac)
            .Where(e => e.Durum == EvrakDurum.Aktif && 
                        e.BitisTarihi.HasValue && 
                        e.BitisTarihi.Value <= bitisTarihi)
            .OrderBy(e => e.BitisTarihi)
            .ToListAsync();
    }

    #endregion
}
