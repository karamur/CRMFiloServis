# KOAFiloServis v1.0.7

**Tarih:** 2026-04-19
**Paket:** `KOAFiloServisKurulum-1.0.7.exe`

## 🎯 Ana Hedef
Setup sihirbazı ve lisans aktivasyon akışının eklenmesi; bordro, puantaj ve maaş yönetimi modüllerinin
kapsamlı yeniden yapılandırılması; KolayGiriş muhasebe entegrasyonunun derinleştirilmesi.

## ✨ Yenilikler

### Setup Sihirbazı & Lisans Aktivasyonu
- **`/setup`** — Yeni kurulum için adım adım kurulum sihirbazı eklendi: veritabanı bağlantısı, şirket bilgileri, admin kullanıcı oluşturma.
- **Lisans aktivasyon sayfası** — Lisans anahtarı girişi ve doğrulama ekranı eklendi.
- **Admin şifresi güvenliği** — SetupWizard'da admin şifresi artık hash'lenerek kaydediliyor (güvenlik iyileştirmesi).

### IIS Deploy Otomasyonu
- **`iis-configure.ps1`** güncellemesi — Kurulum sonrası IIS site + AppPool otomatik yapılandırma betiği iyileştirildi.
- Otomatik muhasebe fişi oluşturma hatası düzeltildi (UTC dönüşüm ve FK kısıtı).

### Bordro & Maaş Yönetimi
- **Maaş sayfaları tek sekme yapısında birleştirildi** — Normal bordro, AR-GE bordro ve özet tek sekme grubu altında.
- **PersonelHarcaması eklemeler kolonunda gösterildi** — Maaş yönetimi ekranında personel harcamalarının özet görünümü.
- **Puantaj toplu saat/gün tablosu** — Tüm personel için matris tablo (personel × gün) ile toplu puantaj girişi.
- **Toplu birim ücret modal** — Birden fazla personele aynı anda birim ücret atama.
- **Maaş kayıt hatası yakalama** — `UpdateMaas` navigation property fix ile kayıt tutarsızlıkları giderildi.

### Ödeme & Durum Yönetimi
- **Ödeme Durumu ve Durum Tablosu tek tabloda birleştirildi** — MaasYonetimi'nde 3. sekme olarak sadeleştirildi.
- Ayrı `PersonelDurum.razor` sayfası kaldırıldı; içerik MaasYonetimi 4. sekmesine taşındı.

### KolayGiriş — Avans & Mahsup Entegrasyonu
- **`KolayGiriş Avans`** — Personel seçimi doğrudan personel listesinden; `PersonelAvans` kaydı otomatik oluşturuluyor.
- **`MahsupKaydı`** — BankaKasaHareket stok hareketleri ve `GetHesapId` UTC düzeltmeleri.
- **`BankaKasaHareket`** — `MuhasebeFisId` FK, geri bağlantılar ve `IslemKaynak.CariMahsup` enum değeri eklendi.

### Güvenlik
- **MailKit 4.16.0** — NuGet güvenlik açığı gidermek için MailKit yükseltildi (CVE düzeltmesi).
- BudgetService'deki CS8629 nullable uyarısı düzeltildi.

## 🔄 Yükseltme
v1.0.0 – v1.0.6 üzerine doğrudan kurulabilir. Setup sihirbazı mevcut kurulumları etkilemez (yalnızca yeni kurulum için tetiklenir).

## 🔒 SHA-256
```
{SHA256_PLACEHOLDER}
```
