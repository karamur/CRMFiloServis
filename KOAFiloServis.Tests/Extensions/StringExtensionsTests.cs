using KOAFiloServis.Web;

namespace KOAFiloServis.Tests.Extensions;

public class StringExtensionsTests
{
    [Theory]
    [InlineData("Merhaba Dünya", 5, "Merha...")]
    [InlineData("Kısa", 10, "Kısa")]
    [InlineData("Tam5!", 5, "Tam5!")]
    public void Truncate_DogruKesme(string girdi, int maxUzunluk, string beklenen)
    {
        var sonuc = girdi.Truncate(maxUzunluk);
        Assert.Equal(beklenen, sonuc);
    }

    [Fact]
    public void Truncate_NullString_NullDoner()
    {
        string? girdi = null;
        var sonuc = girdi!.Truncate(5);
        Assert.Null(sonuc);
    }

    [Fact]
    public void Truncate_BosString_BosDoner()
    {
        var sonuc = "".Truncate(5);
        Assert.Equal("", sonuc);
    }
}
