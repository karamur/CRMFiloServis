<div align="center">

# KOAFiloServis

**Kurumsal Filo Yönetimi ve Operasyon Platformu**

[![.NET](https://img.shields.io/badge/.NET-10.0-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/)
[![Blazor](https://img.shields.io/badge/Blazor-Server-512BD4?style=for-the-badge&logo=blazor&logoColor=white)](https://blazor.net/)

</div>

---

## Genel Bakış
KOAFiloServis, .NET 10 tabanlı Blazor Server çözümüdür. Filo operasyonları, servis süreçleri, cari/muhasebe akışları ve raporlamayı tek platformda toplar.

## Çözüm Yapısı
- `KOAFiloServis.Web` (Blazor Server, `net10.0`)
- `KOAFiloServis.Shared` (Ortak model/katman, `net10.0`)
- `KOAFiloServis.Tests` (xUnit testleri, `net10.0`)
- `KOAFiloServis.LisansDesktop` (WinForms, `net10.0-windows`)
- `KOAFiloServis.Installer` (WinForms, `net10.0-windows`)

## Teknolojiler
- .NET 10
- Blazor Server
- Entity Framework Core (PostgreSQL/SQLite)
- JWT, Quartz, Redis (opsiyonel)
- ClosedXML / QuestPDF

## Kurulum
```bash
git clone https://github.com/karamur/KOAFiloServis.git
cd KOAFiloServis
dotnet restore
dotnet run --project KOAFiloServis.Web
```

## Test
```bash
dotnet test
```

## Yayınlama
```bash
dotnet publish KOAFiloServis.Web -c Release -o ./publish/web
dotnet publish KOAFiloServis.LisansDesktop -c Release
dotnet publish KOAFiloServis.Installer -c Release
```

## Güvenlik Notu
Üretimde secret bilgilerini `appsettings*.json` içinde tutmayın; ortam değişkeni veya güvenli bir secret store kullanın.

---

Katkı için issue/pull request açabilirsiniz.
