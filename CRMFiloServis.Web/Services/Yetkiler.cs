namespace CRMFiloServis.Web.Services;

/// <summary>
/// Sistem yetki kodlarý - Merkezi yetki tanýmlarý
/// </summary>
public static class Yetkiler
{
    // Dashboard
    public const string DashboardGoruntule = "Dashboard.Goruntule";

    // Cari
    public const string CariGoruntule = "Cari.Goruntule";
    public const string CariEkle = "Cari.Ekle";
    public const string CariDuzenle = "Cari.Duzenle";
    public const string CariSil = "Cari.Sil";

    // Araç
    public const string AracGoruntule = "Arac.Goruntule";
    public const string AracEkle = "Arac.Ekle";
    public const string AracDuzenle = "Arac.Duzenle";
    public const string AracSil = "Arac.Sil";

    // Þoför
    public const string SoforGoruntule = "Sofor.Goruntule";
    public const string SoforEkle = "Sofor.Ekle";
    public const string SoforDuzenle = "Sofor.Duzenle";
    public const string SoforSil = "Sofor.Sil";

    // Güzergah
    public const string GuzergahGoruntule = "Guzergah.Goruntule";
    public const string GuzergahEkle = "Guzergah.Ekle";
    public const string GuzergahDuzenle = "Guzergah.Duzenle";
    public const string GuzergahSil = "Guzergah.Sil";

    // Servis Çalýþma
    public const string ServisCalismaGoruntule = "ServisCalisma.Goruntule";
    public const string ServisCalismaEkle = "ServisCalisma.Ekle";
    public const string ServisCalismaDuzenle = "ServisCalisma.Duzenle";
    public const string ServisCalismaSil = "ServisCalisma.Sil";

    // Fatura
    public const string FaturaGoruntule = "Fatura.Goruntule";
    public const string FaturaEkle = "Fatura.Ekle";
    public const string FaturaDuzenle = "Fatura.Duzenle";
    public const string FaturaSil = "Fatura.Sil";

    // Finans (Banka/Kasa)
    public const string FinansGoruntule = "Finans.Goruntule";
    public const string FinansEkle = "Finans.Ekle";
    public const string FinansDuzenle = "Finans.Duzenle";
    public const string FinansSil = "Finans.Sil";

    // Bütçe
    public const string ButceGoruntule = "Butce.Goruntule";
    public const string ButceEkle = "Butce.Ekle";
    public const string ButceDuzenle = "Butce.Duzenle";
    public const string ButceSil = "Butce.Sil";

    // Rapor
    public const string RaporGoruntule = "Rapor.Goruntule";

    // Belge Uyarý
    public const string BelgeUyariGoruntule = "BelgeUyari.Goruntule";

    // Ayarlar
    public const string AyarlarGoruntule = "Ayarlar.Goruntule";
    public const string KullaniciYonetimi = "Kullanici.Yonetimi";
    public const string RolYonetimi = "Rol.Yonetimi";
    public const string FirmaAyarlari = "Firma.Ayarlari";

    // Masraf
    public const string MasrafGoruntule = "Masraf.Goruntule";
    public const string MasrafEkle = "Masraf.Ekle";
    public const string MasrafDuzenle = "Masraf.Duzenle";
    public const string MasrafSil = "Masraf.Sil";

    // Personel
    public const string PersonelGoruntule = "Personel.Goruntule";
    public const string PersonelEkle = "Personel.Ekle";
    public const string PersonelDuzenle = "Personel.Duzenle";
    public const string PersonelSil = "Personel.Sil";

    // Muhasebe
    public const string MuhasebeGoruntule = "Muhasebe.Goruntule";
    public const string MuhasebeEkle = "Muhasebe.Ekle";
    public const string MuhasebeDuzenle = "Muhasebe.Duzenle";
    public const string MuhasebeSil = "Muhasebe.Sil";

    // Satýþ
    public const string SatisGoruntule = "Satis.Goruntule";
    public const string SatisEkle = "Satis.Ekle";
    public const string SatisDuzenle = "Satis.Duzenle";
    public const string SatisSil = "Satis.Sil";

    /// <summary>
    /// Tüm yetki kodlarýný döner
    /// </summary>
    public static List<string> GetAll()
    {
        return new List<string>
        {
            // Dashboard
            DashboardGoruntule,

            // Cari
            CariGoruntule, CariEkle, CariDuzenle, CariSil,

            // Araç
            AracGoruntule, AracEkle, AracDuzenle, AracSil,

            // Þoför
            SoforGoruntule, SoforEkle, SoforDuzenle, SoforSil,

            // Güzergah
            GuzergahGoruntule, GuzergahEkle, GuzergahDuzenle, GuzergahSil,

            // Servis Çalýþma
            ServisCalismaGoruntule, ServisCalismaEkle, ServisCalismaDuzenle, ServisCalismaSil,

            // Fatura
            FaturaGoruntule, FaturaEkle, FaturaDuzenle, FaturaSil,

            // Finans
            FinansGoruntule, FinansEkle, FinansDuzenle, FinansSil,

            // Bütçe
            ButceGoruntule, ButceEkle, ButceDuzenle, ButceSil,

            // Rapor
            RaporGoruntule,

            // Belge Uyarý
            BelgeUyariGoruntule,

            // Ayarlar
            AyarlarGoruntule, KullaniciYonetimi, RolYonetimi, FirmaAyarlari,

            // Masraf
            MasrafGoruntule, MasrafEkle, MasrafDuzenle, MasrafSil,

            // Personel
            PersonelGoruntule, PersonelEkle, PersonelDuzenle, PersonelSil,

            // Muhasebe
            MuhasebeGoruntule, MuhasebeEkle, MuhasebeDuzenle, MuhasebeSil,

            // Satýþ
            SatisGoruntule, SatisEkle, SatisDuzenle, SatisSil
        };
    }

    /// <summary>
    /// Yetkileri kategorilere göre gruplanmýþ döner
    /// </summary>
    public static Dictionary<string, List<(string Kod, string Ad)>> GetGruplu()
    {
        return new Dictionary<string, List<(string Kod, string Ad)>>
        {
            ["Dashboard"] = new() { (DashboardGoruntule, "Görüntüle") },

            ["Cari"] = new()
            {
                (CariGoruntule, "Görüntüle"),
                (CariEkle, "Ekle"),
                (CariDuzenle, "Düzenle"),
                (CariSil, "Sil")
            },

            ["Araç"] = new()
            {
                (AracGoruntule, "Görüntüle"),
                (AracEkle, "Ekle"),
                (AracDuzenle, "Düzenle"),
                (AracSil, "Sil")
            },

            ["Þoför"] = new()
            {
                (SoforGoruntule, "Görüntüle"),
                (SoforEkle, "Ekle"),
                (SoforDuzenle, "Düzenle"),
                (SoforSil, "Sil")
            },

            ["Güzergah"] = new()
            {
                (GuzergahGoruntule, "Görüntüle"),
                (GuzergahEkle, "Ekle"),
                (GuzergahDuzenle, "Düzenle"),
                (GuzergahSil, "Sil")
            },

            ["Servis Çalýþma"] = new()
            {
                (ServisCalismaGoruntule, "Görüntüle"),
                (ServisCalismaEkle, "Ekle"),
                (ServisCalismaDuzenle, "Düzenle"),
                (ServisCalismaSil, "Sil")
            },

            ["Fatura"] = new()
            {
                (FaturaGoruntule, "Görüntüle"),
                (FaturaEkle, "Ekle"),
                (FaturaDuzenle, "Düzenle"),
                (FaturaSil, "Sil")
            },

            ["Finans"] = new()
            {
                (FinansGoruntule, "Görüntüle"),
                (FinansEkle, "Ekle"),
                (FinansDuzenle, "Düzenle"),
                (FinansSil, "Sil")
            },

            ["Bütçe"] = new()
            {
                (ButceGoruntule, "Görüntüle"),
                (ButceEkle, "Ekle"),
                (ButceDuzenle, "Düzenle"),
                (ButceSil, "Sil")
            },

            ["Rapor"] = new() { (RaporGoruntule, "Görüntüle") },

            ["Belge Uyarý"] = new() { (BelgeUyariGoruntule, "Görüntüle") },

            ["Ayarlar"] = new()
            {
                (AyarlarGoruntule, "Görüntüle"),
                (KullaniciYonetimi, "Kullanýcý Yönetimi"),
                (RolYonetimi, "Rol Yönetimi"),
                (FirmaAyarlari, "Firma Ayarlarý")
            },

            ["Masraf"] = new()
            {
                (MasrafGoruntule, "Görüntüle"),
                (MasrafEkle, "Ekle"),
                (MasrafDuzenle, "Düzenle"),
                (MasrafSil, "Sil")
            },

            ["Personel"] = new()
            {
                (PersonelGoruntule, "Görüntüle"),
                (PersonelEkle, "Ekle"),
                (PersonelDuzenle, "Düzenle"),
                (PersonelSil, "Sil")
            },

            ["Muhasebe"] = new()
            {
                (MuhasebeGoruntule, "Görüntüle"),
                (MuhasebeEkle, "Ekle"),
                (MuhasebeDuzenle, "Düzenle"),
                (MuhasebeSil, "Sil")
            },

            ["Satýþ"] = new()
            {
                (SatisGoruntule, "Görüntüle"),
                (SatisEkle, "Ekle"),
                (SatisDuzenle, "Düzenle"),
                (SatisSil, "Sil")
            }
        };
    }
}
