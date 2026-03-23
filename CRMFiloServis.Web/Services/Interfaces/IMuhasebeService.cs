using CRMFiloServis.Shared.Entities;

namespace CRMFiloServis.Web.Services;

public interface IMuhasebeService
{
    // Hesap Plani
    Task<List<MuhasebeHesap>> GetHesapPlaniAsync();
    Task<List<MuhasebeHesap>> GetHesaplarByGrupAsync(HesapGrubu grup);
    Task<MuhasebeHesap?> GetHesapByKodAsync(string hesapKodu);
    Task<MuhasebeHesap?> GetHesapByIdAsync(int id);
    Task<MuhasebeHesap> CreateHesapAsync(MuhasebeHesap hesap);
    Task<MuhasebeHesap> UpdateHesapAsync(MuhasebeHesap hesap);
    Task DeleteHesapAsync(int id);
    Task SeedVarsayilanHesapPlaniAsync();

    // Muhasebe Fisleri
    Task<List<MuhasebeFis>> GetFislerAsync(int yil, int? ay = null);
    Task<List<MuhasebeFis>> GetFislerByTipAsync(FisTipi tip, int yil, int? ay = null);
    Task<MuhasebeFis?> GetFisByIdAsync(int id);
    Task<MuhasebeFis> CreateFisAsync(MuhasebeFis fis);
    Task<MuhasebeFis> UpdateFisAsync(MuhasebeFis fis);
    Task DeleteFisAsync(int id);
    Task<string> GenerateNextFisNoAsync(FisTipi tip);
    Task OnayliFisAsync(int fisId);

    // Otomatik Fis Olusturma
    Task<MuhasebeFis> CreateFaturaFisiAsync(Fatura fatura);
    Task<MuhasebeFis> CreateTahsilatFisiAsync(BankaKasaHareket hareket, int faturaId);
    Task<MuhasebeFis> CreateTediyeFisiAsync(BankaKasaHareket hareket, int? faturaId = null);

    // Donemler
    Task<List<MuhasebeDonem>> GetDonemlerAsync(int yil);
    Task<MuhasebeDonem?> GetAktifDonemAsync();
    Task DonemKapatAsync(int donemId);

    // Raporlar
    Task<MuavinRapor> GetMuavinRaporuAsync(string hesapKodu, DateTime baslangic, DateTime bitis);
    Task<YevmiyeRapor> GetYevmiyeRaporuAsync(DateTime baslangic, DateTime bitis);
    Task<GelirGiderRapor> GetGelirGiderRaporuAsync(int yil, int? ay = null);
    Task<BilancoRapor> GetBilancoRaporuAsync(DateTime tarih);
    Task<MizanRapor> GetMizanRaporuAsync(DateTime baslangic, DateTime bitis);

    // Hesap Bakiyeleri
    Task<decimal> GetHesapBakiyeAsync(string hesapKodu, DateTime? tarih = null);
    Task<List<HesapBakiye>> GetHesapBakiyeleriAsync(HesapGrubu grup, DateTime? tarih = null);
}

#region Rapor Modelleri

public class MuavinRapor
{
    public string HesapKodu { get; set; } = "";
    public string HesapAdi { get; set; } = "";
    public DateTime BaslangicTarihi { get; set; }
    public DateTime BitisTarihi { get; set; }
    public decimal DevirBorc { get; set; }
    public decimal DevirAlacak { get; set; }
    public decimal ToplamBorc { get; set; }
    public decimal ToplamAlacak { get; set; }
    public decimal Bakiye { get; set; }
    public List<MuavinSatir> Satirlar { get; set; } = new();
}

public class MuavinSatir
{
    public DateTime Tarih { get; set; }
    public string FisNo { get; set; } = "";
    public string Aciklama { get; set; } = "";
    public decimal Borc { get; set; }
    public decimal Alacak { get; set; }
    public decimal Bakiye { get; set; }
}

public class YevmiyeRapor
{
    public DateTime BaslangicTarihi { get; set; }
    public DateTime BitisTarihi { get; set; }
    public decimal ToplamBorc { get; set; }
    public decimal ToplamAlacak { get; set; }
    public List<YevmiyeSatir> Satirlar { get; set; } = new();
}

public class YevmiyeSatir
{
    public int SiraNo { get; set; }
    public DateTime Tarih { get; set; }
    public string FisNo { get; set; } = "";
    public string HesapKodu { get; set; } = "";
    public string HesapAdi { get; set; } = "";
    public string Aciklama { get; set; } = "";
    public decimal Borc { get; set; }
    public decimal Alacak { get; set; }
}

public class GelirGiderRapor
{
    public int Yil { get; set; }
    public int? Ay { get; set; }
    public decimal ToplamGelir { get; set; }
    public decimal ToplamGider { get; set; }
    public decimal NetKar { get; set; }
    public List<GelirGiderKalem> Gelirler { get; set; } = new();
    public List<GelirGiderKalem> Giderler { get; set; } = new();
    public List<AylikGelirGider> AylikDetay { get; set; } = new();
}

public class GelirGiderKalem
{
    public string HesapKodu { get; set; } = "";
    public string HesapAdi { get; set; } = "";
    public decimal Tutar { get; set; }
    public decimal Yuzde { get; set; }
}

public class AylikGelirGider
{
    public int Ay { get; set; }
    public string AyAdi { get; set; } = "";
    public decimal Gelir { get; set; }
    public decimal Gider { get; set; }
    public decimal Net { get; set; }
}

public class BilancoRapor
{
    public DateTime Tarih { get; set; }
    public decimal ToplamAktif { get; set; }
    public decimal ToplamPasif { get; set; }

    // Aktif Kalemler
    public List<BilancoKalem> DonenVarliklar { get; set; } = new();
    public List<BilancoKalem> DuranVarliklar { get; set; } = new();

    // Pasif Kalemler
    public List<BilancoKalem> KisaVadeliYabanciKaynaklar { get; set; } = new();
    public List<BilancoKalem> UzunVadeliYabanciKaynaklar { get; set; } = new();
    public List<BilancoKalem> Ozkaynaklar { get; set; } = new();
}

public class BilancoKalem
{
    public string HesapKodu { get; set; } = "";
    public string HesapAdi { get; set; } = "";
    public decimal Tutar { get; set; }
    public bool AltHesapVar { get; set; }
    public List<BilancoKalem> AltKalemler { get; set; } = new();
}

public class MizanRapor
{
    public DateTime BaslangicTarihi { get; set; }
    public DateTime BitisTarihi { get; set; }
    public decimal ToplamBorc { get; set; }
    public decimal ToplamAlacak { get; set; }
    public decimal ToplamBorcBakiye { get; set; }
    public decimal ToplamAlacakBakiye { get; set; }
    public List<MizanSatir> Satirlar { get; set; } = new();
}

public class MizanSatir
{
    public string HesapKodu { get; set; } = "";
    public string HesapAdi { get; set; } = "";
    public decimal Borc { get; set; }
    public decimal Alacak { get; set; }
    public decimal BorcBakiye { get; set; }
    public decimal AlacakBakiye { get; set; }
}

public class HesapBakiye
{
    public string HesapKodu { get; set; } = "";
    public string HesapAdi { get; set; } = "";
    public decimal Borc { get; set; }
    public decimal Alacak { get; set; }
    public decimal Bakiye { get; set; }
}

#endregion
