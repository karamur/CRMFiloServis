# KOAFiloServis v1.0.5

**Tarih:** 2026-04-18
**Paket:** `KOAFiloServisKurulum-1.0.5.exe`

## 🎯 Ana Hedef
Dashboard kişiselleştirme, çoklu dil desteği (i18n), klavye kısayolları, analitik altyapısı ve
entegrasyon rehberlerinin eklenmesi. FAZ 9 + FAZ 8.5 kapsamındaki açık işlerin tamamlanması.

## ✨ Yenilikler

### Çoklu Dil Desteği (i18n)
- Uygulama genelinde Türkçe / İngilizce dil seçimi altyapısı eklendi.
- Dil tercihi `localStorage`'da kalıcı olarak saklanıyor.
- Kullanıcı profil sayfasından dil değiştirilebiliyor.

### Klavye Kısayolları
- Uygulama geneli klavye kısayol sistemi eklendi (Alt+N yeni kayıt, Alt+S kaydet, Ctrl+/ yardım vb.).
- Kısayol rehberi modal'ı (? tuşu ile erişilebilir).

### Analitik Endpoint
- Sayfa görüntüleme, özellik kullanım istatistikleri için dahili analitik endpoint eklendi.
- Admin panelinden kullanım metrikleri görüntülenebilir.

### Dashboard Widget Sıralama
- Dashboard widget'ları yukarı/aşağı ok butonları ile yeniden sıralanabiliyor.
- Sıralama `localStorage`'da kalıcı olarak saklanıyor; her kullanıcı kendi dashboard düzenini ayarlıyor.
- Home.razor ana sayfa widget düzeni güncellendi.

### Power BI / Grafana / n8n Entegrasyon Rehberi
- **`/entegrasyon/rehber`** — Power BI, Grafana ve n8n iş akışı otomasyon araçlarına bağlantı kurulum rehberi sayfası eklendi.
- PostgreSQL bağlantı şeması, Grafana dashboard örnek sorgular, n8n webhook tetikleyici şablonları.

### FAZ 9 + FAZ 8.5 Tamamlama
- Dark Mode, Favoriler/Hızlı Erişim, Teams/Slack bildirimleri, IP Beyaz/Kara Liste, Zamanli Raporlama, KVKK araçları, Rakip Benchmark, S3 Object Storage kapsamındaki tüm açık işler kapatıldı.

## 🔄 Yükseltme
v1.0.0 – v1.0.4 üzerine doğrudan kurulabilir.

## 🔒 SHA-256
```
{SHA256_PLACEHOLDER}
```
