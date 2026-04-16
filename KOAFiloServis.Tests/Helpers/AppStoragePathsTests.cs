using KOAFiloServis.Web.Helpers;

namespace KOAFiloServis.Tests.Helpers;

public class AppStoragePathsTests
{
    [Fact]
    public void GetUploadsRoot_UploadsKlasoruIcerir()
    {
        var result = AppStoragePaths.GetUploadsRoot("C:\\test");
        Assert.EndsWith("uploads", result);
    }

    [Fact]
    public void GetDatabaseBackupRoot_DatabaseKlasoruIcerir()
    {
        var result = AppStoragePaths.GetDatabaseBackupRoot("C:\\test");
        Assert.EndsWith("database", result);
    }

    [Fact]
    public void GetDataProtectionKeysRoot_KeysKlasoruIcerir()
    {
        var result = AppStoragePaths.GetDataProtectionKeysRoot("C:\\test");
        Assert.EndsWith("keys", result);
    }

    [Fact]
    public void GetStorageRoot_OrtamDegiskeniYoksa_VarsayilanDoner()
    {
        Environment.SetEnvironmentVariable("CRMFILO_STORAGE_ROOT", null);
        var result = AppStoragePaths.GetStorageRoot("C:\\test");
        Assert.Equal(AppStoragePaths.DefaultStorageRoot, result);
    }

    [Fact]
    public void GetStorageRoot_OrtamDegiskeniVarsa_OnuKullanir()
    {
        var ozelYol = @"D:\ozel\depo";
        Environment.SetEnvironmentVariable("CRMFILO_STORAGE_ROOT", ozelYol);
        try
        {
            var result = AppStoragePaths.GetStorageRoot("C:\\test");
            Assert.Equal(Path.GetFullPath(ozelYol), result);
        }
        finally
        {
            Environment.SetEnvironmentVariable("CRMFILO_STORAGE_ROOT", null);
        }
    }
}
