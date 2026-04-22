# Changelog

Bu dosya, KOAFiloServis projesindeki tüm önemli değişiklikleri kayıt altına almaktadır.  
Format [Keep a Changelog](https://keepachangelog.com/tr/1.0.0/) standardına, sürümlendirme ise [Semantic Versioning](https://semver.org/lang/tr/) kurallarına uygundur.

---

## [Yayınlanmamış] — 2025

### Eklendi
- **MasrafGirisi** — "Son İşlemler" listesine düzenleme + silme butonu eklendi
- **MasrafGirisi** — "Personele Ödenecekler" listesine silme + düzenleme butonu eklendi
- **MasrafGirisi** — Hareket düzenleme modal'ı (tutar, tarih, açıklama, personel güncelleme)
- **MaasYonetimi** — Tabloya "Detay" sütunu ve butonu eklendi (sağ panel detay görünümü)
- **MasrafKalemiList** — "Duplicate Temizle" butonu eklendi (aynı masraf adı tekrarlarını temizler)
- **IMasrafKalemiService / MasrafKalemiService** — `DeleteDuplicatesAsync()` metodu eklendi
- **LastikDegisimList** — Filtre paneli ve form modal'ında araç seçimi için plaka autocomplete eklendi
- **LastikStokList** — Filtre alanına araç plakası autocomplete eklendi (`IAracService` inject edildi)

### Düzeltildi
- **MasrafGirisi** — `BankaKasaHareket.IsPersonelCebinden` readonly property object initializer hatası giderildi
- **KullaniciYonetimi** — `Dictionary<string, string>` → `Dictionary<string, string?>` nullable uyarısı giderildi (QueryHelpers.AddQueryString)
- **DataSync** — `WFO0003` uyarısı giderildi: High DPI ayarı `app.manifest`'ten `ApplicationHighDpiMode` proje özelliğine taşındı

### Yapılandırma
- **Setup.iss / GuncelleSetup.iss / MusteriSetup.iss / LisansSetup.iss** — `OutputDir` fallback değeri `output` → `output\v{#MyAppVersion}` olarak güncellendi
- **build.ps1** — Setup çıktıları her versiyonda `output\v{versiyon}\` versiyonlu alt klasörüne yerleştiriliyor

---

## [v1.0.8] — 2025

### Eklendi
- Maaş ödeme yöntemi seçimi: Elden, Banka, Mahsup, Kredi Kartı
- Personel finans detay panel CRUD işlemleri
- Avans sekmesine yeni avans ekleme özelliği
- Maaş hareketinde avans(-) ve harcama(+) "Eklemeler" sütununda gösterim
- Gerçek muhasebe kaydı oluşturma (PersonelFinans)
- Plaka yazarak arama (tüm formlarda autocomplete)
- Personel cebinden harcama çift kayıt düzeltmesi

### Düzeltildi
- `SgkCalismaTuru` nullable + HasSentinel — EF Core uyarısı 20601 kaldırıldı
- `NpgsqlRetryingExecutionStrategy` transaction hatası giderildi
- Borç ve avans silme — `MuhasebeFisKalem` FK hatası giderildi
- `FisNo` duplicate key ve `PersonelAvans` FK hatası düzeltildi
- Silme işlemlerinde muhasebe fiş + kalem cascade silme tamamlandı

---

## [v1.0.4] — 2025

### Eklendi
- MaasYonetimi bankaya yatan hesaplama ve formül düzeltmeleri
- `HizliStokOlusturAsync` servisi eklendi
- Kurulum çıktısı versiyonlu klasör yapısına (`output\v{versiyon}\`) alındı

### Düzeltildi
- MasrafGirisi çift kayıt hatası giderildi

---

## [v1.0.0] — İlk Yayın

### Eklendi
- Blazor Server (.NET 10) ile tam kapsamlı filo yönetim platformu
- PostgreSQL + SQLite çoklu veritabanı provider desteği
- Araç, Sürücü/Personel, Muhasebe, Bordro, EBYS, İhale modülleri
- ASP.NET Core Identity + JWT Bearer kimlik doğrulama
- Multi-tenant firma izolasyonu (Global Query Filters)
- Inno Setup 6 tabanlı Windows kurulum paketi (IIS otomasyonu dahil)
- KOAFiloServis.LisansDesktop — HWID tabanlı offline lisans aktivasyonu
- KOAFiloServis.DataSync — PostgreSQL → SQLite veri aktarım aracı
- Excel (ClosedXML/EPPlus) ve PDF (QuestPDF) dışa aktarım
- OpenAI + Ollama (yerel LLM) entegrasyonu
- WhatsApp ve e-posta bildirim servisleri
- Quartz.NET zamanlanmış işler (otomatik yedekleme vb.)
