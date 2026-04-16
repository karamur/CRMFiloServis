using KOAFiloServis.Shared.Entities;

namespace KOAFiloServis.Tests.Entities;

public class PersonelAvansTests
{
    [Fact]
    public void Kalan_ReturnsCorrectDifference()
    {
        var avans = new PersonelAvans { Tutar = 5000, MahsupEdilen = 2000 };
        Assert.Equal(3000, avans.Kalan);
    }

    [Fact]
    public void TamamenMahsupEdildi_WhenFull_ReturnsTrue()
    {
        var avans = new PersonelAvans { Tutar = 5000, MahsupEdilen = 5000 };
        Assert.True(avans.TamamenMahsupEdildi);
    }

    [Fact]
    public void TamamenMahsupEdildi_WhenPartial_ReturnsFalse()
    {
        var avans = new PersonelAvans { Tutar = 5000, MahsupEdilen = 3000 };
        Assert.False(avans.TamamenMahsupEdildi);
    }

    [Fact]
    public void TamamenMahsupEdildi_WhenOverpaid_ReturnsTrue()
    {
        var avans = new PersonelAvans { Tutar = 5000, MahsupEdilen = 6000 };
        Assert.True(avans.TamamenMahsupEdildi);
    }

    [Fact]
    public void Default_Values_AreCorrect()
    {
        var avans = new PersonelAvans();
        Assert.Equal(0, avans.MahsupEdilen);
        Assert.Equal(AvansOdemeSekli.Nakit, avans.OdemeSekli);
        Assert.Equal(AvansDurum.Verildi, avans.Durum);
    }
}

public class PersonelBorcTests
{
    [Fact]
    public void KalanBorc_ReturnsCorrectDifference()
    {
        var borc = new PersonelBorc { Tutar = 10000, OdenenTutar = 4000 };
        Assert.Equal(6000, borc.KalanBorc);
    }

    [Fact]
    public void TamamenOdendi_WhenFull_ReturnsTrue()
    {
        var borc = new PersonelBorc { Tutar = 10000, OdenenTutar = 10000 };
        Assert.True(borc.TamamenOdendi);
    }

    [Fact]
    public void TamamenOdendi_WhenPartial_ReturnsFalse()
    {
        var borc = new PersonelBorc { Tutar = 10000, OdenenTutar = 3000 };
        Assert.False(borc.TamamenOdendi);
    }

    [Fact]
    public void Default_Values_AreCorrect()
    {
        var borc = new PersonelBorc();
        Assert.Equal(0, borc.OdenenTutar);
        Assert.Equal(BorcOdemeDurum.Bekliyor, borc.OdemeDurum);
        Assert.Equal(BorcTipi.MaasAlacagi, borc.BorcTipi);
    }
}
