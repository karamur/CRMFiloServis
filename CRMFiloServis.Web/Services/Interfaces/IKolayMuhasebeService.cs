using CRMFiloServis.Shared.Entities;
using CRMFiloServis.Web.Models;

namespace CRMFiloServis.Web.Services;

public interface IKolayMuhasebeService
{
    /// <summary>
    /// İşlem türüne göre muhasebe kaydı önizlemesi oluşturur
    /// </summary>
    Task<MuhasebeOnizleme> OnizlemeOlusturAsync(KolayMuhasebeGiris giris);

    /// <summary>
    /// Girişi ve muhasebe kaydını kaydeder
    /// </summary>
    Task<KolayMuhasebeSonuc> KaydetAsync(KolayMuhasebeGiris giris, MuhasebeOnizleme? manuelOnizleme = null);

    /// <summary>
    /// Cari listesini getirir (hızlı seçim için)
    /// </summary>
    Task<List<Cari>> GetCarilerAsync(CariTipi? tip = null, string? arama = null);

    /// <summary>
    /// Masraf kalemlerini getirir
    /// </summary>
    Task<List<MasrafKalemiBasit>> GetMasrafKalemleriAsync();

    /// <summary>
    /// Banka hesaplarını getirir
    /// </summary>
    Task<List<BankaHesapBasit>> GetBankaHesaplariAsync();

    /// <summary>
    /// Araç listesini getirir (masraf için)
    /// </summary>
    Task<List<Arac>> GetAraclarAsync();

    /// <summary>
    /// Yeni cari oluşturur (hızlı oluşturma)
    /// </summary>
    Task<Cari> HizliCariOlusturAsync(string unvan, CariTipi tip);

    /// <summary>
    /// Muhasebe hesap listesi (manuel düzenleme için)
    /// </summary>
    Task<List<MuhasebeHesap>> GetMuhasebeHesaplariAsync();

    /// <summary>
    /// Varsayılan muhasebe ayarlarını getirir
    /// </summary>
    Task<MuhasebeAyar> GetMuhasebeAyarAsync();
}
