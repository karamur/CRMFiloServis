using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace KOAFiloServis.Licensing;

public class LicenseGenerator
{
    private readonly RSA _rsa;

    public LicenseGenerator(string? privateKeyPath = null)
    {
        _rsa = RSA.Create(2048);
        
        if (!string.IsNullOrEmpty(privateKeyPath) && File.Exists(privateKeyPath))
        {
            _rsa.ImportRSAPrivateKey(Convert.FromBase64String(File.ReadAllText(privateKeyPath)), out _);
        }
        else
        {
            // Yeni anahtar oluştur ve kaydet
            Directory.CreateDirectory("keys");
            File.WriteAllText("keys/private.key", Convert.ToBase64String(_rsa.ExportRSAPrivateKey()));
            File.WriteAllText("keys/public.key", Convert.ToBase64String(_rsa.ExportRSAPublicKey()));
        }
    }

    public string Generate(LicenseRequest request)
    {
        var license = new LicenseData
        {
            LicenseId = Guid.NewGuid().ToString("N")[..12].ToUpper(),
            CompanyName = request.CompanyName,
            ContactEmail = request.ContactEmail,
            Type = request.Type,
            MaxVehicles = GetMaxVehicles(request.Type),
            MaxUsers = GetMaxUsers(request.Type),
            Features = GetFeatures(request.Type),
            IssuedDate = DateTime.UtcNow,
            ExpirationDate = request.ExpirationDate,
            MachineId = request.MachineId ?? "*"
        };

        var jsonData = JsonSerializer.Serialize(license);
        var dataBytes = Encoding.UTF8.GetBytes(jsonData);
        var signature = _rsa.SignData(dataBytes, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);

        var sb = new StringBuilder();
        sb.AppendLine("-----BEGIN KOA FILO SERVIS LICENSE-----");
        sb.AppendLine($"Version: 1.0");
        sb.AppendLine($"LicenseId: {license.LicenseId}");
        sb.AppendLine($"Company: {license.CompanyName}");
        sb.AppendLine($"Type: {license.Type}");
        sb.AppendLine($"MaxVehicles: {license.MaxVehicles}");
        sb.AppendLine($"MaxUsers: {license.MaxUsers}");
        sb.AppendLine($"Expires: {license.ExpirationDate:yyyy-MM-dd}");
        sb.AppendLine($"Data: {Convert.ToBase64String(dataBytes)}");
        sb.AppendLine($"Signature: {Convert.ToBase64String(signature)}");
        sb.AppendLine("-----END KOA FILO SERVIS LICENSE-----");

        return sb.ToString();
    }

    private int GetMaxVehicles(LicenseType type) => type switch
    {
        LicenseType.Trial => 10,
        LicenseType.Standard => 50,
        LicenseType.Professional => 200,
        LicenseType.Enterprise => 999999,
        _ => 10
    };

    private int GetMaxUsers(LicenseType type) => type switch
    {
        LicenseType.Trial => 3,
        LicenseType.Standard => 10,
        LicenseType.Professional => 50,
        LicenseType.Enterprise => 999999,
        _ => 3
    };

    private List<string> GetFeatures(LicenseType type) => type switch
    {
        LicenseType.Trial => new() { "core" },
        LicenseType.Standard => new() { "core", "reports" },
        LicenseType.Professional => new() { "core", "reports", "api", "export" },
        LicenseType.Enterprise => new() { "core", "reports", "api", "export", "whitelabel" },
        _ => new() { "core" }
    };
}

public class LicenseRequest
{
    public string CompanyName { get; set; } = "";
    public string? ContactEmail { get; set; }
    public LicenseType Type { get; set; } = LicenseType.Trial;
    public DateTime ExpirationDate { get; set; } = DateTime.UtcNow.AddDays(30);
    public string? MachineId { get; set; }
}

public class LicenseData
{
    public string LicenseId { get; set; } = "";
    public string CompanyName { get; set; } = "";
    public string? ContactEmail { get; set; }
    public LicenseType Type { get; set; }
    public int MaxVehicles { get; set; }
    public int MaxUsers { get; set; }
    public List<string> Features { get; set; } = new();
    public DateTime IssuedDate { get; set; }
    public DateTime ExpirationDate { get; set; }
    public string MachineId { get; set; } = "*";
}

public enum LicenseType { Trial, Standard, Professional, Enterprise }
