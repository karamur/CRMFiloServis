namespace CRMFiloServis.Web.Services;

public interface IDashboardGrafikService
{
    Task<AylikGrafikData> GetAylikGelirGiderAsync(int yil);
    Task<AylikGrafikData> GetAylikSeferSayisiAsync(int yil);
    Task<List<AracPerformansData>> GetAracPerformansAsync(int yil, int ay);
    Task<List<CariPerformansData>> GetCariPerformansAsync(int yil, int ay);
}

public class AylikGrafikData
{
    public List<string> Aylar { get; set; } = new();
    public List<decimal> Veri1 { get; set; } = new(); // Gelir veya Sefer Sayýsý
    public List<decimal> Veri2 { get; set; } = new(); // Gider (opsiyonel)
    public string Veri1Label { get; set; } = string.Empty;
    public string Veri2Label { get; set; } = string.Empty;
}

public class AracPerformansData
{
    public string Plaka { get; set; } = string.Empty;
    public int SeferSayisi { get; set; }
    public decimal ToplamCiro { get; set; }
    public decimal ToplamMasraf { get; set; }
    public decimal NetKar => ToplamCiro - ToplamMasraf;
}

public class CariPerformansData
{
    public string CariUnvan { get; set; } = string.Empty;
    public int SeferSayisi { get; set; }
    public decimal ToplamCiro { get; set; }
    public decimal OdenenTutar { get; set; }
    public decimal KalanBakiye { get; set; }
}
