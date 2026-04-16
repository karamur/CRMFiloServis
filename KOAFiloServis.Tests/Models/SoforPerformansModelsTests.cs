using KOAFiloServis.Web.Models;

namespace KOAFiloServis.Tests.Models;

public class SoforPerformansOzetTests
{
    [Fact]
    public void OrtalamaGunlukKazanc_DogruHesaplanmali()
    {
        var ozet = new SoforPerformansOzet { ToplamKazanc = 9000m, CalistigiGunSayisi = 30 };

        Assert.Equal(300m, ozet.OrtalamaGunlukKazanc);
    }

    [Fact]
    public void OrtalamaGunlukKazanc_GunSifirOluncaSifir()
    {
        var ozet = new SoforPerformansOzet { ToplamKazanc = 9000m, CalistigiGunSayisi = 0 };

        Assert.Equal(0m, ozet.OrtalamaGunlukKazanc);
    }

    [Fact]
    public void OrtalamaSeferBasiKazanc_DogruHesaplanmali()
    {
        var ozet = new SoforPerformansOzet { ToplamKazanc = 5000m, ToplamSeferSayisi = 25 };

        Assert.Equal(200m, ozet.OrtalamaSeferBasiKazanc);
    }

    [Fact]
    public void OrtalamaSeferBasiKazanc_SeferSifirOluncaSifir()
    {
        var ozet = new SoforPerformansOzet { ToplamKazanc = 5000m, ToplamSeferSayisi = 0 };

        Assert.Equal(0m, ozet.OrtalamaSeferBasiKazanc);
    }

    [Fact]
    public void ArizaOrani_DogruYuzdeHesaplanmali()
    {
        var ozet = new SoforPerformansOzet { ArizaliSeferSayisi = 5, ToplamSeferSayisi = 50 };

        Assert.Equal(10m, ozet.ArizaOrani);
    }

    [Fact]
    public void ArizaOrani_SeferSifirOluncaSifir()
    {
        var ozet = new SoforPerformansOzet { ArizaliSeferSayisi = 3, ToplamSeferSayisi = 0 };

        Assert.Equal(0m, ozet.ArizaOrani);
    }

    [Fact]
    public void OrtalamaKmPerSefer_DogruHesaplanmali()
    {
        var ozet = new SoforPerformansOzet { ToplamKm = 1000, ToplamSeferSayisi = 20 };

        Assert.Equal(50m, ozet.OrtalamaKmPerSefer);
    }

    [Fact]
    public void OrtalamaKmPerSefer_KmNullOluncaNull()
    {
        var ozet = new SoforPerformansOzet { ToplamKm = null, ToplamSeferSayisi = 20 };

        Assert.Null(ozet.OrtalamaKmPerSefer);
    }

    [Fact]
    public void OrtalamaKmPerSefer_SeferSifirOluncaNull()
    {
        var ozet = new SoforPerformansOzet { ToplamKm = 1000, ToplamSeferSayisi = 0 };

        Assert.Null(ozet.OrtalamaKmPerSefer);
    }
}

public class SoforGuzergahPerformansiTests
{
    [Fact]
    public void OrtalamaKazanc_DogruHesaplanmali()
    {
        var perf = new SoforGuzergahPerformansi { ToplamKazanc = 6000m, SeferSayisi = 20 };

        Assert.Equal(300m, perf.OrtalamaKazanc);
    }

    [Fact]
    public void OrtalamaKazanc_SeferSifirOluncaSifir()
    {
        var perf = new SoforGuzergahPerformansi { ToplamKazanc = 6000m, SeferSayisi = 0 };

        Assert.Equal(0m, perf.OrtalamaKazanc);
    }
}
