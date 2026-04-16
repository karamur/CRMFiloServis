using KOAFiloServis.Web.Helpers;

namespace KOAFiloServis.Tests.Helpers;

public class ParaFormatTests
{
    [Theory]
    [InlineData(1234.56, true, "1.234,56 TL")]
    [InlineData(1234.56, false, "1.234,56")]
    [InlineData(0, true, "0,00 TL")]
    [InlineData(-500.99, true, "-500,99 TL")]
    [InlineData(1000000, true, "1.000.000,00 TL")]
    public void Format_DogruSonucDoner(decimal tutar, bool birimGoster, string beklenen)
    {
        var sonuc = ParaFormat.Format(tutar, birimGoster);
        Assert.Equal(beklenen, sonuc);
    }

    [Theory]
    [InlineData(1234.56, true, "1.235 TL")]
    [InlineData(1234.56, false, "1.235")]
    [InlineData(0, true, "0 TL")]
    public void FormatKisa_YuvarlamaDogruYapilir(decimal tutar, bool birimGoster, string beklenen)
    {
        var sonuc = ParaFormat.FormatKisa(tutar, birimGoster);
        Assert.Equal(beklenen, sonuc);
    }

    [Fact]
    public void FormatTL_TLKoduIleDoner()
    {
        var sonuc = ParaFormat.FormatTL(2500.75m);
        Assert.Equal("2.500,75 TL", sonuc);
    }

    [Fact]
    public void FormatTLKisa_TLKoduIleDoner()
    {
        var sonuc = ParaFormat.FormatTLKisa(2500.75m);
        Assert.Equal("2.501 TL", sonuc);
    }

    [Fact]
    public void Format_NullDeger_VarsayilanDondurur()
    {
        decimal? tutar = null;
        var sonuc = ParaFormat.Format(tutar);
        Assert.Equal("-", sonuc);
    }

    [Fact]
    public void Format_NullDeger_OzelBostaDeger()
    {
        decimal? tutar = null;
        var sonuc = ParaFormat.Format(tutar, bostaDeger: "N/A");
        Assert.Equal("N/A", sonuc);
    }

    [Fact]
    public void Format_NullOlmayanDeger_NormalFormatlar()
    {
        decimal? tutar = 1500m;
        var sonuc = ParaFormat.Format(tutar, birimGoster: true);
        Assert.Equal("1.500,00 TL", sonuc);
    }
}
