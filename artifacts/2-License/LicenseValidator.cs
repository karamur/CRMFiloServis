using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace KOAFiloServis.Licensing;

public class LicenseValidator
{
    private readonly RSA? _rsa;

    public LicenseValidator(string? publicKeyPath = null)
    {
        if (!string.IsNullOrEmpty(publicKeyPath) && File.Exists(publicKeyPath))
        {
            _rsa = RSA.Create();
            _rsa.ImportRSAPublicKey(Convert.FromBase64String(File.ReadAllText(publicKeyPath)), out _);
        }
    }

    public LicenseResult Validate(string licenseFilePath)
    {
        try
        {
            if (!File.Exists(licenseFilePath))
                return new LicenseResult { IsValid = false, Error = "Lisans dosyası bulunamadı" };

            var content = File.ReadAllText(licenseFilePath);
            return ValidateContent(content);
        }
        catch (Exception ex)
        {
            return new LicenseResult { IsValid = false, Error = ex.Message };
        }
    }

    public LicenseResult ValidateContent(string content)
    {
        try
        {
            var fields = ParseFields(content);

            if (!fields.TryGetValue("Data", out var dataBase64) ||
                !fields.TryGetValue("Signature", out var signatureBase64))
                return new LicenseResult { IsValid = false, Error = "Geçersiz lisans formatı" };

            var dataBytes = Convert.FromBase64String(dataBase64);

            // İmza doğrulama
            if (_rsa != null)
            {
                var signatureBytes = Convert.FromBase64String(signatureBase64);
                if (!_rsa.VerifyData(dataBytes, signatureBytes, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1))
                    return new LicenseResult { IsValid = false, Error = "Geçersiz lisans imzası" };
            }

            var license = JsonSerializer.Deserialize<LicenseData>(Encoding.UTF8.GetString(dataBytes));
            if (license == null)
                return new LicenseResult { IsValid = false, Error = "Lisans verisi okunamadı" };

            // Süre kontrolü
            if (license.ExpirationDate < DateTime.UtcNow)
                return new LicenseResult { IsValid = false, Error = "Lisans süresi dolmuş", License = license };

            return new LicenseResult
            {
                IsValid = true,
                License = license,
                DaysRemaining = (int)(license.ExpirationDate - DateTime.UtcNow).TotalDays
            };
        }
        catch (Exception ex)
        {
            return new LicenseResult { IsValid = false, Error = ex.Message };
        }
    }

    private Dictionary<string, string> ParseFields(string content)
    {
        var fields = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        foreach (var line in content.Split('\n'))
        {
            var trimmed = line.Trim();
            if (trimmed.StartsWith("-----")) continue;
            var idx = trimmed.IndexOf(':');
            if (idx > 0)
                fields[trimmed[..idx].Trim()] = trimmed[(idx + 1)..].Trim();
        }
        return fields;
    }
}

public class LicenseResult
{
    public bool IsValid { get; set; }
    public string? Error { get; set; }
    public LicenseData? License { get; set; }
    public int DaysRemaining { get; set; }
}
