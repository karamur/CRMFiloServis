# KOAFiloServis v1.0.3

**Tarih:** 2026-06-27
**Paket:** `KOAFiloServisKurulum-1.0.3.exe`

## 🎯 Ana Hedef
Hassas dosyaların (EBYS evrak, özlük belgesi, araç belgesi, e-fatura PDF/XML) disk üzerinde şifreli saklanması.
Önceki sürümlerde dosyalar sunucu diskinde düz metin olarak tutuluyordu; bu sürümle **AES-256-GCM** ile şifreleniyor,
doğrudan URL ile erişim kapatıldı, tüm indirmeler güvenli servis katmanından geçiyor.

## ✨ Yenilikler

### Dosya Şifreleme Altyapısı (AES-256-GCM + DPAPI)
- **`IFileProtector` / `AesGcmFileProtector`** — AES-256-GCM ile şifreleme/çözme. Her dosya için benzersiz nonce + tag.
  Format: `KOA1 | ver | nonce(12B) | tag(16B) | ciphertext`.
- **`IMasterKeyProvider` / `DpapiMasterKeyProvider`** — 256-bit master key Windows DPAPI LocalMachine koruma altında diskte saklanır. Uygulama yeniden başlatıldığında key bellekte önbelleğe alınır.
- **Geriye uyumluluk** — v1.0.2 ve önceki `IDataProtector` (ASP.NET Data Protection) ile şifrelenmiş dosyalar okunmaya devam eder; yeni yazmalar AES-GCM kullanır.

### EBYS Dosya Güvenliği
- EBYS evrak dosyaları artık `wwwroot/uploads/ebys/` altında **düz metin olarak saklanmıyor**.
- Tüm yükleme/güncelleme işlemleri `ISecureFileService` üzerinden → şifreli storage'a yazılıyor.
- `EvrakDetay.razor` sayfasındaki doğrudan `<a href>` indirme linkleri kaldırıldı; dosya içeriği servis katmanından okunup tarayıcıya aktarılıyor.

### Dosya Şifreleme Migration Aracı
- **`/ayarlar/dosya-migrasyonu`** — Mevcut kurulumda eski düz metin dosyaları tek tıkla şifreli storage'a taşır.
  - Önce tarar (kaç dosya bekliyor gösterir), sonra başlatılır.
  - Canlı progress bar, dosya bazında sonuç tablosu.
  - Zaten şifreli dosyaları atlar (idempotent), disk'te bulunamayan dosyaları loglar.
  - İşlem tamamlandıktan sonra eski düz dosyalar silinir.

### Güvenlik Denetimi
- `AracService`, `EbysService`, `FaturaService` — tüm dosya I/O `ISecureFileService` üzerinden.
- Servis dışındaki hiçbir nokta artık `IBrowserFile.OpenReadStream` + ham `File.WriteAllBytes` yapmıyor.
- Unit testler: `AesGcmFileProtectorTests` (6 test) + `DpapiMasterKeyProviderTests` (2 test) → 291 test toplamda geçiyor.

## 🔄 Yükseltme
v1.0.0 / v1.0.1 / v1.0.2 üzerine doğrudan kurulabilir. Kullanıcı verileri korunur.

**⚠️ Önemli:** Kurulumdan sonra ilk çalıştırmada `/ayarlar/dosya-migrasyonu` sayfasına giderek
"Tara" → "Migrasyonu Başlat" adımlarını çalıştırın. Bu işlem eski plain dosyaları şifreler ve bir kez yapılması yeterlidir.

## 🔒 SHA-256
```
{SHA256_PLACEHOLDER}
```
