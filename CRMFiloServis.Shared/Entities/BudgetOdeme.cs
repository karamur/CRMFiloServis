using System.ComponentModel.DataAnnotations;

namespace CRMFiloServis.Shared.Entities;

/// <summary>
/// Bütçe Ödeme Kaydý
/// </summary>
public class BudgetOdeme : BaseEntity
{
    [Required]
    public DateTime OdemeTarihi { get; set; }

    [Required]
    public int OdemeAy { get; set; } // 1-12

    [Required]
    public int OdemeYil { get; set; }

    [Required]
    public string MasrafKalemi { get; set; } = string.Empty;

    public string? Aciklama { get; set; }

    [Required]
    public decimal Miktar { get; set; }

    // Taksit bilgileri
    public bool TaksitliMi { get; set; } = false;
    public int ToplamTaksitSayisi { get; set; } = 1;
    public int KacinciTaksit { get; set; } = 1;
    public Guid? TaksitGrupId { get; set; } // Ayný taksit grubundaki ödemeleri baðlar

    public DateTime? TaksitBaslangicAy { get; set; }
    public DateTime? TaksitBitisAy { get; set; }

    public OdemeDurum Durum { get; set; } = OdemeDurum.Bekliyor;

    public string? Notlar { get; set; }

    // Hesaplanan alanlar
    public int KalanTaksitSayisi => ToplamTaksitSayisi - KacinciTaksit;
    public decimal ToplamTaksitTutari => Miktar * ToplamTaksitSayisi;
}

public enum OdemeDurum
{
    Bekliyor = 1,
    Odendi = 2,
    Iptal = 3,
    Ertelendi = 4
}

/// <summary>
/// Bütçe Masraf Kalemleri
/// </summary>
public class BudgetMasrafKalemi : BaseEntity
{
    [Required]
    public string KalemAdi { get; set; } = string.Empty;

    public string? Kategori { get; set; }

    public string? Renk { get; set; } = "#007bff"; // Grafik rengi

    public string? Icon { get; set; } = "bi-cash";

    public bool Aktif { get; set; } = true;

    public int SiraNo { get; set; }
}
