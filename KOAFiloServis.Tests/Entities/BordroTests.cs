using KOAFiloServis.Shared.Entities;

namespace KOAFiloServis.Tests.Entities;

public class BordroTests
{
    [Fact]
    public void GenelToplam_NetMaasVeEkOdemeToplami()
    {
        var bordro = new Bordro
        {
            ToplamNetMaas = 50000m,
            ToplamEkOdeme = 10000m
        };
        Assert.Equal(60000m, bordro.GenelToplam);
    }

    [Fact]
    public void DonemeAdi_DogruFormat()
    {
        var bordro = new Bordro { Ay = 3, Yil = 2025 };
        Assert.Equal("3/2025", bordro.DonemeAdi);
    }
}

public class BordroDetayTests
{
    [Fact]
    public void ToplamKesinti_TumKesintilerinToplami()
    {
        var detay = new BordroDetay
        {
            SgkIssizlikKesinti = 1000m,
            GelirVergisi = 500m,
            DamgaVergisi = 100m
        };
        Assert.Equal(1600m, detay.ToplamKesinti);
    }

    [Fact]
    public void ToplamEkOdeme_TumEkOdemelerinToplami()
    {
        var detay = new BordroDetay
        {
            YemekYardimi = 200m,
            YolYardimi = 150m,
            PrimTutar = 500m,
            DigerEkOdeme = 100m
        };
        Assert.Equal(950m, detay.ToplamEkOdeme);
    }

    [Fact]
    public void ToplamOdenecek_NetMaasArtEkOdemeArtEkodeme()
    {
        var detay = new BordroDetay
        {
            NetMaas = 10000m,
            EkOdeme = 5000m,
            YemekYardimi = 200m,
            YolYardimi = 100m,
            PrimTutar = 0m,
            DigerEkOdeme = 0m
        };
        // ToplamOdenecek = NetMaas + ToplamEkOdeme + EkOdeme
        // = 10000 + (200+100+0+0) + 5000 = 15300
        Assert.Equal(15300m, detay.ToplamOdenecek);
    }

    [Fact]
    public void ToplamKesinti_SifirDegerlerle_SifirDoner()
    {
        var detay = new BordroDetay();
        Assert.Equal(0m, detay.ToplamKesinti);
    }
}
