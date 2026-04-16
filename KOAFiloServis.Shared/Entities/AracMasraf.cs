using System.ComponentModel.DataAnnotations.Schema;

namespace KOAFiloServis.Shared.Entities;

/// <summary>
/// Araç masraf girişleri
/// </summary>
public class AracMasraf : BaseEntity
{
    public DateTime MasrafTarihi { get; set; }
    public decimal Tutar { get; set; }
    public string? Aciklama { get; set; }
    public string? BelgeNo { get; set; } // Fatura/Fiş numarası
    public bool ArizaKaynaklimi { get; set; } = false; // Arıza nedeniyle mi?

    /// <summary>
    /// Ödeme kaynağı (Kasa, Banka, Personel Cebinden)
    /// </summary>
    public MasrafOdemeKaynak OdemeKaynak { get; set; } = MasrafOdemeKaynak.Kasa;

    /// <summary>
    /// Personel cebinden ödendiyse hangi personel
    /// </summary>
    public int? PersonelCebindenId { get; set; }
    public virtual Sofor? PersonelCebinden { get; set; }

    /// <summary>
    /// Personele geri ödeme yapıldı mı?
    /// </summary>
    public bool PersoneleOdendi { get; set; } = false;

    /// <summary>
    /// Geri ödeme tarihi
    /// </summary>
    public DateTime? PersonelOdemeTarihi { get; set; }

    /// <summary>
    /// Ödeme yapılan banka/kasa hesabı
    /// </summary>
    public int? BankaHesapId { get; set; }
    public virtual BankaHesap? BankaHesap { get; set; }

    // Foreign Keys
    public int AracId { get; set; }
    public int MasrafKalemiId { get; set; }
    public int? GuzergahId { get; set; } // Arıza kaynaklı personel ulaşım masrafları için
    public int? ServisCalismaId { get; set; } // İlgili servis çalışması
    public int? SoforId { get; set; }
    public int? CariId { get; set; }
    public int? MuhasebeFisId { get; set; }

    // Navigation Properties
    public virtual Arac Arac { get; set; } = null!;
    public virtual MasrafKalemi MasrafKalemi { get; set; } = null!;
    public virtual Guzergah? Guzergah { get; set; }
    public virtual ServisCalisma? ServisCalisma { get; set; }
    public virtual Sofor? Sofor { get; set; }
    public virtual Cari? Cari { get; set; }
    public virtual MuhasebeFis? MuhasebeFis { get; set; }

    /// <summary>
    /// Personel cebinden harcama mı?
    /// </summary>
    [NotMapped]
    public bool IsPersonelCebinden => OdemeKaynak == MasrafOdemeKaynak.PersonelCebinden;
}

/// <summary>
/// Masraf ödeme kaynağı
/// </summary>
public enum MasrafOdemeKaynak
{
    Kasa = 1,
    Banka = 2,
    PersonelCebinden = 3
}
