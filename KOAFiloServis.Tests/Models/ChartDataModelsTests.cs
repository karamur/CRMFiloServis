using KOAFiloServis.Web.Models;

namespace KOAFiloServis.Tests.Models;

public class ChartDataModelsTests
{
    [Fact]
    public void AylikGelirGiderVeri_Net_GelirEksiGider()
    {
        var veri = new AylikGelirGiderVeri { Gelir = 10000m, Gider = 6000m };

        Assert.Equal(4000m, veri.Net);
    }

    [Fact]
    public void AylikGelirGiderVeri_Net_NegatifolabilmeMali()
    {
        var veri = new AylikGelirGiderVeri { Gelir = 3000m, Gider = 5000m };

        Assert.Equal(-2000m, veri.Net);
    }

    [Fact]
    public void AylikGelirGiderVeri_Net_SifirGelirGider()
    {
        var veri = new AylikGelirGiderVeri();

        Assert.Equal(0m, veri.Net);
    }
}
