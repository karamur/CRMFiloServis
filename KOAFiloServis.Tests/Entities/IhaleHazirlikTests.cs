using KOAFiloServis.Shared.Entities;

namespace KOAFiloServis.Tests.Entities;

public class IhaleProjeTests
{
    [Fact]
    public void ToplamAylikMaliyet_WithKalemler_ReturnsSumOfAylikMaliyet()
    {
        var proje = new IhaleProje();
        proje.Kalemler.Add(new IhaleGuzergahKalem { AylikMaliyet = 50000 });
        proje.Kalemler.Add(new IhaleGuzergahKalem { AylikMaliyet = 30000 });
        proje.Kalemler.Add(new IhaleGuzergahKalem { AylikMaliyet = 20000 });

        Assert.Equal(100000, proje.ToplamAylikMaliyet);
    }

    [Fact]
    public void ToplamProjemaliyeti_WithKalemler_ReturnsSumOfToplamMaliyet()
    {
        var proje = new IhaleProje();
        proje.Kalemler.Add(new IhaleGuzergahKalem { ToplamMaliyet = 600000 });
        proje.Kalemler.Add(new IhaleGuzergahKalem { ToplamMaliyet = 400000 });

        Assert.Equal(1000000, proje.ToplamProjemaliyeti);
    }

    [Fact]
    public void ToplamAylikMaliyet_EmptyKalemler_ReturnsZero()
    {
        var proje = new IhaleProje();
        Assert.Equal(0, proje.ToplamAylikMaliyet);
    }

    [Fact]
    public void ToplamProjemaliyeti_NullKalemler_ReturnsZero()
    {
        var proje = new IhaleProje();
        proje.Kalemler = null!;
        Assert.Equal(0, proje.ToplamProjemaliyeti);
    }

    [Fact]
    public void Default_Values_AreCorrect()
    {
        var proje = new IhaleProje();
        Assert.Equal(IhaleProjeDurum.Taslak, proje.Durum);
        Assert.Equal(25, proje.EnflasyonOrani);
        Assert.Equal(30, proje.YakitZamOrani);
        Assert.Equal(22, proje.AylikCalismGunu);
        Assert.Equal(8, proje.GunlukCalismaSaati);
    }
}

public class IhaleGuzergahKalemTests
{
    [Fact]
    public void Default_Values_AreCorrect()
    {
        var kalem = new IhaleGuzergahKalem();
        Assert.Equal(SeferTipi.SabahAksam, kalem.SeferTipi);
        Assert.Equal(2, kalem.GunlukSeferSayisi);
        Assert.Equal(22, kalem.AylikSeferGunu);
        Assert.Equal(AracSahiplikKalem.Ozmal, kalem.SahiplikDurumu);
        Assert.Equal(27, kalem.AracKoltukSayisi);
        Assert.Equal(18, kalem.YakitTuketimi);
        Assert.Equal(42, kalem.YakitFiyati);
        Assert.Equal(5, kalem.AmortismanYili);
        Assert.Equal(15, kalem.KarMarjiOrani);
    }
}
