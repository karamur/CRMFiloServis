using KOAFiloServis.Web.Models;

namespace KOAFiloServis.Tests.Models;

public class KolayMuhasebeGirisTests
{
    [Fact]
    public void OdenecekTutar_TevkifatsizGenelToplam()
    {
        var giris = new KolayMuhasebeGiris { GenelToplam = 1200m, TevkifatliMi = false };

        Assert.Equal(1200m, giris.OdenecekTutar);
    }

    [Fact]
    public void OdenecekTutar_TevkifatliGenelEksiTevkifat()
    {
        var giris = new KolayMuhasebeGiris
        {
            GenelToplam = 1200m,
            TevkifatliMi = true,
            TevkifatTutar = 200m
        };

        Assert.Equal(1000m, giris.OdenecekTutar);
    }
}

public class MuhasebeOnizlemeTests
{
    [Fact]
    public void ToplamBorc_KalemleriToplamal()
    {
        var onizleme = new MuhasebeOnizleme
        {
            Kalemler = new()
            {
                new() { Borc = 500m },
                new() { Borc = 300m }
            }
        };

        Assert.Equal(800m, onizleme.ToplamBorc);
    }

    [Fact]
    public void ToplamAlacak_KalemleriToplamal()
    {
        var onizleme = new MuhasebeOnizleme
        {
            Kalemler = new()
            {
                new() { Alacak = 500m },
                new() { Alacak = 300m }
            }
        };

        Assert.Equal(800m, onizleme.ToplamAlacak);
    }

    [Fact]
    public void Dengeli_BorcAlacakEsitTrue()
    {
        var onizleme = new MuhasebeOnizleme
        {
            Kalemler = new()
            {
                new() { Borc = 1000m },
                new() { Alacak = 1000m }
            }
        };

        Assert.True(onizleme.Dengeli);
    }

    [Fact]
    public void Dengeli_FarkBuyukOluncaFalse()
    {
        var onizleme = new MuhasebeOnizleme
        {
            Kalemler = new()
            {
                new() { Borc = 1000m },
                new() { Alacak = 500m }
            }
        };

        Assert.False(onizleme.Dengeli);
    }
}

public class KolayFaturaKalemTests
{
    [Fact]
    public void AraTutar_MiktarCarpiBirimFiyat()
    {
        var kalem = new KolayFaturaKalem { Miktar = 3, BirimFiyat = 100.50m };

        Assert.Equal(301.50m, kalem.AraTutar);
    }

    [Fact]
    public void KdvTutar_AraTutarCarpiKdvOrani()
    {
        var kalem = new KolayFaturaKalem { Miktar = 1, BirimFiyat = 1000m, KdvOrani = 20 };

        Assert.Equal(200m, kalem.KdvTutar);
    }

    [Fact]
    public void ToplamTutar_AraPlusKdv()
    {
        var kalem = new KolayFaturaKalem { Miktar = 2, BirimFiyat = 500m, KdvOrani = 20 };

        // AraTutar=1000, KdvTutar=200
        Assert.Equal(1200m, kalem.ToplamTutar);
    }

    [Fact]
    public void KdvSifirOlunca_ToplamEsitAra()
    {
        var kalem = new KolayFaturaKalem { Miktar = 5, BirimFiyat = 200m, KdvOrani = 0 };

        Assert.Equal(1000m, kalem.AraTutar);
        Assert.Equal(0m, kalem.KdvTutar);
        Assert.Equal(1000m, kalem.ToplamTutar);
    }
}
