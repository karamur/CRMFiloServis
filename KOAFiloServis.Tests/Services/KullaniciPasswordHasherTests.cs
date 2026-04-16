using KOAFiloServis.Shared.Entities;
using KOAFiloServis.Web.Services;
using Microsoft.AspNetCore.Identity;

namespace KOAFiloServis.Tests.Services;

public class KullaniciPasswordHasherTests
{
    private readonly KullaniciPasswordHasher _hasher = new();
    private readonly Kullanici _kullanici = new() { Id = 1, KullaniciAdi = "test" };

    [Fact]
    public void HashPassword_BosOlmayanHashUretir()
    {
        var hash = _hasher.HashPassword(_kullanici, "Sifre123!");
        Assert.False(string.IsNullOrWhiteSpace(hash));
    }

    [Fact]
    public void HashPassword_AyniSifreIcinFarkliHashUretir()
    {
        var hash1 = _hasher.HashPassword(_kullanici, "Sifre123!");
        var hash2 = _hasher.HashPassword(_kullanici, "Sifre123!");
        Assert.NotEqual(hash1, hash2); // Salt farklı olmalı
    }

    [Fact]
    public void VerifyHashedPassword_DogruSifre_Basarili()
    {
        var hash = _hasher.HashPassword(_kullanici, "Sifre123!");
        var result = _hasher.VerifyHashedPassword(_kullanici, hash, "Sifre123!");
        Assert.Equal(PasswordVerificationResult.Success, result);
    }

    [Fact]
    public void VerifyHashedPassword_YanlisSifre_Basarisiz()
    {
        var hash = _hasher.HashPassword(_kullanici, "Sifre123!");
        var result = _hasher.VerifyHashedPassword(_kullanici, hash, "YanlisSifre");
        Assert.Equal(PasswordVerificationResult.Failed, result);
    }

    [Fact]
    public void VerifyHashedPassword_BosHash_Basarisiz()
    {
        var result = _hasher.VerifyHashedPassword(_kullanici, "", "Sifre123!");
        Assert.Equal(PasswordVerificationResult.Failed, result);
    }

    [Fact]
    public void VerifyHashedPassword_NullHash_Basarisiz()
    {
        var result = _hasher.VerifyHashedPassword(_kullanici, null!, "Sifre123!");
        Assert.Equal(PasswordVerificationResult.Failed, result);
    }

    [Fact]
    public void VerifyHashedPassword_LegacyHash_RehashNeeded()
    {
        // Legacy SHA256 hash oluştur
        using var sha = System.Security.Cryptography.SHA256.Create();
        var bytes = sha.ComputeHash(System.Text.Encoding.UTF8.GetBytes("Sifre123!" + "KOAFiloServisSalt"));
        var legacyHash = Convert.ToBase64String(bytes);

        var result = _hasher.VerifyHashedPassword(_kullanici, legacyHash, "Sifre123!");
        Assert.Equal(PasswordVerificationResult.SuccessRehashNeeded, result);
    }

    [Fact]
    public void VerifyHashedPassword_LegacyHash_YanlisSifre_Basarisiz()
    {
        using var sha = System.Security.Cryptography.SHA256.Create();
        var bytes = sha.ComputeHash(System.Text.Encoding.UTF8.GetBytes("Sifre123!" + "KOAFiloServisSalt"));
        var legacyHash = Convert.ToBase64String(bytes);

        var result = _hasher.VerifyHashedPassword(_kullanici, legacyHash, "YanlisSifre");
        Assert.Equal(PasswordVerificationResult.Failed, result);
    }
}
