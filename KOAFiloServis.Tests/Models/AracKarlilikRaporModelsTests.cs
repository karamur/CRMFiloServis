using KOAFiloServis.Web.Models;

namespace KOAFiloServis.Tests.Models;

public class AracKarlilikOzetTests
{
    [Fact]
    public void ToplamGider_HesaplamaDogruOlmali()
    {
        var ozet = new AracKarlilikOzet
        {
            ToplamMasraf = 5000m,
            KiraBedeli = 2000m,
            KomisyonTutari = 1000m
        };

        Assert.Equal(8000m, ozet.ToplamGider);
    }

    [Fact]
    public void NetKar_GelirEksiGider()
    {
        var ozet = new AracKarlilikOzet
        {
            ToplamGelir = 15000m,
            ToplamMasraf = 5000m,
            KiraBedeli = 2000m,
            KomisyonTutari = 1000m
        };

        Assert.Equal(7000m, ozet.NetKar);
    }

    [Fact]
    public void KarMarji_DogruYuzdeHesaplamali()
    {
        var ozet = new AracKarlilikOzet
        {
            ToplamGelir = 10000m,
            ToplamMasraf = 3000m,
            KiraBedeli = 1000m,
            KomisyonTutari = 1000m
        };

        // NetKar=5000, KarMarji=(5000/10000)*100=50
        Assert.Equal(50m, ozet.KarMarji);
    }

    [Fact]
    public void KarMarji_GelirSifirOluncaSifirDonmeli()
    {
        var ozet = new AracKarlilikOzet { ToplamGelir = 0m, ToplamMasraf = 500m };

        Assert.Equal(0m, ozet.KarMarji);
    }

    [Fact]
    public void OrtalamaGelirPerSefer_DogruHesaplamali()
    {
        var ozet = new AracKarlilikOzet { ToplamGelir = 9000m, ToplamSeferSayisi = 3 };

        Assert.Equal(3000m, ozet.OrtalamaGelirPerSefer);
    }

    [Fact]
    public void OrtalamaGelirPerSefer_SeferSifirOluncaSifirDonmeli()
    {
        var ozet = new AracKarlilikOzet { ToplamGelir = 9000m, ToplamSeferSayisi = 0 };

        Assert.Equal(0m, ozet.OrtalamaGelirPerSefer);
    }

    [Fact]
    public void OrtalamaGiderPerSefer_DogruHesaplamali()
    {
        var ozet = new AracKarlilikOzet
        {
            ToplamMasraf = 3000m,
            KiraBedeli = 1500m,
            KomisyonTutari = 500m,
            ToplamSeferSayisi = 5
        };

        // ToplamGider=5000, 5000/5=1000
        Assert.Equal(1000m, ozet.OrtalamaGiderPerSefer);
    }

    [Fact]
    public void ArizaOrani_DogruYuzdeHesaplamali()
    {
        var ozet = new AracKarlilikOzet { ArizaSayisi = 2, ToplamSeferSayisi = 10 };

        Assert.Equal(20m, ozet.ArizaOrani);
    }

    [Fact]
    public void ArizaOrani_SeferSifirOluncaSifirDonmeli()
    {
        var ozet = new AracKarlilikOzet { ArizaSayisi = 5, ToplamSeferSayisi = 0 };

        Assert.Equal(0m, ozet.ArizaOrani);
    }

    [Fact]
    public void NetKar_ZararDurumuNegatifolmali()
    {
        var ozet = new AracKarlilikOzet
        {
            ToplamGelir = 3000m,
            ToplamMasraf = 5000m,
            KiraBedeli = 1000m,
            KomisyonTutari = 500m
        };

        Assert.True(ozet.NetKar < 0);
        Assert.Equal(-3500m, ozet.NetKar);
    }
}

public class AracAylikKarlilikTests
{
    [Fact]
    public void ToplamGider_HesaplamaDogruOlmali()
    {
        var aylik = new AracAylikKarlilik
        {
            Masraf = 2000m,
            KiraBedeli = 1000m,
            Komisyon = 500m
        };

        Assert.Equal(3500m, aylik.ToplamGider);
    }

    [Fact]
    public void NetKar_GelirEksiToplamGider()
    {
        var aylik = new AracAylikKarlilik
        {
            Gelir = 10000m,
            Masraf = 3000m,
            KiraBedeli = 2000m,
            Komisyon = 1000m
        };

        Assert.Equal(4000m, aylik.NetKar);
    }

    [Fact]
    public void NetKar_ZararDurumu()
    {
        var aylik = new AracAylikKarlilik
        {
            Gelir = 1000m,
            Masraf = 3000m,
            KiraBedeli = 500m,
            Komisyon = 200m
        };

        Assert.Equal(-2700m, aylik.NetKar);
    }
}
