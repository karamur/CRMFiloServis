# KOA Filo Servis - Lisans Yönetimi

## 📋 Lisans Sistemi

KOA Filo Servis, RSA-2048 tabanlı dijital imza kullanan güvenli bir lisans sistemi içerir.

---

## 📦 Dosyalar

| Dosya | Açıklama |
|-------|----------|
| `LicenseGenerator.cs` | Lisans oluşturma kodu |
| `LicenseValidator.cs` | Lisans doğrulama kodu |
| `LicenseService.cs` | Uygulama entegrasyonu |
| `license-trial.key` | Örnek deneme lisansı |
| `LisansOlustur.bat` | Lisans oluşturma aracı |

---

## 🔑 Lisans Türleri

| Tür | Süre | Araç | Kullanıcı | Özellikler |
|-----|------|------|-----------|------------|
| **Trial** | 30 gün | 10 | 3 | Temel |
| **Standard** | 1 yıl | 50 | 10 | + Raporlar |
| **Professional** | 1 yıl | 200 | 50 | + API |
| **Enterprise** | Süresiz | ∞ | ∞ | Tümü |

---

## 🛠️ Kullanım

### Lisans Oluşturma (PowerShell)

```powershell
.\LisansOlustur.ps1 -Sirket "ABC Ltd" -Tur "Professional" -Gun 365
```

### Lisans Doğrulama (C#)

```csharp
var validator = new LicenseValidator();
var result = validator.Validate("license.key");

if (result.IsValid)
    Console.WriteLine($"Lisans geçerli: {result.License.CompanyName}");
```

---

## 📄 Lisans Dosya Formatı

```
-----BEGIN KOA FILO SERVIS LICENSE-----
Version: 1.0
Company: ABC Şirketi
Type: Professional
MaxVehicles: 200
Expires: 2025-12-31
Signature: BASE64_RSA_SIGNATURE
-----END KOA FILO SERVIS LICENSE-----
```

---

## 📞 Lisans Talebi

- **E-posta:** license@koafiloservis.com
- **Tel:** +90 212 123 45 67
