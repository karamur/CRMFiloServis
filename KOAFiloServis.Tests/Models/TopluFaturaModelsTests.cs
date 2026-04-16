using KOAFiloServis.Web.Models;

namespace KOAFiloServis.Tests.Models;

public class TopluFaturaOnizlemeTests
{
    [Fact]
    public void AraToplam_KalemTutarlariniToplamal()
    {
        var onizleme = new TopluFaturaOnizleme
        {
            Kalemler = new()
            {
                new() { Miktar = 1, BirimFiyat = 1000m, KdvOrani = 20 },
                new() { Miktar = 1, BirimFiyat = 2000m, KdvOrani = 20 }
            }
        };

        Assert.Equal(3000m, onizleme.AraToplam);
    }

    [Fact]
    public void KdvToplam_KalemKdvleriniToplamal()
    {
        var onizleme = new TopluFaturaOnizleme
        {
            Kalemler = new()
            {
                new() { Miktar = 1, BirimFiyat = 1000m, KdvOrani = 20 },
                new() { Miktar = 1, BirimFiyat = 2000m, KdvOrani = 20 }
            }
        };

        // 1000*20/100 + 2000*20/100 = 200+400=600
        Assert.Equal(600m, onizleme.KdvToplam);
    }

    [Fact]
    public void TevkifatToplam_TevkifatsizSifirOlmali()
    {
        var onizleme = new TopluFaturaOnizleme
        {
            TevkifatliMi = false,
            TevkifatOrani = 50,
            Kalemler = new() { new() { Miktar = 1, BirimFiyat = 1000m, KdvOrani = 20 } }
        };

        Assert.Equal(0m, onizleme.TevkifatToplam);
    }

    [Fact]
    public void TevkifatToplam_TevkifatliDogruHesaplanmali()
    {
        var onizleme = new TopluFaturaOnizleme
        {
            TevkifatliMi = true,
            TevkifatOrani = 50,
            Kalemler = new() { new() { Miktar = 1, BirimFiyat = 1000m, KdvOrani = 20 } }
        };

        // KdvToplam=200, Tevkifat=200*50/100=100
        Assert.Equal(100m, onizleme.TevkifatToplam);
    }

    [Fact]
    public void GenelToplam_AraPlusKdvEksiTevkifat()
    {
        var onizleme = new TopluFaturaOnizleme
        {
            TevkifatliMi = true,
            TevkifatOrani = 50,
            Kalemler = new()
            {
                new() { Miktar = 1, BirimFiyat = 1000m, KdvOrani = 20 }
            }
        };

        // Ara=1000, Kdv=200, Tevkifat=100 => Genel=1000+200-100=1100
        Assert.Equal(1100m, onizleme.GenelToplam);
    }

    [Fact]
    public void GenelToplam_TevkifatsizAraPlusKdv()
    {
        var onizleme = new TopluFaturaOnizleme
        {
            TevkifatliMi = false,
            Kalemler = new()
            {
                new() { Miktar = 1, BirimFiyat = 1000m, KdvOrani = 20 }
            }
        };

        Assert.Equal(1200m, onizleme.GenelToplam);
    }

    [Fact]
    public void KayitSayisi_PuantajIdSayisi()
    {
        var onizleme = new TopluFaturaOnizleme
        {
            PuantajKayitIdleri = new() { 1, 2, 3, 4, 5 }
        };

        Assert.Equal(5, onizleme.KayitSayisi);
    }

    [Fact]
    public void BosKalemlerSifirDonmeli()
    {
        var onizleme = new TopluFaturaOnizleme();

        Assert.Equal(0m, onizleme.AraToplam);
        Assert.Equal(0m, onizleme.KdvToplam);
        Assert.Equal(0m, onizleme.GenelToplam);
        Assert.Equal(0, onizleme.KayitSayisi);
    }
}

public class TopluFaturaKalemOnizlemeTests
{
    [Fact]
    public void Tutar_MiktarCarpiBirimFiyat()
    {
        var kalem = new TopluFaturaKalemOnizleme { Miktar = 5, BirimFiyat = 200m };

        Assert.Equal(1000m, kalem.Tutar);
    }

    [Fact]
    public void KdvTutar_TutarCarpiKdvOraniYuzde()
    {
        var kalem = new TopluFaturaKalemOnizleme
        {
            Miktar = 1, BirimFiyat = 1000m, KdvOrani = 20
        };

        Assert.Equal(200m, kalem.KdvTutar);
    }

    [Fact]
    public void ToplamTutar_TutarPlusKdv()
    {
        var kalem = new TopluFaturaKalemOnizleme
        {
            Miktar = 2, BirimFiyat = 500m, KdvOrani = 20
        };

        // Tutar=1000, Kdv=200, Toplam=1200
        Assert.Equal(1200m, kalem.ToplamTutar);
    }

    [Fact]
    public void KdvSifirOluncaToplamTutarEsitTutar()
    {
        var kalem = new TopluFaturaKalemOnizleme
        {
            Miktar = 3, BirimFiyat = 100m, KdvOrani = 0
        };

        Assert.Equal(300m, kalem.Tutar);
        Assert.Equal(0m, kalem.KdvTutar);
        Assert.Equal(300m, kalem.ToplamTutar);
    }
}

public class TopluFaturaOzetTests
{
    [Fact]
    public void DonemAdi_DogruFormatlMali()
    {
        var ozet = new TopluFaturaOzet { Yil = 2025, Ay = 3 };

        Assert.Equal("03/2025", ozet.DonemAdi);
    }

    [Fact]
    public void DonemAdi_CiftHaneliAy()
    {
        var ozet = new TopluFaturaOzet { Yil = 2025, Ay = 12 };

        Assert.Equal("12/2025", ozet.DonemAdi);
    }
}
