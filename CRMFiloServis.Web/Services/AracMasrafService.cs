using CRMFiloServis.Shared.Entities;
using CRMFiloServis.Web.Data;
using Microsoft.EntityFrameworkCore;

namespace CRMFiloServis.Web.Services;

public class AracMasrafService : IAracMasrafService
{
    private readonly ApplicationDbContext _context;
    private readonly IMuhasebeService _muhasebeService;

    public AracMasrafService(ApplicationDbContext context, IMuhasebeService muhasebeService)
    {
        _context = context;
        _muhasebeService = muhasebeService;
    }

    public async Task<List<AracMasraf>> GetAllAsync()
    {
        return await _context.AracMasraflari
            .Include(m => m.Arac)
            .Include(m => m.MasrafKalemi)
            .Include(m => m.Guzergah)
            .Include(m => m.Sofor)
            .Include(m => m.Cari)
            .Include(m => m.MuhasebeFis)
            .OrderByDescending(m => m.MasrafTarihi)
            .ToListAsync();
    }

    public async Task<List<AracMasraf>> GetByAracIdAsync(int aracId)
    {
        return await _context.AracMasraflari
            .Include(m => m.MasrafKalemi)
            .Include(m => m.Guzergah)
            .Include(m => m.Sofor)
            .Include(m => m.Cari)
            .Where(m => m.AracId == aracId)
            .OrderByDescending(m => m.MasrafTarihi)
            .ToListAsync();
    }

    public async Task<List<AracMasraf>> GetByDateRangeAsync(DateTime startDate, DateTime endDate)
    {
        return await _context.AracMasraflari
            .Include(m => m.Arac)
            .Include(m => m.MasrafKalemi)
            .Include(m => m.Guzergah)
            .Include(m => m.Sofor)
            .Include(m => m.Cari)
            .Where(m => m.MasrafTarihi >= startDate && m.MasrafTarihi <= endDate)
            .OrderByDescending(m => m.MasrafTarihi)
            .ToListAsync();
    }

    public async Task<List<AracMasraf>> GetByAracAndDateRangeAsync(int aracId, DateTime startDate, DateTime endDate)
    {
        return await _context.AracMasraflari
            .Include(m => m.MasrafKalemi)
            .Include(m => m.Guzergah)
            .Include(m => m.Sofor)
            .Include(m => m.Cari)
            .Where(m => m.AracId == aracId && m.MasrafTarihi >= startDate && m.MasrafTarihi <= endDate)
            .OrderByDescending(m => m.MasrafTarihi)
            .ToListAsync();
    }

    public async Task<List<AracMasraf>> GetArizaMasraflariAsync()
    {
        return await _context.AracMasraflari
            .Include(m => m.Arac)
            .Include(m => m.MasrafKalemi)
            .Include(m => m.Guzergah)
            .Include(m => m.ServisCalisma)
            .Include(m => m.Sofor)
            .Include(m => m.Cari)
            .Where(m => m.ArizaKaynaklimi)
            .OrderByDescending(m => m.MasrafTarihi)
            .ToListAsync();
    }

    public async Task<AracMasraf?> GetByIdAsync(int id)
    {
        return await _context.AracMasraflari
            .Include(m => m.Arac)
            .Include(m => m.MasrafKalemi)
            .Include(m => m.Guzergah)
            .Include(m => m.ServisCalisma)
            .Include(m => m.Sofor)
            .Include(m => m.Cari)
            .Include(m => m.MuhasebeFis)
            .FirstOrDefaultAsync(m => m.Id == id);
    }

    public async Task<AracMasraf> CreateAsync(AracMasraf aracMasraf)
    {
        ValidateMuhtapSecimi(aracMasraf);

        _context.AracMasraflari.Add(aracMasraf);
        await _context.SaveChangesAsync();

        await MuhasebeFisSenkronizeEtAsync(aracMasraf.Id);
        return (await GetByIdAsync(aracMasraf.Id))!;
    }

    public async Task<AracMasraf> UpdateAsync(AracMasraf aracMasraf)
    {
        ValidateMuhtapSecimi(aracMasraf);

        var existing = await _context.AracMasraflari
            .FirstOrDefaultAsync(m => m.Id == aracMasraf.Id);

        if (existing == null)
            throw new InvalidOperationException("Masraf kaydı bulunamadı.");

        existing.MasrafTarihi = aracMasraf.MasrafTarihi;
        existing.Tutar = aracMasraf.Tutar;
        existing.Aciklama = aracMasraf.Aciklama;
        existing.BelgeNo = aracMasraf.BelgeNo;
        existing.ArizaKaynaklimi = aracMasraf.ArizaKaynaklimi;
        existing.AracId = aracMasraf.AracId;
        existing.MasrafKalemiId = aracMasraf.MasrafKalemiId;
        existing.GuzergahId = aracMasraf.GuzergahId;
        existing.ServisCalismaId = aracMasraf.ServisCalismaId;
        existing.SoforId = aracMasraf.SoforId;
        existing.CariId = aracMasraf.CariId;
        existing.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();
        await MuhasebeFisSenkronizeEtAsync(existing.Id);

        return (await GetByIdAsync(existing.Id))!;
    }

    public async Task DeleteAsync(int id)
    {
        var aracMasraf = await _context.AracMasraflari
            .FirstOrDefaultAsync(m => m.Id == id);

        if (aracMasraf == null)
            return;

        if (aracMasraf.MuhasebeFisId.HasValue)
        {
            await _muhasebeService.DeleteFisAsync(aracMasraf.MuhasebeFisId.Value);
            aracMasraf.MuhasebeFisId = null;
        }

        aracMasraf.IsDeleted = true;
        aracMasraf.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
    }

    public async Task<decimal> GetToplamMasrafByAracAsync(int aracId, DateTime? startDate = null, DateTime? endDate = null)
    {
        var query = _context.AracMasraflari.Where(m => m.AracId == aracId);

        if (startDate.HasValue)
            query = query.Where(m => m.MasrafTarihi >= startDate.Value);

        if (endDate.HasValue)
            query = query.Where(m => m.MasrafTarihi <= endDate.Value);

        return await query.SumAsync(m => m.Tutar);
    }

    private static void ValidateMuhtapSecimi(AracMasraf aracMasraf)
    {
        if (aracMasraf.SoforId.HasValue && aracMasraf.CariId.HasValue)
            throw new InvalidOperationException("Aynı masraf kaydı için hem personel hem cari seçilemez.");
    }

    private async Task MuhasebeFisSenkronizeEtAsync(int aracMasrafId)
    {
        var aracMasraf = await _context.AracMasraflari
            .Include(m => m.Arac)
            .Include(m => m.MasrafKalemi)
            .Include(m => m.Sofor)
            .Include(m => m.Cari)
            .FirstOrDefaultAsync(m => m.Id == aracMasrafId);

        if (aracMasraf == null || aracMasraf.Tutar <= 0)
            return;

        var giderHesabi = await GetMasrafHesabiAsync(aracMasraf.MasrafKalemi?.Kategori ?? MasrafKategori.Diger);
        var karsiHesap = await GetKarsiHesapAsync(aracMasraf);
        var mevcutFis = aracMasraf.MuhasebeFisId.HasValue
            ? await _muhasebeService.GetFisByIdAsync(aracMasraf.MuhasebeFisId.Value)
            : null;

        var fis = new MuhasebeFis
        {
            Id = mevcutFis?.Id ?? 0,
            FisNo = mevcutFis?.FisNo ?? await _muhasebeService.GenerateNextFisNoAsync(FisTipi.Mahsup),
            FisTarihi = aracMasraf.MasrafTarihi,
            FisTipi = FisTipi.Mahsup,
            Aciklama = BuildFisAciklamasi(aracMasraf),
            Kaynak = FisKaynak.Otomatik,
            KaynakId = aracMasraf.Id,
            KaynakTip = "AracMasraf",
            Durum = mevcutFis?.Durum ?? FisDurum.Taslak,
            Kalemler = new List<MuhasebeFisKalem>
            {
                new()
                {
                    HesapId = giderHesabi.Id,
                    Borc = aracMasraf.Tutar,
                    Alacak = 0,
                    SiraNo = 1,
                    Aciklama = BuildFisAciklamasi(aracMasraf),
                    CariId = aracMasraf.CariId
                },
                new()
                {
                    HesapId = karsiHesap.Id,
                    Borc = 0,
                    Alacak = aracMasraf.Tutar,
                    SiraNo = 2,
                    Aciklama = BuildKarsiHesapAciklamasi(aracMasraf),
                    CariId = aracMasraf.CariId
                }
            }
        };

        if (mevcutFis == null)
        {
            var createdFis = await _muhasebeService.CreateFisAsync(fis);
            aracMasraf.MuhasebeFisId = createdFis.Id;
            await _context.SaveChangesAsync();
            return;
        }

        await _muhasebeService.UpdateFisAsync(fis);
    }

    private async Task<MuhasebeHesap> GetMasrafHesabiAsync(MasrafKategori kategori)
    {
        var hesapKodu = kategori switch
        {
            MasrafKategori.Yakit => "770.06",
            MasrafKategori.Bakim => "770.07",
            MasrafKategori.Tamir => "770.07",
            MasrafKategori.Lastik => "770.07",
            MasrafKategori.YedekParca => "770.07",
            MasrafKategori.Sigorta => "770.08",
            MasrafKategori.Personel => "770.09",
            _ => "770"
        };

        return await _muhasebeService.GetHesapByKodAsync(hesapKodu)
            ?? await _muhasebeService.GetHesapByKodAsync("770")
            ?? throw new InvalidOperationException("Masraf için uygun muhasebe hesabı bulunamadı.");
    }

    private async Task<MuhasebeHesap> GetKarsiHesapAsync(AracMasraf aracMasraf)
    {
        if (aracMasraf.SoforId.HasValue)
            return await GetOrCreatePersonelHesapAsync(aracMasraf.SoforId.Value);

        if (aracMasraf.CariId.HasValue)
            return await GetOrCreateCariHesapAsync(aracMasraf.CariId.Value);

        return await _muhasebeService.GetHesapByKodAsync("100.01")
            ?? await _muhasebeService.GetHesapByKodAsync("100")
            ?? throw new InvalidOperationException("Kasa hesabı bulunamadı.");
    }

    private async Task<MuhasebeHesap> GetOrCreateCariHesapAsync(int cariId)
    {
        var anaHesap = await _muhasebeService.GetHesapByKodAsync("320")
            ?? throw new InvalidOperationException("320 Satıcılar hesabı bulunamadı.");

        var cari = await _context.Cariler.IgnoreQueryFilters().FirstOrDefaultAsync(c => c.Id == cariId)
            ?? throw new InvalidOperationException("Cari bulunamadı.");

        var hesapKodu = $"320.{cari.CariKodu}";
        var mevcut = await _muhasebeService.GetHesapByKodAsync(hesapKodu);
        if (mevcut != null)
            return mevcut;

        anaHesap.AltHesapVar = true;
        await _context.SaveChangesAsync();

        return await _muhasebeService.CreateHesapAsync(new MuhasebeHesap
        {
            HesapKodu = hesapKodu,
            HesapAdi = cari.Unvan,
            HesapTuru = anaHesap.HesapTuru,
            HesapGrubu = anaHesap.HesapGrubu,
            UstHesapId = anaHesap.Id,
            CreatedAt = DateTime.UtcNow
        });
    }

    private async Task<MuhasebeHesap> GetOrCreatePersonelHesapAsync(int soforId)
    {
        var anaHesap = await _muhasebeService.GetHesapByKodAsync("335")
            ?? throw new InvalidOperationException("335 Personellere Borçlar hesabı bulunamadı.");

        var sofor = await _context.Soforler.IgnoreQueryFilters().FirstOrDefaultAsync(s => s.Id == soforId)
            ?? throw new InvalidOperationException("Personel bulunamadı.");

        var altKod = string.IsNullOrWhiteSpace(sofor.SoforKodu) ? sofor.Id.ToString() : sofor.SoforKodu.Replace(" ", string.Empty);
        var hesapKodu = $"335.{altKod}";
        var mevcut = await _muhasebeService.GetHesapByKodAsync(hesapKodu);
        if (mevcut != null)
            return mevcut;

        anaHesap.AltHesapVar = true;
        await _context.SaveChangesAsync();

        return await _muhasebeService.CreateHesapAsync(new MuhasebeHesap
        {
            HesapKodu = hesapKodu,
            HesapAdi = sofor.TamAd,
            HesapTuru = anaHesap.HesapTuru,
            HesapGrubu = anaHesap.HesapGrubu,
            UstHesapId = anaHesap.Id,
            CreatedAt = DateTime.UtcNow
        });
    }

    private static string BuildFisAciklamasi(AracMasraf aracMasraf)
    {
        var muhatap = aracMasraf.Sofor?.TamAd ?? aracMasraf.Cari?.Unvan ?? "Kasa";
        var belge = string.IsNullOrWhiteSpace(aracMasraf.BelgeNo) ? string.Empty : $" / Belge: {aracMasraf.BelgeNo}";
        return $"Araç masrafı - {aracMasraf.Arac?.AktifPlaka} - {aracMasraf.MasrafKalemi?.MasrafAdi} - {muhatap}{belge}";
    }

    private static string BuildKarsiHesapAciklamasi(AracMasraf aracMasraf)
    {
        if (aracMasraf.Sofor != null)
            return $"Personel fişi: {aracMasraf.Sofor.TamAd}";

        if (aracMasraf.Cari != null)
            return $"Cari masrafı: {aracMasraf.Cari.Unvan}";

        return "Kasa karşılığı";
    }
}
