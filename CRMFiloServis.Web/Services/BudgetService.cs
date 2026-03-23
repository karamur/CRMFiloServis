using CRMFiloServis.Shared.Entities;
using CRMFiloServis.Web.Data;
using Microsoft.EntityFrameworkCore;

namespace CRMFiloServis.Web.Services;

public class BudgetService : IBudgetService
{
    private readonly ApplicationDbContext _context;
    private static readonly string[] AyAdlari = { "", "Ocak", "Þubat", "Mart", "Nisan", "Mayýs", "Haziran", 
                                                   "Temmuz", "Aðustos", "Eylül", "Ekim", "Kasým", "Aralýk" };

    public BudgetService(ApplicationDbContext context)
    {
        _context = context;
    }

    #region Ödeme Ýþlemleri

    public async Task<List<BudgetOdeme>> GetOdemelerAsync(int yil, int? ay = null)
    {
        var query = _context.BudgetOdemeler
            .Where(o => o.OdemeYil == yil);

        if (ay.HasValue)
            query = query.Where(o => o.OdemeAy == ay.Value);

        return await query
            .OrderBy(o => o.OdemeAy)
            .ThenBy(o => o.OdemeTarihi)
            .ToListAsync();
    }

    public async Task<BudgetOdeme?> GetOdemeByIdAsync(int id)
    {
        return await _context.BudgetOdemeler.FindAsync(id);
    }

    public async Task<BudgetOdeme> CreateOdemeAsync(BudgetOdeme odeme)
    {
        odeme.OdemeAy = odeme.OdemeTarihi.Month;
        odeme.OdemeYil = odeme.OdemeTarihi.Year;

        _context.BudgetOdemeler.Add(odeme);
        await _context.SaveChangesAsync();
        return odeme;
    }

    public async Task<BudgetOdeme> UpdateOdemeAsync(BudgetOdeme odeme)
    {
        odeme.OdemeAy = odeme.OdemeTarihi.Month;
        odeme.OdemeYil = odeme.OdemeTarihi.Year;

        _context.BudgetOdemeler.Update(odeme);
        await _context.SaveChangesAsync();
        return odeme;
    }

    public async Task DeleteOdemeAsync(int id)
    {
        var odeme = await _context.BudgetOdemeler.FindAsync(id);
        if (odeme != null)
        {
            odeme.IsDeleted = true;
            await _context.SaveChangesAsync();
        }
    }

    #endregion

    #region Taksitli Ödeme Ýþlemleri

    public async Task<List<BudgetOdeme>> CreateTaksitliOdemeAsync(TaksitliOdemeRequest request)
    {
        var taksitGrupId = Guid.NewGuid();
        var taksitTutari = Math.Round(request.ToplamTutar / request.TaksitSayisi, 2);
        var taksitler = new List<BudgetOdeme>();

        // Yuvarlama farkýný son taksitte düzelt
        var toplamHesaplanan = taksitTutari * request.TaksitSayisi;
        var fark = request.ToplamTutar - toplamHesaplanan;

        for (int i = 0; i < request.TaksitSayisi; i++)
        {
            var taksitTarihi = request.BaslangicTarihi.AddMonths(i);
            var tutar = i == request.TaksitSayisi - 1 ? taksitTutari + fark : taksitTutari;

            var odeme = new BudgetOdeme
            {
                OdemeTarihi = taksitTarihi,
                OdemeAy = taksitTarihi.Month,
                OdemeYil = taksitTarihi.Year,
                MasrafKalemi = request.MasrafKalemi,
                Aciklama = request.Aciklama,
                Miktar = tutar,
                TaksitliMi = true,
                ToplamTaksitSayisi = request.TaksitSayisi,
                KacinciTaksit = i + 1,
                TaksitGrupId = taksitGrupId,
                TaksitBaslangicAy = request.BaslangicTarihi,
                TaksitBitisAy = request.BaslangicTarihi.AddMonths(request.TaksitSayisi - 1),
                Notlar = request.Notlar,
                Durum = OdemeDurum.Bekliyor
            };

            taksitler.Add(odeme);
        }

        _context.BudgetOdemeler.AddRange(taksitler);
        await _context.SaveChangesAsync();
        return taksitler;
    }

    public async Task<List<BudgetOdeme>> GetTaksitGrubuAsync(Guid taksitGrupId)
    {
        return await _context.BudgetOdemeler
            .Where(o => o.TaksitGrupId == taksitGrupId)
            .OrderBy(o => o.KacinciTaksit)
            .ToListAsync();
    }

    public async Task UpdateTaksitGrubuAsync(List<BudgetOdeme> taksitler)
    {
        foreach (var taksit in taksitler)
        {
            taksit.OdemeAy = taksit.OdemeTarihi.Month;
            taksit.OdemeYil = taksit.OdemeTarihi.Year;
            _context.BudgetOdemeler.Update(taksit);
        }
        await _context.SaveChangesAsync();
    }

    #endregion

    #region Masraf Kalemleri

    public async Task<List<BudgetMasrafKalemi>> GetMasrafKalemleriAsync()
    {
        return await _context.BudgetMasrafKalemleri
            .Where(m => m.Aktif)
            .OrderBy(m => m.SiraNo)
            .ThenBy(m => m.KalemAdi)
            .ToListAsync();
    }

    public async Task<BudgetMasrafKalemi> CreateMasrafKalemiAsync(BudgetMasrafKalemi kalem)
    {
        _context.BudgetMasrafKalemleri.Add(kalem);
        await _context.SaveChangesAsync();
        return kalem;
    }

    public async Task<BudgetMasrafKalemi> UpdateMasrafKalemiAsync(BudgetMasrafKalemi kalem)
    {
        _context.BudgetMasrafKalemleri.Update(kalem);
        await _context.SaveChangesAsync();
        return kalem;
    }

    public async Task DeleteMasrafKalemiAsync(int id)
    {
        var kalem = await _context.BudgetMasrafKalemleri.FindAsync(id);
        if (kalem != null)
        {
            kalem.IsDeleted = true;
            await _context.SaveChangesAsync();
        }
    }

    #endregion

    #region Raporlar

    public async Task<BudgetOzet> GetAylikOzetAsync(int yil, int ay)
    {
        var odemeler = await _context.BudgetOdemeler
            .Where(o => o.OdemeYil == yil && o.OdemeAy == ay)
            .ToListAsync();

        var ozet = new BudgetOzet
        {
            Yil = yil,
            Ay = ay,
            ToplamOdeme = odemeler.Sum(o => o.Miktar),
            OdenenToplam = odemeler.Where(o => o.Durum == OdemeDurum.Odendi).Sum(o => o.Miktar),
            BekleyenToplam = odemeler.Where(o => o.Durum == OdemeDurum.Bekliyor).Sum(o => o.Miktar),
            ToplamKayit = odemeler.Count,
            OdenenKayit = odemeler.Count(o => o.Durum == OdemeDurum.Odendi),
            BekleyenKayit = odemeler.Count(o => o.Durum == OdemeDurum.Bekliyor)
        };

        ozet.KategoriOzetleri = odemeler
            .GroupBy(o => o.MasrafKalemi)
            .Select(g => new BudgetKategoriOzet
            {
                MasrafKalemi = g.Key,
                Toplam = g.Sum(o => o.Miktar),
                Adet = g.Count(),
                Yuzde = ozet.ToplamOdeme > 0 ? Math.Round(g.Sum(o => o.Miktar) / ozet.ToplamOdeme * 100, 1) : 0
            })
            .OrderByDescending(k => k.Toplam)
            .ToList();

        return ozet;
    }

    public async Task<BudgetYillikOzet> GetYillikOzetAsync(int yil)
    {
        var odemeler = await _context.BudgetOdemeler
            .Where(o => o.OdemeYil == yil)
            .ToListAsync();

        var ozet = new BudgetYillikOzet
        {
            Yil = yil,
            ToplamOdeme = odemeler.Sum(o => o.Miktar)
        };

        // Aylýk toplamlar
        for (int ay = 1; ay <= 12; ay++)
        {
            var aylikOdemeler = odemeler.Where(o => o.OdemeAy == ay).ToList();
            ozet.AylikToplamlar.Add(new BudgetAylikToplam
            {
                Ay = ay,
                AyAdi = AyAdlari[ay],
                Toplam = aylikOdemeler.Sum(o => o.Miktar),
                Odenen = aylikOdemeler.Where(o => o.Durum == OdemeDurum.Odendi).Sum(o => o.Miktar),
                Bekleyen = aylikOdemeler.Where(o => o.Durum == OdemeDurum.Bekliyor).Sum(o => o.Miktar)
            });
        }

        // Kategori özetleri
        ozet.KategoriOzetleri = odemeler
            .GroupBy(o => o.MasrafKalemi)
            .Select(g => new BudgetKategoriOzet
            {
                MasrafKalemi = g.Key,
                Toplam = g.Sum(o => o.Miktar),
                Adet = g.Count(),
                Yuzde = ozet.ToplamOdeme > 0 ? Math.Round(g.Sum(o => o.Miktar) / ozet.ToplamOdeme * 100, 1) : 0
            })
            .OrderByDescending(k => k.Toplam)
            .ToList();

        return ozet;
    }

    public async Task<List<BudgetGunlukOzet>> GetTakvimDataAsync(int yil, int ay)
    {
        var odemeler = await _context.BudgetOdemeler
            .Where(o => o.OdemeYil == yil && o.OdemeAy == ay)
            .OrderBy(o => o.OdemeTarihi)
            .ToListAsync();

        var gunlukOzetler = new List<BudgetGunlukOzet>();
        var gunSayisi = DateTime.DaysInMonth(yil, ay);

        for (int gun = 1; gun <= gunSayisi; gun++)
        {
            var tarih = new DateTime(yil, ay, gun);
            var gunOdemeleri = odemeler.Where(o => o.OdemeTarihi.Day == gun).ToList();

            gunlukOzetler.Add(new BudgetGunlukOzet
            {
                Tarih = tarih,
                Gun = gun,
                ToplamOdeme = gunOdemeleri.Sum(o => o.Miktar),
                OdemeSayisi = gunOdemeleri.Count,
                Odemeler = gunOdemeleri
            });
        }

        return gunlukOzetler;
    }

    public async Task<List<BudgetKategoriOzet>> GetKategoriOzetAsync(int yil, int? ay = null)
    {
        var query = _context.BudgetOdemeler.Where(o => o.OdemeYil == yil);

        if (ay.HasValue)
            query = query.Where(o => o.OdemeAy == ay.Value);

        var odemeler = await query.ToListAsync();
        var toplam = odemeler.Sum(o => o.Miktar);

        // Masraf kalemlerinin renklerini al
        var masrafKalemleri = await _context.BudgetMasrafKalemleri
            .ToDictionaryAsync(m => m.KalemAdi, m => m.Renk);

        return odemeler
            .GroupBy(o => o.MasrafKalemi)
            .Select(g => new BudgetKategoriOzet
            {
                MasrafKalemi = g.Key,
                Renk = masrafKalemleri.TryGetValue(g.Key, out var renk) ? renk : "#6c757d",
                Toplam = g.Sum(o => o.Miktar),
                Adet = g.Count(),
                Yuzde = toplam > 0 ? Math.Round(g.Sum(o => o.Miktar) / toplam * 100, 1) : 0
            })
            .OrderByDescending(k => k.Toplam)
            .ToList();
    }

    #endregion
}
