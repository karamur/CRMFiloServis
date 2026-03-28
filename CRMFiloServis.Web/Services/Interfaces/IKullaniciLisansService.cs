using CRMFiloServis.Shared.Entities;

namespace CRMFiloServis.Web.Services;

public interface ILisansService
{
    // Lisans Yonetimi
    Task<Lisans?> GetAktifLisansAsync();
    Task<bool> LisansGecerliMiAsync();
    Task<Lisans> AktiveLisansAsync(string lisansAnahtari);
    Task<int> KalanGunAsync();
    Task<string> GetMakineKoduAsync();

    // Trial
    Task<Lisans> OlusturTrialLisansAsync();

    // Uretici
    string UretLisansAnahtari(string firmaAdi, string yetkiliKisi, string email, string telefon, string lisansTipi, int maxKullanici, string makineKodu, DateTime bitisTarihi);

    // Kontroller
    Task<bool> KullanicLimitiKontrolAsync();
    Task<bool> ModulIzniVarMiAsync(string modulAdi);
}
