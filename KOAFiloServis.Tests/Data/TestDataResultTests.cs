using KOAFiloServis.Web.Data;

namespace KOAFiloServis.Tests.Data;

public class TestDataResultTests
{
    [Fact]
    public void ToplamKayit_IncludesIhaleHazirlik()
    {
        var result = new TestDataResult
        {
            CariSayisi = 15,
            SoforSayisi = 10,
            AracSayisi = 12,
            GuzergahSayisi = 8,
            FaturaSayisi = 45,
            ServisCalismasiSayisi = 200,
            IhaleHazirlikSayisi = 8,
            ProformaFaturaSayisi = 6,
            PuantajKayitSayisi = 3
        };

        Assert.Equal(307, result.ToplamKayit);
    }

    [Fact]
    public void ToplamKayit_AllZero_ReturnsZero()
    {
        var result = new TestDataResult();
        Assert.Equal(0, result.ToplamKayit);
    }

    [Fact]
    public void Default_Values_AreCorrect()
    {
        var result = new TestDataResult();
        Assert.False(result.Basarili);
        Assert.Empty(result.Mesajlar);
        Assert.Equal(0, result.IhaleHazirlikSayisi);
    }
}
