using System.ComponentModel.DataAnnotations;

namespace CRMFiloServis.Shared.Entities;

/// <summary>
/// Tekrarlayan ödeme tanýmlarý (Kira, Elektrik, Su, Doðalgaz, Ýnternet vb.)
/// Bu kayýtlar belirtilen periyotlarda otomatik olarak BudgetOdeme kayýtlarý oluþturur.
/// </summary>
public class TekrarlayanOdeme : BaseEntity
{
    [Required]
    [StringLength(200)]
    public string OdemeAdi { get; set; } = string.Empty;

    [Required]
    [StringLength(200)]
    public string MasrafKalemi { get; set; } = string.Empty;

    public string? Aciklama { get; set; }

    [Required]
    public decimal Tutar { get; set; }

    /// <summary>
    /// Tekrar periyodu
    /// </summary>
    [Required]
    public TekrarPeriyodu Periyod { get; set; } = TekrarPeriyodu.Aylik;

    /// <summary>
    /// Ayýn hangi günü ödeme yapýlacak (1-31)
    /// </summary>
    [Range(1, 31)]
    public int OdemeGunu { get; set; } = 1;

    /// <summary>
    /// Baþlangýç tarihi
    /// </summary>
    [Required]
    public DateTime BaslangicTarihi { get; set; } = DateTime.Today;

    /// <summary>
    /// Bitiþ tarihi (null ise süresiz devam eder)
    /// </summary>
    public DateTime? BitisTarihi { get; set; }

    /// <summary>
    /// Hatýrlatýcý - ödeme gününden kaç gün önce uyarý verilsin
    /// </summary>
    public int HatirlatmaGunSayisi { get; set; } = 3;

    /// <summary>
    /// Firma bilgisi
    /// </summary>
    public int? FirmaId { get; set; }
    public virtual Firma? Firma { get; set; }

    /// <summary>
    /// Aktif mi
    /// </summary>
    public bool Aktif { get; set; } = true;

    /// <summary>
    /// Renk (takvimde gösterim için)
    /// </summary>
    [StringLength(20)]
    public string? Renk { get; set; } = "#dc3545";

    /// <summary>
    /// Ýkon (Bootstrap Icons)
    /// </summary>
    [StringLength(50)]
    public string? Icon { get; set; } = "bi-arrow-repeat";

    public string? Notlar { get; set; }
}

public enum TekrarPeriyodu
{
    Aylik = 1,
    IkiAylik = 2,
    UcAylik = 3,
    AltiAylik = 6,
    Yillik = 12
}
