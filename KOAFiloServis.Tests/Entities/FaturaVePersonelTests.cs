using KOAFiloServis.Shared.Entities;

namespace KOAFiloServis.Tests.Entities;

public class FaturaTests
{
    [Fact]
    public void KalanTutar_GenelEksiOdenen()
    {
        var fatura = new Fatura { GenelToplam = 5000m, OdenenTutar = 3000m };

        Assert.Equal(2000m, fatura.KalanTutar);
    }

    [Fact]
    public void KalanTutar_TamOdenmisOluncaSifir()
    {
        var fatura = new Fatura { GenelToplam = 5000m, OdenenTutar = 5000m };

        Assert.Equal(0m, fatura.KalanTutar);
    }

    [Fact]
    public void TevkifatliKdvTutar_KdvEksiTevkifat()
    {
        var fatura = new Fatura { KdvTutar = 200m, TevkifatTutar = 100m };

        Assert.Equal(100m, fatura.TevkifatliKdvTutar);
    }
}

public class FaturaKalemTests
{
    [Fact]
    public void NetTutar_MiktarCarpiFiyatEksiIskonto()
    {
        var kalem = new FaturaKalem { Miktar = 5, BirimFiyat = 200m, IskontoTutar = 100m };

        Assert.Equal(900m, kalem.NetTutar);
    }

    [Fact]
    public void NetTutar_IskontoSifirOluncaMiktarCarpiFiyat()
    {
        var kalem = new FaturaKalem { Miktar = 3, BirimFiyat = 100m, IskontoTutar = 0m };

        Assert.Equal(300m, kalem.NetTutar);
    }

    [Fact]
    public void TevkifatliKdvTutar_KdvEksiTevkifat()
    {
        var kalem = new FaturaKalem { KdvTutar = 200m, TevkifatTutar = 80m };

        Assert.Equal(120m, kalem.TevkifatliKdvTutar);
    }
}

public class PersonelMaasTests
{
    [Fact]
    public void ToplamEklemeler_TumEklemeleriToplamal()
    {
        var maas = new PersonelMaas
        {
            Prim = 500m,
            Ikramiye = 1000m,
            Yemek = 300m,
            Yol = 200m,
            Mesai = 400m,
            DigerEklemeler = 100m
        };

        Assert.Equal(2500m, maas.ToplamEklemeler);
    }

    [Fact]
    public void ToplamKesintiler_TumKesintileriToplamal()
    {
        var maas = new PersonelMaas
        {
            SGKIsciPayi = 700m,
            GelirVergisi = 500m,
            DamgaVergisi = 50m,
            IssizlikPrimi = 100m,
            Avans = 200m,
            IcraTakibi = 0m,
            DigerKesintiler = 50m
        };

        Assert.Equal(1600m, maas.ToplamKesintiler);
    }

    [Fact]
    public void OdenecekTutar_NetMaasPlusEklemelerEksiKesintiler()
    {
        var maas = new PersonelMaas
        {
            NetMaas = 8000m,
            Prim = 500m,
            Ikramiye = 0m,
            Yemek = 300m,
            Yol = 200m,
            Mesai = 0m,
            DigerEklemeler = 0m,
            Avans = 1000m,
            IcraTakibi = 0m,
            DigerKesintiler = 200m
        };

        // OdenecekTutar = NetMaas + ToplamEklemeler - Avans - IcraTakibi - DigerKesintiler
        // = 8000 + 1000 - 1000 - 0 - 200 = 7800
        Assert.Equal(7800m, maas.OdenecekTutar);
    }
}

public class PersonelIzinTests
{
    [Fact]
    public void ToplamGun_BaslangicVeBitisDahil()
    {
        var izin = new PersonelIzin
        {
            BaslangicTarihi = new DateTime(2025, 1, 1),
            BitisTarihi = new DateTime(2025, 1, 5)
        };

        Assert.Equal(5, izin.ToplamGun);
    }

    [Fact]
    public void ToplamGun_TekGunIzin()
    {
        var izin = new PersonelIzin
        {
            BaslangicTarihi = new DateTime(2025, 6, 15),
            BitisTarihi = new DateTime(2025, 6, 15)
        };

        Assert.Equal(1, izin.ToplamGun);
    }
}
