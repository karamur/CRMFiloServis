namespace CRMFiloServis.Mobile.Services;

public interface IMobileDataService
{
    Task<DashboardStats> GetDashboardStatsAsync();
}

public class MobileDataService : IMobileDataService
{
    private readonly IApiService _apiService;
    private readonly IAuthService _authService;

    public MobileDataService(IApiService apiService, IAuthService authService)
    {
        _apiService = apiService;
        _authService = authService;
    }

    public async Task<DashboardStats> GetDashboardStatsAsync()
    {
        try
        {
            // API'den veri cek
            var stats = await _apiService.GetAsync<DashboardStats>("/api/mobile/dashboard");
            if (stats != null) return stats;
        }
        catch { }

        // Demo veri dondur
        return GetDemoStats();
    }

    private DashboardStats GetDemoStats()
    {
        var role = _authService.CurrentUser?.Rol?.RolAdi ?? "";

        return new DashboardStats
        {
            // Genel
            ToplamArac = 25,
            AktifArac = 22,
            ToplamSofor = 18,
            ServistekiArac = 3,
            BekleyenFatura = 8,
            YaklaþanEvrak = 5,

            // Muhasebe
            AylikGelir = 245000,
            AylikGider = 178000,
            BankaBakiye = 520000,

            // Satis
            AylikSatis = 3,
            AktifIlan = 12,
            BekleyenTeklif = 5,
            PotansiyelMusteri = 28,

            // Sofor
            AylikGuzergah = 22,
            AylikKm = 3450,

            SoforArac = new AracBilgi
            {
                Plaka = "34 ABC 123",
                MarkaModel = "Ford Transit",
                Kilometre = 125000
            },

            BugunGuzergah = new GuzergahBilgi
            {
                GuzergahAdi = "Istanbul - Ankara",
                BaslangicNoktasi = "Kadikoy",
                BitisNoktasi = "Kizilay",
                Mesafe = 450,
                BaslamaSaati = "08:00",
                Durum = "Devam Ediyor"
            },

            // Listeler
            SonIslemler = new List<IslemBilgi>
            {
                new() { Baslik = "Fatura #F2024-001", Tip = "fatura", Tarih = DateTime.Now.AddHours(-2) },
                new() { Baslik = "Arac bakim - 34 XYZ 789", Tip = "arac", Tarih = DateTime.Now.AddHours(-5) },
                new() { Baslik = "Sofor izin - Mehmet K.", Tip = "sofor", Tarih = DateTime.Now.AddDays(-1) },
                new() { Baslik = "Yakit masrafi - 450 TL", Tip = "masraf", Tarih = DateTime.Now.AddDays(-1) },
            },

            OdenmemisFaturalar = new List<FaturaBilgi>
            {
                new() { FaturaNo = "F2024-045", CariUnvan = "ABC Lojistik", Tutar = 12500, Tarih = DateTime.Now.AddDays(-15) },
                new() { FaturaNo = "F2024-042", CariUnvan = "XYZ Nakliyat", Tutar = 8750, Tarih = DateTime.Now.AddDays(-20) },
                new() { FaturaNo = "F2024-038", CariUnvan = "Demo Sirket", Tutar = 5200, Tarih = DateTime.Now.AddDays(-25) },
            },

            SonMasraflar = new List<MasrafBilgi>
            {
                new() { Aciklama = "Yakit - 34 ABC 123", Tutar = 2500, Tarih = DateTime.Now.AddDays(-1) },
                new() { Aciklama = "Bakim - 34 XYZ 789", Tutar = 4800, Tarih = DateTime.Now.AddDays(-3) },
                new() { Aciklama = "Sigorta yenileme", Tutar = 12000, Tarih = DateTime.Now.AddDays(-7) },
            },

            GununGuzergahlari = new List<GuzergahListItem>
            {
                new() { GuzergahAdi = "Istanbul - Ankara", SoforAdi = "Ahmet Y.", Plaka = "34 ABC 123", Durum = "Devam Ediyor" },
                new() { GuzergahAdi = "Istanbul - Bursa", SoforAdi = "Mehmet K.", Plaka = "34 DEF 456", Durum = "Tamamlandi" },
                new() { GuzergahAdi = "Istanbul - Izmir", SoforAdi = "Ali V.", Plaka = "34 GHI 789", Durum = "Bekliyor" },
            },

            EvrakUyarilari = new List<EvrakUyari>
            {
                new() { EvrakTipi = "Muayene", Plaka = "34 ABC 123", BitisTarihi = DateTime.Now.AddDays(7), KalanGun = 7 },
                new() { EvrakTipi = "Sigorta", Plaka = "34 DEF 456", BitisTarihi = DateTime.Now.AddDays(15), KalanGun = 15 },
                new() { EvrakTipi = "Kasko", Plaka = "34 GHI 789", BitisTarihi = DateTime.Now.AddDays(22), KalanGun = 22 },
            },

            SonSatislar = new List<SatisBilgi>
            {
                new() { AracBilgi = "2020 VW Passat", MusteriBilgi = "Ali Kaya", Tutar = 850000, Tarih = DateTime.Now.AddDays(-5) },
                new() { AracBilgi = "2021 BMW 320i", MusteriBilgi = "Mehmet Demir", Tutar = 1250000, Tarih = DateTime.Now.AddDays(-12) },
            },

            PiyasaFirsatlari = new List<PiyasaFirsat>
            {
                new() { AracBilgi = "2022 Mercedes C200", Kaynak = "Sahibinden", Fiyat = 1450000, IndirimOrani = 8 },
                new() { AracBilgi = "2021 Audi A4", Kaynak = "Arabam.com", Fiyat = 1180000, IndirimOrani = 5 },
            },

            SoforMasraflari = new List<SoforMasraf>
            {
                new() { Tip = "Yakit", Tutar = 450, Tarih = DateTime.Now.AddDays(-1) },
                new() { Tip = "Otopark", Tutar = 50, Tarih = DateTime.Now.AddDays(-2) },
                new() { Tip = "Yemek", Tutar = 120, Tarih = DateTime.Now.AddDays(-2) },
            }
        };
    }
}

#region DTO Classes

public class DashboardStats
{
    // Genel
    public int ToplamArac { get; set; }
    public int AktifArac { get; set; }
    public int ToplamSofor { get; set; }
    public int ServistekiArac { get; set; }
    public int BekleyenFatura { get; set; }
    public int YaklaþanEvrak { get; set; }

    // Muhasebe
    public decimal AylikGelir { get; set; }
    public decimal AylikGider { get; set; }
    public decimal BankaBakiye { get; set; }

    // Satis
    public int AylikSatis { get; set; }
    public int AktifIlan { get; set; }
    public int BekleyenTeklif { get; set; }
    public int PotansiyelMusteri { get; set; }

    // Sofor
    public int AylikGuzergah { get; set; }
    public int AylikKm { get; set; }
    public AracBilgi? SoforArac { get; set; }
    public GuzergahBilgi? BugunGuzergah { get; set; }

    // Listeler
    public List<IslemBilgi> SonIslemler { get; set; } = new();
    public List<FaturaBilgi> OdenmemisFaturalar { get; set; } = new();
    public List<MasrafBilgi> SonMasraflar { get; set; } = new();
    public List<GuzergahListItem> GununGuzergahlari { get; set; } = new();
    public List<EvrakUyari> EvrakUyarilari { get; set; } = new();
    public List<SatisBilgi> SonSatislar { get; set; } = new();
    public List<PiyasaFirsat> PiyasaFirsatlari { get; set; } = new();
    public List<SoforMasraf> SoforMasraflari { get; set; } = new();
}

public class AracBilgi
{
    public string Plaka { get; set; } = "";
    public string MarkaModel { get; set; } = "";
    public int Kilometre { get; set; }
}

public class GuzergahBilgi
{
    public string GuzergahAdi { get; set; } = "";
    public string BaslangicNoktasi { get; set; } = "";
    public string BitisNoktasi { get; set; } = "";
    public int Mesafe { get; set; }
    public string BaslamaSaati { get; set; } = "";
    public string Durum { get; set; } = "";
}

public class IslemBilgi
{
    public string Baslik { get; set; } = "";
    public string Tip { get; set; } = "";
    public DateTime Tarih { get; set; }
}

public class FaturaBilgi
{
    public string FaturaNo { get; set; } = "";
    public string CariUnvan { get; set; } = "";
    public decimal Tutar { get; set; }
    public DateTime Tarih { get; set; }
}

public class MasrafBilgi
{
    public string Aciklama { get; set; } = "";
    public decimal Tutar { get; set; }
    public DateTime Tarih { get; set; }
}

public class GuzergahListItem
{
    public string GuzergahAdi { get; set; } = "";
    public string SoforAdi { get; set; } = "";
    public string Plaka { get; set; } = "";
    public string Durum { get; set; } = "";
}

public class EvrakUyari
{
    public string EvrakTipi { get; set; } = "";
    public string Plaka { get; set; } = "";
    public DateTime BitisTarihi { get; set; }
    public int KalanGun { get; set; }
}

public class SatisBilgi
{
    public string AracBilgi { get; set; } = "";
    public string MusteriBilgi { get; set; } = "";
    public decimal Tutar { get; set; }
    public DateTime Tarih { get; set; }
}

public class PiyasaFirsat
{
    public string AracBilgi { get; set; } = "";
    public string Kaynak { get; set; } = "";
    public decimal Fiyat { get; set; }
    public int IndirimOrani { get; set; }
}

public class SoforMasraf
{
    public string Tip { get; set; } = "";
    public decimal Tutar { get; set; }
    public DateTime Tarih { get; set; }
}

#endregion
