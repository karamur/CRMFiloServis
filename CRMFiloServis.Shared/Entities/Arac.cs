namespace CRMFiloServis.Shared.Entities;

/// <summary>
/// Araç bilgileri
/// </summary>
public class Arac : BaseEntity
{
    public string Plaka { get; set; } = string.Empty;
    public string? Marka { get; set; }
    public string? Model { get; set; }
    public int? ModelYili { get; set; }
    public string? SaseNo { get; set; }
    public string? MotorNo { get; set; }
    public string? Renk { get; set; }
    public int KoltukSayisi { get; set; }
    public AracTipi AracTipi { get; set; }
    public AracSahiplikTipi SahiplikTipi { get; set; } = AracSahiplikTipi.Ozmal;
    
    // Kiralýk araç bilgileri
    public int? KiralikCariId { get; set; } // Araç sahibi (kiralýk ise)
    public decimal? GunlukKiraBedeli { get; set; }
    public decimal? AylikKiraBedeli { get; set; }
    public decimal? SeferBasinaKiraBedeli { get; set; }
    public KiraHesaplamaTipi? KiraHesaplamaTipi { get; set; }
    
    // Komisyon bilgileri
    public bool KomisyonVar { get; set; } = false;
    public int? KomisyoncuCariId { get; set; } // Komisyoncu
    public decimal? KomisyonOrani { get; set; } // Yüzde
    public decimal? SabitKomisyonTutari { get; set; } // Sefer baþýna sabit tutar
    public KomisyonHesaplamaTipi? KomisyonHesaplamaTipi { get; set; }
    
    public DateTime? TrafikSigortaBitisTarihi { get; set; }
    public DateTime? KaskoBitisTarihi { get; set; }
    public DateTime? MuayeneBitisTarihi { get; set; }
    public int? KmDurumu { get; set; }
    public bool Aktif { get; set; } = true;
    public string? Notlar { get; set; }

    // Navigation Properties
    public virtual Cari? KiralikCari { get; set; }
    public virtual Cari? KomisyoncuCari { get; set; }
    public virtual ICollection<AracMasraf> Masraflar { get; set; } = new List<AracMasraf>();
    public virtual ICollection<ServisCalisma> ServisCalismalari { get; set; } = new List<ServisCalisma>();
}

public enum AracTipi
{
    Minibus = 1,
    Midibus = 2,
    Otobus = 3,
    Otomobil = 4,
    Panelvan = 5
}

public enum AracSahiplikTipi
{
    Ozmal = 1,
    Kiralik = 2
}

public enum KiraHesaplamaTipi
{
    Gunluk = 1,
    Aylik = 2,
    SeferBasina = 3
}

public enum KomisyonHesaplamaTipi
{
    YuzdeOrani = 1,
    SabitTutar = 2
}
