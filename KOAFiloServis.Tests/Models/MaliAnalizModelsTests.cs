using KOAFiloServis.Web.Models;
using KOAFiloServis.Web.Services;

namespace KOAFiloServis.Tests.Models;

public class MaliAnalizModelsTests
{
    [Fact]
    public void MaliAnalizDashboard_NetKar_GelirEksiGider()
    {
        var dashboard = new MaliAnalizDashboard
        {
            ToplamGelir = 100000m,
            ToplamGider = 60000m
        };
        Assert.Equal(40000m, dashboard.NetKar);
    }

    [Fact]
    public void MaliAnalizDashboard_KarlilikOrani_DogruHesaplanir()
    {
        var dashboard = new MaliAnalizDashboard
        {
            ToplamGelir = 100000m,
            ToplamGider = 60000m
        };
        // (40000/100000)*100 = 40
        Assert.Equal(40m, dashboard.KarlilikOrani);
    }

    [Fact]
    public void MaliAnalizDashboard_KarlilikOrani_GelirSifir_SifirDoner()
    {
        var dashboard = new MaliAnalizDashboard
        {
            ToplamGelir = 0m,
            ToplamGider = 5000m
        };
        Assert.Equal(0m, dashboard.KarlilikOrani);
    }

    [Fact]
    public void MaliAnalizDashboard_GelirDegisimOrani_ArtisDogruHesaplanir()
    {
        var dashboard = new MaliAnalizDashboard
        {
            ToplamGelir = 120000m,
            OncekiAyGelir = 100000m
        };
        // ((120000-100000)/100000)*100 = 20
        Assert.Equal(20m, dashboard.GelirDegisimOrani);
    }

    [Fact]
    public void MaliAnalizDashboard_GelirDegisimOrani_OncekiAySifir_SifirDoner()
    {
        var dashboard = new MaliAnalizDashboard
        {
            ToplamGelir = 50000m,
            OncekiAyGelir = 0m
        };
        Assert.Equal(0m, dashboard.GelirDegisimOrani);
    }

    [Fact]
    public void SegmentAnaliz_Kar_GelirEksiGider()
    {
        var segment = new SegmentAnaliz
        {
            Gelir = 50000m,
            Gider = 30000m
        };
        Assert.Equal(20000m, segment.Kar);
    }

    [Fact]
    public void SegmentAnaliz_KarlilikOrani_DogruHesaplanir()
    {
        var segment = new SegmentAnaliz
        {
            Gelir = 50000m,
            Gider = 30000m
        };
        // (20000/50000)*100 = 40
        Assert.Equal(40m, segment.KarlilikOrani);
    }

    [Fact]
    public void SegmentAnaliz_KarlilikOrani_GelirSifir_SifirDoner()
    {
        var segment = new SegmentAnaliz { Gelir = 0m, Gider = 1000m };
        Assert.Equal(0m, segment.KarlilikOrani);
    }

    [Fact]
    public void SegmentAnaliz_ZarardaKarlilik_NegatifDoner()
    {
        var segment = new SegmentAnaliz
        {
            Gelir = 10000m,
            Gider = 15000m
        };
        Assert.True(segment.Kar < 0);
        Assert.True(segment.KarlilikOrani < 0);
    }
}

public class OdemeYapRequestTests
{
    [Fact]
    public void ToplamEkMasraf_TumKesintiToplamAbsoluteDeger()
    {
        var request = new OdemeYapRequest
        {
            MasrafKesintisi = -100m,
            CezaKesintisi = -50m,
            DigerKesinti = 25m
        };
        // Math.Abs(-100) + Math.Abs(-50) + Math.Abs(25) = 175
        Assert.Equal(175m, request.ToplamEkMasraf);
    }

    [Fact]
    public void ToplamEkMasraf_SifirDegerler_SifirDoner()
    {
        var request = new OdemeYapRequest();
        Assert.Equal(0m, request.ToplamEkMasraf);
    }
}
