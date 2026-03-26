using System.ComponentModel.DataAnnotations;

namespace CRMFiloServis.Shared.Entities;

#region Lisans

/// <summary>
/// Lisans Bilgileri
/// </summary>
public class Lisans : BaseEntity
{
    [Required]
    public string LisansAnahtari { get; set; } = string.Empty;

    public LisansTuru Tur { get; set; } = LisansTuru.Trial;

    public DateTime BaslangicTarihi { get; set; } = DateTime.UtcNow;
    public DateTime BitisTarihi { get; set; } = DateTime.UtcNow.AddDays(30);

    public string? FirmaAdi { get; set; }
    public string? YetkiliKisi { get; set; }
    public string? Email { get; set; }
    public string? Telefon { get; set; }

    public string MakineKodu { get; set; } = string.Empty;
    public int MaxKullaniciSayisi { get; set; } = 5;

    // Izinler
    public bool ExcelExportIzni { get; set; } = true;
    public bool PdfExportIzni { get; set; } = true;
    public bool RaporlamaIzni { get; set; } = true;
    public bool YedeklemeIzni { get; set; } = true;
    public bool MuhasebeIzni { get; set; } = true;
    public bool SatisModuluIzni { get; set; } = true;

    public string? Imza { get; set; }

    // Hesaplanan ozellikler
    public LisansDurumu Durum => DateTime.UtcNow > BitisTarihi ? LisansDurumu.SuresiDolmus : LisansDurumu.Aktif;
    public int KalanGun => Math.Max(0, (BitisTarihi.Date - DateTime.UtcNow.Date).Days);
    public bool Gecerli => Durum == LisansDurumu.Aktif && !string.IsNullOrEmpty(LisansAnahtari);
}

public enum LisansTuru
{
    Trial = 0,          // 30 gunluk deneme
    Basic = 1,          // Temel - 5 kullanici
    Professional = 2,   // Profesyonel - 10 kullanici
    Enterprise = 3      // Kurumsal - Sinirsiz
}

public enum LisansDurumu
{
    Aktif = 0,
    SuresiDolmus = 1,
    IptalEdilmis = 2,
    Gecersiz = 3
}

#endregion

#region Kullanici ve Rol

/// <summary>
/// Uygulama Kullanicisi
/// </summary>
public class Kullanici : BaseEntity
{
    [Required]
    [StringLength(50)]
    public string KullaniciAdi { get; set; } = string.Empty;

    [Required]
    public string SifreHash { get; set; } = string.Empty;

    [Required]
    [StringLength(100)]
    public string AdSoyad { get; set; } = string.Empty;

    [StringLength(100)]
    public string? Email { get; set; }

    [StringLength(20)]
    public string? Telefon { get; set; }

    public int? SoforId { get; set; } // Personel ile iliskilendirme
    public virtual Sofor? Sofor { get; set; }

    public int RolId { get; set; }
    public virtual Rol Rol { get; set; } = null!;

    public bool Aktif { get; set; } = true;
    public DateTime? SonGirisTarihi { get; set; }
    public int BasarisizGirisSayisi { get; set; } = 0;
    public bool Kilitli { get; set; } = false;

    // Tercihler
    public string Tema { get; set; } = "Default";
    public bool KompaktMod { get; set; } = false;
}

/// <summary>
/// Kullanici Rolleri
/// </summary>
public class Rol : BaseEntity
{
    [Required]
    [StringLength(50)]
    public string RolAdi { get; set; } = string.Empty;

    public string? Aciklama { get; set; }

    public string? Renk { get; set; }

    public bool SistemRolu { get; set; } = false; // Admin gibi silinemeyen roller

    // Navigation
    public virtual ICollection<Kullanici> Kullanicilar { get; set; } = new List<Kullanici>();
    public virtual ICollection<RolYetki> Yetkiler { get; set; } = new List<RolYetki>();
}

/// <summary>
/// Rol Yetkileri
/// </summary>
public class RolYetki : BaseEntity
{
    public int RolId { get; set; }
    public virtual Rol Rol { get; set; } = null!;

    [Required]
    [StringLength(100)]
    public string YetkiKodu { get; set; } = string.Empty;

    public bool Izin { get; set; } = false;
}

#endregion

#region Sistem Rolleri

/// <summary>
/// Sistem rol tanimlari - crmdestek projesinden uyarlandi
/// </summary>
public static class SistemRolleri
{
    public const string Admin = "Admin";
    public const string Muhasebeci = "Muhasebeci";
    public const string Operasyon = "Operasyon";
    public const string SatisTemsilcisi = "SatisTemsilcisi";
    public const string Sofor = "SoforRol";
    public const string Kullanici = "Kullanici";

    public static List<RolTanim> GetAllRoles()
    {
        return new List<RolTanim>
        {
            new(Admin, "Sistem Yoneticisi", "Tum sistem yetkilerine sahip tam yetkili yonetici", "#dc3545", "bi-shield-lock"),
            new(Muhasebeci, "Muhasebeci", "Butce, fatura, banka ve muhasebe islemleri", "#6f42c1", "bi-calculator"),
            new(Operasyon, "Operasyon Sorumlusu", "Arac, sofor, guzergah ve servis islemleri", "#0d6efd", "bi-truck"),
            new(SatisTemsilcisi, "Satis Temsilcisi", "Satis modulu ve piyasa arastirma", "#198754", "bi-graph-up-arrow"),
            new(Sofor, "Sofor", "Kendine atanan arac ve guzergah bilgileri", "#fd7e14", "bi-person-badge"),
            new(Kullanici, "Genel Kullanici", "Temel goruntuleme yetkilerine sahip kullanici", "#6c757d", "bi-person"),
        };
    }

    /// <summary>
    /// Role gore varsayilan yetkileri dondurur
    /// </summary>
    public static List<string> GetDefaultPermissions(string roleName)
    {
        return roleName switch
        {
            Admin => Yetkiler.GetAll(),

            Muhasebeci => new List<string>
            {
                Yetkiler.Dashboard,
                // Cari
                Yetkiler.CariGoruntule, Yetkiler.CariEkle, Yetkiler.CariDuzenle,
                // Fatura
                Yetkiler.FaturaGoruntule, Yetkiler.FaturaEkle, Yetkiler.FaturaDuzenle, Yetkiler.FaturaSil,
                // Banka
                Yetkiler.BankaGoruntule, Yetkiler.BankaEkle, Yetkiler.BankaDuzenle,
                // Butce
                Yetkiler.ButceGoruntule, Yetkiler.ButceEkle, Yetkiler.ButceDuzenle, Yetkiler.ButceSil,
                // Muhasebe
                Yetkiler.MuhasebeGoruntule, Yetkiler.MuhasebeEkle, Yetkiler.MuhasebeDuzenle,
                // Rapor
                Yetkiler.RaporGoruntule, Yetkiler.RaporExport,
                // Yedek
                Yetkiler.YedeklemeGoruntule, Yetkiler.YedeklemeOlustur,
            },

            Operasyon => new List<string>
            {
                Yetkiler.Dashboard,
                // Arac
                Yetkiler.AracGoruntule, Yetkiler.AracEkle, Yetkiler.AracDuzenle,
                // Sofor
                Yetkiler.SoforGoruntule, Yetkiler.SoforEkle, Yetkiler.SoforDuzenle,
                // Guzergah
                Yetkiler.GuzergahGoruntule, Yetkiler.GuzergahEkle, Yetkiler.GuzergahDuzenle,
                // Servis
                Yetkiler.ServisGoruntule, Yetkiler.ServisEkle, Yetkiler.ServisDuzenle,
                // Masraf
                Yetkiler.MasrafGoruntule, Yetkiler.MasrafEkle,
                // Rapor
                Yetkiler.RaporGoruntule,
            },

            SatisTemsilcisi => new List<string>
            {
                Yetkiler.Dashboard,
                Yetkiler.SatisGoruntule, Yetkiler.SatisEkle, Yetkiler.SatisDuzenle,
                Yetkiler.CariGoruntule,
                Yetkiler.RaporGoruntule,
            },

            Sofor => new List<string>
            {
                Yetkiler.Dashboard,
                Yetkiler.AracGoruntule,
                Yetkiler.GuzergahGoruntule,
                Yetkiler.ServisGoruntule,
            },

            Kullanici => new List<string>
            {
                Yetkiler.Dashboard,
                Yetkiler.CariGoruntule,
                Yetkiler.RaporGoruntule,
            },

            _ => new List<string> { Yetkiler.Dashboard }
        };
    }
}

public class RolTanim
{
    public string Name { get; set; }
    public string DisplayName { get; set; }
    public string Description { get; set; }
    public string Color { get; set; }
    public string Icon { get; set; }

    public RolTanim(string name, string displayName, string description, string color, string icon)
    {
        Name = name;
        DisplayName = displayName;
        Description = description;
        Color = color;
        Icon = icon;
    }
}

#endregion

#region Yetki Tanimlari

/// <summary>
/// Yetki Tanimlari - modullere gore gruplanmis
/// crmdestek projesindeki Permissions yapisýndan uyarlandi
/// </summary>
public static class Yetkiler
{
    // Genel
    public const string Dashboard = "dashboard";

    // Cari
    public const string CariGoruntule = "cari.goruntule";
    public const string CariEkle = "cari.ekle";
    public const string CariDuzenle = "cari.duzenle";
    public const string CariSil = "cari.sil";

    // Fatura
    public const string FaturaGoruntule = "fatura.goruntule";
    public const string FaturaEkle = "fatura.ekle";
    public const string FaturaDuzenle = "fatura.duzenle";
    public const string FaturaSil = "fatura.sil";

    // Banka/Kasa
    public const string BankaGoruntule = "banka.goruntule";
    public const string BankaEkle = "banka.ekle";
    public const string BankaDuzenle = "banka.duzenle";
    public const string BankaSil = "banka.sil";

    // Butce
    public const string ButceGoruntule = "butce.goruntule";
    public const string ButceEkle = "butce.ekle";
    public const string ButceDuzenle = "butce.duzenle";
    public const string ButceSil = "butce.sil";

    // Muhasebe
    public const string MuhasebeGoruntule = "muhasebe.goruntule";
    public const string MuhasebeEkle = "muhasebe.ekle";
    public const string MuhasebeDuzenle = "muhasebe.duzenle";

    // Arac
    public const string AracGoruntule = "arac.goruntule";
    public const string AracEkle = "arac.ekle";
    public const string AracDuzenle = "arac.duzenle";
    public const string AracSil = "arac.sil";

    // Sofor
    public const string SoforGoruntule = "sofor.goruntule";
    public const string SoforEkle = "sofor.ekle";
    public const string SoforDuzenle = "sofor.duzenle";
    public const string SoforSil = "sofor.sil";

    // Guzergah
    public const string GuzergahGoruntule = "guzergah.goruntule";
    public const string GuzergahEkle = "guzergah.ekle";
    public const string GuzergahDuzenle = "guzergah.duzenle";

    // Servis Calisma
    public const string ServisGoruntule = "servis.goruntule";
    public const string ServisEkle = "servis.ekle";
    public const string ServisDuzenle = "servis.duzenle";

    // Masraf
    public const string MasrafGoruntule = "masraf.goruntule";
    public const string MasrafEkle = "masraf.ekle";
    public const string MasrafDuzenle = "masraf.duzenle";

    // Satis
    public const string SatisGoruntule = "satis.goruntule";
    public const string SatisEkle = "satis.ekle";
    public const string SatisDuzenle = "satis.duzenle";
    public const string SatisSil = "satis.sil";

    // Raporlar
    public const string RaporGoruntule = "rapor.goruntule";
    public const string RaporExport = "rapor.export";

    // Ayarlar
    public const string AyarlarGoruntule = "ayarlar.goruntule";
    public const string AyarlarDuzenle = "ayarlar.duzenle";

    // Yonetim
    public const string KullaniciYonetimi = "kullanici.yonetim";
    public const string RolYonetimi = "rol.yonetim";
    public const string YedeklemeGoruntule = "yedekleme.goruntule";
    public const string YedeklemeOlustur = "yedekleme.olustur";
    public const string LisansYonetimi = "lisans.yonetim";
    public const string GuncellemeYonetimi = "guncelleme.yonetim";

    /// <summary>
    /// Tum yetki kodlarini dondurur
    /// </summary>
    public static List<string> GetAll()
    {
        return new List<string>
        {
            Dashboard,
            CariGoruntule, CariEkle, CariDuzenle, CariSil,
            FaturaGoruntule, FaturaEkle, FaturaDuzenle, FaturaSil,
            BankaGoruntule, BankaEkle, BankaDuzenle, BankaSil,
            ButceGoruntule, ButceEkle, ButceDuzenle, ButceSil,
            MuhasebeGoruntule, MuhasebeEkle, MuhasebeDuzenle,
            AracGoruntule, AracEkle, AracDuzenle, AracSil,
            SoforGoruntule, SoforEkle, SoforDuzenle, SoforSil,
            GuzergahGoruntule, GuzergahEkle, GuzergahDuzenle,
            ServisGoruntule, ServisEkle, ServisDuzenle,
            MasrafGoruntule, MasrafEkle, MasrafDuzenle,
            SatisGoruntule, SatisEkle, SatisDuzenle, SatisSil,
            RaporGoruntule, RaporExport,
            AyarlarGoruntule, AyarlarDuzenle,
            KullaniciYonetimi, RolYonetimi,
            YedeklemeGoruntule, YedeklemeOlustur,
            LisansYonetimi, GuncellemeYonetimi
        };
    }

    /// <summary>
    /// Yetkileri modullere gore gruplar
    /// </summary>
    public static Dictionary<string, List<YetkiTanim>> GetGrouped()
    {
        return new Dictionary<string, List<YetkiTanim>>
        {
            ["Genel"] = new()
            {
                new(Dashboard, "Dashboard", "bi-speedometer2"),
            },
            ["Cari Hesaplar"] = new()
            {
                new(CariGoruntule, "Goruntule", "bi-eye"),
                new(CariEkle, "Ekle", "bi-plus"),
                new(CariDuzenle, "Duzenle", "bi-pencil"),
                new(CariSil, "Sil", "bi-trash"),
            },
            ["Fatura"] = new()
            {
                new(FaturaGoruntule, "Goruntule", "bi-eye"),
                new(FaturaEkle, "Ekle", "bi-plus"),
                new(FaturaDuzenle, "Duzenle", "bi-pencil"),
                new(FaturaSil, "Sil", "bi-trash"),
            },
            ["Banka/Kasa"] = new()
            {
                new(BankaGoruntule, "Goruntule", "bi-eye"),
                new(BankaEkle, "Ekle", "bi-plus"),
                new(BankaDuzenle, "Duzenle", "bi-pencil"),
                new(BankaSil, "Sil", "bi-trash"),
            },
            ["Butce"] = new()
            {
                new(ButceGoruntule, "Goruntule", "bi-eye"),
                new(ButceEkle, "Ekle", "bi-plus"),
                new(ButceDuzenle, "Duzenle", "bi-pencil"),
                new(ButceSil, "Sil", "bi-trash"),
            },
            ["Muhasebe"] = new()
            {
                new(MuhasebeGoruntule, "Goruntule", "bi-eye"),
                new(MuhasebeEkle, "Ekle", "bi-plus"),
                new(MuhasebeDuzenle, "Duzenle", "bi-pencil"),
            },
            ["Arac Yonetimi"] = new()
            {
                new(AracGoruntule, "Goruntule", "bi-eye"),
                new(AracEkle, "Ekle", "bi-plus"),
                new(AracDuzenle, "Duzenle", "bi-pencil"),
                new(AracSil, "Sil", "bi-trash"),
            },
            ["Sofor Yonetimi"] = new()
            {
                new(SoforGoruntule, "Goruntule", "bi-eye"),
                new(SoforEkle, "Ekle", "bi-plus"),
                new(SoforDuzenle, "Duzenle", "bi-pencil"),
                new(SoforSil, "Sil", "bi-trash"),
            },
            ["Guzergah"] = new()
            {
                new(GuzergahGoruntule, "Goruntule", "bi-eye"),
                new(GuzergahEkle, "Ekle", "bi-plus"),
                new(GuzergahDuzenle, "Duzenle", "bi-pencil"),
            },
            ["Servis Calisma"] = new()
            {
                new(ServisGoruntule, "Goruntule", "bi-eye"),
                new(ServisEkle, "Ekle", "bi-plus"),
                new(ServisDuzenle, "Duzenle", "bi-pencil"),
            },
            ["Masraf"] = new()
            {
                new(MasrafGoruntule, "Goruntule", "bi-eye"),
                new(MasrafEkle, "Ekle", "bi-plus"),
                new(MasrafDuzenle, "Duzenle", "bi-pencil"),
            },
            ["Satis Modulu"] = new()
            {
                new(SatisGoruntule, "Goruntule", "bi-eye"),
                new(SatisEkle, "Ekle", "bi-plus"),
                new(SatisDuzenle, "Duzenle", "bi-pencil"),
                new(SatisSil, "Sil", "bi-trash"),
            },
            ["Raporlar"] = new()
            {
                new(RaporGoruntule, "Goruntule", "bi-eye"),
                new(RaporExport, "Export", "bi-download"),
            },
            ["Sistem Yonetimi"] = new()
            {
                new(AyarlarGoruntule, "Ayarlar Goruntule", "bi-gear"),
                new(AyarlarDuzenle, "Ayarlar Duzenle", "bi-gear-fill"),
                new(KullaniciYonetimi, "Kullanici Yonetimi", "bi-people"),
                new(RolYonetimi, "Rol Yonetimi", "bi-shield-check"),
                new(YedeklemeGoruntule, "Yedekleme Goruntule", "bi-database"),
                new(YedeklemeOlustur, "Yedekleme Olustur", "bi-database-add"),
                new(LisansYonetimi, "Lisans Yonetimi", "bi-key"),
                new(GuncellemeYonetimi, "Guncelleme Yonetimi", "bi-cloud-arrow-down"),
            },
        };
    }
}

public class YetkiTanim
{
    public string Kod { get; set; }
    public string Adi { get; set; }
    public string Icon { get; set; }

    public YetkiTanim(string kod, string adi, string icon)
    {
        Kod = kod;
        Adi = adi;
        Icon = icon;
    }
}

#endregion
