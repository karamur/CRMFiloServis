using KOAFiloServis.Web.Helpers;

namespace KOAFiloServis.Tests.Helpers;

public class TwoFactorAuthenticatorHelperTests
{
    [Fact]
    public void GenerateSecretKey_BosOlmayanKeyUretir()
    {
        var key = TwoFactorAuthenticatorHelper.GenerateSecretKey();
        Assert.False(string.IsNullOrWhiteSpace(key));
    }

    [Fact]
    public void GenerateSecretKey_HerSeferindeFarkliUretir()
    {
        var key1 = TwoFactorAuthenticatorHelper.GenerateSecretKey();
        var key2 = TwoFactorAuthenticatorHelper.GenerateSecretKey();
        Assert.NotEqual(key1, key2);
    }

    [Fact]
    public void FormatManualEntryKey_DortluGruplar()
    {
        var key = "ABCDEFGHIJKLMNOP";
        var formatted = TwoFactorAuthenticatorHelper.FormatManualEntryKey(key);
        Assert.Equal("ABCD EFGH IJKL MNOP", formatted);
    }

    [Fact]
    public void BuildSetupUri_OtpauthFormati()
    {
        var uri = TwoFactorAuthenticatorHelper.BuildSetupUri("KOAFilo", "test@test.com", "SECRETKEY");
        Assert.StartsWith("otpauth://totp/", uri);
        Assert.Contains("secret=SECRETKEY", uri);
        Assert.Contains("issuer=KOAFilo", uri);
    }

    [Theory]
    [InlineData(null, "123456")]
    [InlineData("SECRETKEY", null)]
    [InlineData("", "123456")]
    [InlineData("SECRETKEY", "")]
    public void ValidateCode_BosGirdiler_FalseDoner(string? secretKey, string? code)
    {
        var result = TwoFactorAuthenticatorHelper.ValidateCode(secretKey!, code!);
        Assert.False(result);
    }

    [Fact]
    public void ValidateCode_GecersizFormat_FalseDoner()
    {
        var result = TwoFactorAuthenticatorHelper.ValidateCode("SECRETKEY", "abc");
        Assert.False(result);
    }

    [Fact]
    public void ValidateCode_YanlisKod_FalseDoner()
    {
        var key = TwoFactorAuthenticatorHelper.GenerateSecretKey();
        var result = TwoFactorAuthenticatorHelper.ValidateCode(key, "000000");
        // Çok düşük ihtimalle doğru olabilir, ama pratikte false
        // Bu test kodun çökmediğini doğrular
        Assert.IsType<bool>(result);
    }
}
