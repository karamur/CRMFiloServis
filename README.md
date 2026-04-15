<div align="center">

# KOA Filo Servis

**Kurumsal Filo Yonetimi ve ERP Cozumu**

[![.NET](https://img.shields.io/badge/.NET-10.0-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/)
[![Blazor](https://img.shields.io/badge/Blazor-Server-512BD4?style=for-the-badge&logo=blazor&logoColor=white)](https://blazor.net/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-Proprietary-red?style=for-the-badge)](LICENSE)

*Turkiye deki filo yonetimi ve tasimacilik sirketleri icin kapsamli kurumsal kaynak planlama cozumu*

[Ozellikler](#-ozellikler) - [Kurulum](#-kurulum) - [Dokumantasyon](#-dokumantasyon) - [Iletisim](#-iletisim)

</div>

---

## Hakkinda

KOA Filo Servis, tasimacilik ve lojistik sektorundeki sirketler icin gelistirilmis, modern ve kapsamli bir ERP cozumudur. Arac filonuzu, personelinizi, muhasebenizi ve tum is sureclerinizi tek bir platformdan yonetin.

## Proje Yapisi

| Proje | Aciklama | Teknoloji |
|-------|----------|-----------|
| **KOAFiloServis.Web** | Ana web uygulamasi | Blazor Server |
| **KOAFiloServis.Mobile** | Mobil uygulama | .NET MAUI |
| **KOAFiloServis.Shared** | Paylasilan modeller | .NET Class Library |
| **KOAFiloServis.Installer** | Kurulum araci | Windows Forms |

## Ozellikler

### Arac Yonetimi
- Arac kaydi ve envanter takibi
- Bakim planlama ve hatirlatmalar
- Kilometre ve yakit takibi
- Belge yonetimi (ruhsat, sigorta, muayene)
- Arac konum takibi

### Personel Yonetimi
- Personel kaydi ve ozluk dosyasi
- Maas yonetimi (resmi/gercek maas ayrimi)
- Bordro olusturma (Normal/AR-GE)
- Hesap pusulasi ve bordro icmali
- Odeme durumu takibi
- Avans ve borc yonetimi
- Izin ve puantaj takibi

### Muhasebe
- Cari hesap yonetimi
- Fatura yonetimi (gelen/giden)
- E-Fatura entegrasyonu
- Banka ve kasa takibi
- Mali raporlar

### Raporlama
- Cari ekstre raporlari
- Muhasebe raporlari
- Personel raporlari
- Arac raporlari
- Excel export destegi

## Teknolojiler

| Kategori | Teknoloji |
|----------|-----------|
| Backend | .NET 10, ASP.NET Core |
| Frontend | Blazor Server, Bootstrap 5 |
| Mobile | .NET MAUI |
| Database | PostgreSQL, Entity Framework Core |
| Reporting | ClosedXML, QuestPDF |
| Authentication | ASP.NET Core Identity |

## Kurulum

### Gereksinimler

- .NET 10 SDK
- PostgreSQL 14+
- Visual Studio 2022+ veya VS Code

### Hizli Baslangic

1. **Repository yi klonlayin**
```bash
git clone https://github.com/karamur/KOAFiloServis.git
cd KOAFiloServis
```

2. **Veritabanini olusturun**
```bash
createdb koafiloservis
dotnet ef database update --project KOAFiloServis.Web
```

3. **Uygulamayi calistirin**
```bash
cd KOAFiloServis.Web
dotnet run
```

4. **Tarayicida acin**
```
https://localhost:5001
```

### Yapilandirma

appsettings.json dosyasinda baglanti dizesini ayarlayin:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=koafiloservis;Username=postgres;Password=your_password"
  }
}
```

## Dokumantasyon

Detayli dokumantasyon icin [Wiki](https://github.com/karamur/KOAFiloServis/wiki) sayfasini ziyaret edin.

## Katkida Bulunma

Bu proje ozel lisans altindadir. Katkida bulunmak icin oncelikle bizimle iletisime gecin.

## Lisans

Bu proje **ozel lisans** altindadir. Ticari kullanim icin yazili izin gereklidir.

## Iletisim

**Allbatros Global Teknoloji**

- Web: [www.allbatros.com](https://www.allbatros.com)
- Email: info@allbatros.com
- GitHub: [@karamur](https://github.com/karamur)

---

<div align="center">

**2024-2026 Allbatros Global Teknoloji**

*Tum haklari saklidir.*

</div>
