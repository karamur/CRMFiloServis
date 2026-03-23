# CRM Filo Servis

Filo Yönetimi, Muhasebe ve CRM Uygulamasý - .NET 10 Blazor Server

## ?? Özellikler

### ?? Ana Modüller

#### 1. **Cari Yönetimi**
- Müþteri ve tedarikçi kaydý
- Cari hesap takibi
- Cari ekstre raporlarý

#### 2. **Filo Servis**
- Araç kaydý ve takibi (Özmal, Kiralýk, Komisyon)
- Þoför yönetimi
- Güzergah tanýmlama
- Servis çalýþmasý kayýtlarý
- Toplu çalýþma giriþi
- Araç masraflarý takibi

#### 3. **E-Fatura / E-Arþiv**
- **Gelen Faturalar (Alýþ)**
  - Ödeme tarihi belirleme
  - Ödeme durumu takibi (Ödendi, Kýsmi Ödendi, Ödenmedi)
  - Vade geçmiþ uyarýlarý
  - Bütçe analize aktarým

- **Giden Faturalar (Satýþ)**
  - Tahsilat durumu (Tahsil Edildi, Kýsmi Tahsilat, Tahsil Edilmedi)
  - Tahsilat raporu
  - Vade takibi

#### 4. **Banka / Kasa**
- Banka hesaplarý yönetimi
- Kasa takibi
- Tahsilat ve ödeme iþlemleri
- Fatura eþleþtirme

#### 5. **Muhasebe**
- Standart hesap planý (otomatik yükleme)
- Muhasebe fiþleri
- Gelir tablosu
- Bilanço

#### 6. **Satýþ Modülü**
- Araç ilanlarý yönetimi
- **Piyasa Araþtýrma**
  - Sahibinden / Arabam karþýlaþtýrma
  - Sadece aktif ilanlar (Satýlmýþ/Kaldýrýlmýþ/Rezerve filtreleme)
  - Fiyat analizi
  - Excel/PDF export
- Satýþ personeli yönetimi
- Komisyon takibi

#### 7. **Personel Yönetimi**
- Personel kaydý
- Maaþ yönetimi
- Ýzin takibi
- Belge uyarýlarý (Ehliyet, SRC, Psikoteknik, Saðlýk Raporu)

#### 8. **Bütçe ve Raporlar**
- Bütçe analizi
- Mali analiz
- Aylýk checklist
- Özmal/Kiralýk araç raporlarý
- Komisyon raporlarý
- Fatura ödeme takvimleri

#### 9. **Sistem Yönetimi**
- Kullanýcý yönetimi
- Rol ve yetki sistemi
- Lisans yönetimi
- Otomatik yedekleme
- Aktivite loglarý

## ??? Teknolojiler

- **.NET 10** - Ana framework
- **Blazor Server** - UI framework
- **Entity Framework Core** - ORM
- **PostgreSQL** - Veritabaný
- **Bootstrap 5** - CSS framework
- **Bootstrap Icons** - Ýkonlar
- **EPPlus** - Excel iþlemleri

## ?? Gereksinimler

- .NET 10 SDK
- PostgreSQL 14+
- Visual Studio 2022 veya VS Code

## ?? Kurulum

1. **Repository'yi klonlayýn:**
```bash
git clone https://github.com/karamur/CRMFiloServis.git
cd CRMFiloServis
```

2. **PostgreSQL baðlantýsýný ayarlayýn:**
`CRMFiloServis.Web/appsettings.json` dosyasýnda:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=crmfiloservis;Username=postgres;Password=yourpassword"
  }
}
```

3. **Uygulamayý çalýþtýrýn:**
```bash
cd CRMFiloServis.Web
dotnet run
```

4. **Tarayýcýda açýn:**
```
http://localhost:5190
```

## ?? Proje Yapýsý

```
CRMFiloServis/
??? CRMFiloServis.Shared/        # Paylaþýlan entity ve modeller
?   ??? Entities/
??? CRMFiloServis.Web/           # Ana Blazor uygulamasý
?   ??? Components/
?   ?   ??? Layout/              # Ana layout ve menü
?   ?   ??? Pages/               # Sayfalar
?   ?   ?   ??? Ayarlar/         # Ayarlar sayfalarý
?   ?   ?   ??? Budget/          # Bütçe modülü
?   ?   ?   ??? EFatura/         # E-Fatura modülü
?   ?   ?   ??? Muhasebe/        # Muhasebe modülü
?   ?   ?   ??? Personel/        # Personel modülü
?   ?   ?   ??? Raporlar/        # Raporlar
?   ?   ?   ??? Satis/           # Satýþ modülü
?   ?   ??? Shared/              # Ortak bileþenler
?   ??? Data/                    # DbContext ve Migrations
?   ??? Services/                # Ýþ mantýðý servisleri
?   ??? wwwroot/                 # Statik dosyalar
??? README.md
```

## ?? Varsayýlan Giriþ

- **Kullanýcý Adý:** admin
- **Þifre:** admin123

## ?? Lisans Türleri

| Özellik | Trial | Basic | Professional | Enterprise |
|---------|-------|-------|--------------|------------|
| Süre | 30 gün | 1 yýl | 1 yýl | 1 yýl |
| Kullanýcý | 5 | 5 | 10 | Sýnýrsýz |
| Excel Export | ? | ? | ? | ? |
| PDF Export | ? | ? | ? | ? |
| Raporlama | ? | ? | ? | ? |
| Yedekleme | ? | ? | ? | ? |
| Muhasebe | ? | - | ? | ? |
| Satýþ Modülü | ? | - | ? | ? |

## ?? Son Güncellemeler

### v1.0.0 (2024)
- ? Gelen fatura ödeme tarihi ve durumu
- ? Giden fatura tahsilat durumu
- ? Bütçe analize otomatik aktarým
- ? Takvimde ödeme gösterimi
- ? Piyasa araþtýrma - aktif ilan filtreleme
- ? Profesyonel login sayfasý
- ? Kullanýcý yönetimi
- ? Standart hesap planý otomatik yükleme

## ?? Katkýda Bulunma

1. Fork yapýn
2. Feature branch oluþturun (`git checkout -b feature/amazing-feature`)
3. Commit yapýn (`git commit -m 'Add some amazing feature'`)
4. Push yapýn (`git push origin feature/amazing-feature`)
5. Pull Request açýn

## ?? Ýletiþim

Sorularýnýz için: [GitHub Issues](https://github.com/karamur/CRMFiloServis/issues)

## ?? Lisans

Bu proje MIT lisansý altýnda lisanslanmýþtýr - detaylar için [LICENSE](LICENSE) dosyasýna bakýn.
