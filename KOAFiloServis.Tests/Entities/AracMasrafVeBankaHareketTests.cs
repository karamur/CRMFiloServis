using KOAFiloServis.Shared.Entities;

namespace KOAFiloServis.Tests.Entities;

public class AracMasrafTests
{
    [Theory]
    [InlineData(MasrafOdemeKaynak.PersonelCebinden, true)]
    [InlineData(MasrafOdemeKaynak.Kasa, false)]
    [InlineData(MasrafOdemeKaynak.Banka, false)]
    public void IsPersonelCebinden_ReturnsCorrectValue(MasrafOdemeKaynak kaynak, bool expected)
    {
        var masraf = new AracMasraf { OdemeKaynak = kaynak };
        Assert.Equal(expected, masraf.IsPersonelCebinden);
    }

    [Fact]
    public void Default_Values_AreCorrect()
    {
        var masraf = new AracMasraf();
        Assert.Equal(MasrafOdemeKaynak.Kasa, masraf.OdemeKaynak);
        Assert.False(masraf.ArizaKaynaklimi);
        Assert.False(masraf.PersoneleOdendi);
    }
}

public class BankaKasaHareketTests
{
    [Fact]
    public void IsPersonelCebinden_WithId_ReturnsTrue()
    {
        var hareket = new BankaKasaHareket { PersonelCebindenId = 5 };
        Assert.True(hareket.IsPersonelCebinden);
    }

    [Fact]
    public void IsPersonelCebinden_WithoutId_ReturnsFalse()
    {
        var hareket = new BankaKasaHareket { PersonelCebindenId = null };
        Assert.False(hareket.IsPersonelCebinden);
    }

    [Fact]
    public void Default_Values_AreCorrect()
    {
        var hareket = new BankaKasaHareket();
        Assert.Equal(IslemKaynak.Manuel, hareket.IslemKaynak);
        Assert.False(hareket.PersoneleOdendi);
        Assert.Null(hareket.PersonelCebindenId);
    }
}
