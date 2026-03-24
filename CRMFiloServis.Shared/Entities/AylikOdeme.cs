using System.ComponentModel.DataAnnotations;

namespace CRMFiloServis.Shared.Entities;

/// <summary>
/// Aylýk sabit ödeme planlarý (Kira, kredi taksiti vb.)
/// </summary>
public class AylikOdemePlani : BaseEntity
{
    [Required]
    public int FirmaId { get; set; }

    [Required]
    [StringLength(200)]
    public string OdemeAdi { get; set; } = string.Empty;

    public OdemeTuru Turu { get; set; }

    /// <summary>
    /// Aylýk ödeme tutarý
    /// </summary>
    [Required]
    public decimal AylikTutar { get; set; }

    /// <summary>
    /// Ayýn hangi günü ödenecek (1-31)
    /// </summary>
    [Range(1, 31)]
    public int OdemeGunu { get; set; }

    /// <summary>
    /// Baþlangýç tarihi
    /// </summary>
    public DateTime BaslangicTarihi { get; set; } = DateTime.Today;

    /// <summary>
    /// Bitiþ tarihi (null ise süresiz)
    /// </summary>
    public DateTime? BitisTarihi { get; set; }

    /// <summary>
    /// Otomatik ödeme kaydý oluþtur
    /// </summary>
    public bool OtomatikKayitOlustur { get; set; } = true;

    /// <summary>
    /// Cari hesap (varsa)
    /// </summary>
    public int? CariId { get; set; }

    /// <summary>
    /// Banka/Kasa hesabý
    /// </summary>
    public int? BankaHesapId { get; set; }

    /// <summary>
    /// Masraf kalemi
    /// </summary>
    public int? MasrafKalemiId { get; set; }

    public string? Aciklama { get; set; }

    public bool Aktif { get; set; } = true;

    // Navigation
    public virtual Firma? Firma { get; set; }
    public virtual Cari? Cari { get; set; }
    public virtual BankaHesap? BankaHesap { get; set; }
    public virtual MasrafKalemi? MasrafKalemi { get; set; }
}

/// <summary>
/// Gerçekleþen aylýk ödemeler
/// </summary>
public class AylikOdemeGerceklesen : BaseEntity
{
    [Required]
    public int AylikOdemePlaniId { get; set; }

    [Required]
    public int FirmaId { get; set; }

    /// <summary>
    /// Hangi ay/yýl için
    /// </summary>
    [Required]
    public int Yil { get; set; }

    [Required]
    [Range(1, 12)]
    public int Ay { get; set; }

    /// <summary>
    /// Planlanan tutar
    /// </summary>
    public decimal PlanlananTutar { get; set; }

    /// <summary>
    /// Ödenen tutar
    /// </summary>
    public decimal OdenenTutar { get; set; }

    /// <summary>
    /// Ödeme tarihi
    /// </summary>
    public DateTime? OdemeTarihi { get; set; }

    /// <summary>
    /// Banka/Kasa hareketi
    /// </summary>
    public int? BankaKasaHareketId { get; set; }

    /// <summary>
    /// Ödeme durumu
    /// </summary>
    public OdemeDurumu Durum { get; set; } = OdemeDurumu.Bekleniyor;

    public string? Aciklama { get; set; }

    // Navigation
    public virtual AylikOdemePlani? Plan { get; set; }
    public virtual Firma? Firma { get; set; }
    public virtual BankaKasaHareket? BankaKasaHareket { get; set; }
}

public enum OdemeTuru
{
    Kira = 1,
    KrediTaksiti = 2,
    Sigorta = 3,
    Maas = 4,
    Elektrik = 5,
    Su = 6,
    Dogalgaz = 7,
    Internet = 8,
    Telefon = 9,
    Abonelik = 10,
    Diger = 99
}

public enum OdemeDurumu
{
    Bekleniyor = 0,
    Odendi = 1,
    Gecikti = 2,
    KismiOdendi = 3,
    Iptal = 4
}
