using KOAFiloServis.Web.Models;

namespace KOAFiloServis.Tests.Models;

public class FaturaHazirlikListesiTests
{
    [Fact]
    public void ToplamKesilecekTutar_KalemleriToplamal()
    {
        var liste = new FaturaHazirlikListesi
        {
            KesilecekFaturalar = new()
            {
                new() { Detaylar = new() { new() { ToplamTutar = 1000m } } },
                new() { Detaylar = new() { new() { ToplamTutar = 2000m } } }
            }
        };

        Assert.Equal(3000m, liste.ToplamKesilecekTutar);
    }

    [Fact]
    public void ToplamGelecekTutar_KalemleriToplamal()
    {
        var liste = new FaturaHazirlikListesi
        {
            GelecekFaturalar = new()
            {
                new() { Detaylar = new() { new() { ToplamTutar = 500m } } },
                new() { Detaylar = new() { new() { ToplamTutar = 700m } } }
            }
        };

        Assert.Equal(1200m, liste.ToplamGelecekTutar);
    }

    [Fact]
    public void NetKar_KesilecekEksiGelecek()
    {
        var liste = new FaturaHazirlikListesi
        {
            KesilecekFaturalar = new()
            {
                new() { Detaylar = new() { new() { ToplamTutar = 5000m } } }
            },
            GelecekFaturalar = new()
            {
                new() { Detaylar = new() { new() { ToplamTutar = 2000m } } }
            }
        };

        Assert.Equal(3000m, liste.NetKar);
    }

    [Fact]
    public void BosListelerSifirDonmeli()
    {
        var liste = new FaturaHazirlikListesi();

        Assert.Equal(0m, liste.ToplamKesilecekTutar);
        Assert.Equal(0m, liste.ToplamGelecekTutar);
        Assert.Equal(0m, liste.NetKar);
    }
}

public class KesilecekFaturaItemTests
{
    [Fact]
    public void ToplamSeferSayisi_DetaylarToplanmali()
    {
        var item = new KesilecekFaturaItem
        {
            Detaylar = new()
            {
                new() { SeferSayisi = 10 },
                new() { SeferSayisi = 5 }
            }
        };

        Assert.Equal(15, item.ToplamSeferSayisi);
    }

    [Fact]
    public void ToplamTutar_DetaylarToplanmali()
    {
        var item = new KesilecekFaturaItem
        {
            Detaylar = new()
            {
                new() { ToplamTutar = 3000m },
                new() { ToplamTutar = 4500m }
            }
        };

        Assert.Equal(7500m, item.ToplamTutar);
    }
}

public class GelecekFaturaItemTests
{
    [Fact]
    public void ToplamSeferSayisi_DetaylarToplanmali()
    {
        var item = new GelecekFaturaItem
        {
            Detaylar = new()
            {
                new() { SeferSayisi = 3 },
                new() { SeferSayisi = 7 }
            }
        };

        Assert.Equal(10, item.ToplamSeferSayisi);
    }

    [Fact]
    public void ToplamTutar_DetaylarToplanmali()
    {
        var item = new GelecekFaturaItem
        {
            Detaylar = new()
            {
                new() { ToplamTutar = 1500m },
                new() { ToplamTutar = 2500m }
            }
        };

        Assert.Equal(4000m, item.ToplamTutar);
    }
}
