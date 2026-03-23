using CRMFiloServis.Shared.Entities;

namespace CRMFiloServis.Web.Services;

public interface IBelgeUyariService
{
    Task<BelgeUyariOzet> GetBelgeUyarilarAsync(int yaklasanGunSayisi = 30);
}

public class BelgeUyariOzet
{
    public int ToplamKritikUyari { get; set; }
    public int ToplamUyari { get; set; }

    // Personel Belgeleri
    public List<BelgeUyari> EhliyetUyarilari { get; set; } = new();
    public List<BelgeUyari> SrcUyarilari { get; set; } = new();
    public List<BelgeUyari> PsikoteknikUyarilari { get; set; } = new();
    public List<BelgeUyari> SaglikRaporuUyarilari { get; set; } = new();

    // Araç Belgeleri
    public List<BelgeUyari> MuayeneUyarilari { get; set; } = new();
    public List<BelgeUyari> KaskoUyarilari { get; set; } = new();
    public List<BelgeUyari> TrafikSigortasiUyarilari { get; set; } = new();

    public List<BelgeUyari> TumUyarilar => 
        EhliyetUyarilari
        .Concat(SrcUyarilari)
        .Concat(PsikoteknikUyarilari)
        .Concat(SaglikRaporuUyarilari)
        .Concat(MuayeneUyarilari)
        .Concat(KaskoUyarilari)
        .Concat(TrafikSigortasiUyarilari)
        .OrderBy(u => u.KalanGun)
        .ToList();
}

public class BelgeUyari
{
    public int Id { get; set; }
    public string Baslik { get; set; } = string.Empty; // Personel Adý veya Araç Plakasý
    public string BelgeTuru { get; set; } = string.Empty;
    public DateTime BitisTarihi { get; set; }
    public int KalanGun => (BitisTarihi - DateTime.Today).Days;
    public BelgeUyariSeviye Seviye => KalanGun switch
    {
        < 0 => BelgeUyariSeviye.Kritik,     // Süresi geçmiþ
        <= 7 => BelgeUyariSeviye.Acil,      // 7 gün veya daha az
        <= 30 => BelgeUyariSeviye.Uyari,    // 30 gün veya daha az
        _ => BelgeUyariSeviye.Bilgi
    };
    public string SeviyeClass => Seviye switch
    {
        BelgeUyariSeviye.Kritik => "bg-danger",
        BelgeUyariSeviye.Acil => "bg-warning text-dark",
        BelgeUyariSeviye.Uyari => "bg-info",
        _ => "bg-secondary"
    };
    public string Icon => Seviye switch
    {
        BelgeUyariSeviye.Kritik => "bi-exclamation-triangle-fill",
        BelgeUyariSeviye.Acil => "bi-exclamation-circle-fill",
        BelgeUyariSeviye.Uyari => "bi-info-circle-fill",
        _ => "bi-info-circle"
    };
}

public enum BelgeUyariSeviye
{
    Bilgi = 0,
    Uyari = 1,
    Acil = 2,
    Kritik = 3
}
