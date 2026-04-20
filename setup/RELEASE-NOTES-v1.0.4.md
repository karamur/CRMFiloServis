# KOAFiloServis v1.0.4

**Tarih:** 2026-04-18
**Paket:** `KOAFiloServisKurulum-1.0.4.exe`

## 🎯 Ana Hedef
Bildirim altyapısının genişletilmesi (WhatsApp entegrasyonu), araç bakım periyot takibinin otomasyonu,
dashboard performans iyileştirmeleri ve cache stratejisinin uygulanması.

## ✨ Yenilikler

### WhatsApp Bildirim Entegrasyonu
- **`BelgeUyariBackgroundService`** — Araç belgesi (ruhsat, sigorta, muayene) ve ehliyet bitiş uyarıları artık WhatsApp üzerinden de iletiliyor.
- **Günlük WhatsApp Özet Bildirimi** — Her sabah günlük operasyon özeti (bekleyen işler, vade yaklaşan faturalar, belge uyarıları) WhatsApp ile gönderiliyor.

### Araç Bakım Periyot Otomasyonu
- **`BakimPeriyot` / `AracBakimUyari`** entity'leri ve EF migration eklendi.
- **`BakimPeriyotService`** — Araç bazlı bakım aralıklarını takip eden servis katmanı.
- **`BakimPeriyotJob`** (Quartz, 09:30) — Her gün saat 09:30'da bakım zamanı gelen araçları tespit eder, bildirim ve log üretir.

### Performans İyileştirmeleri
- **Dashboard paralel yükleme** — Dashboard bölümleri `Task.WhenAll` ile eş zamanlı yükleniyor; sayfa açılış süresi belirgin şekilde azaldı.
- **Cache stratejisi** — Güzergah, Araç, Şoför ve MasrafKalemi listeleri `GetOrSetAsync` ile önbelleğe alındı. TTL: Long/Medium. Create/Update/Delete işlemlerinde önbellek otomatik temizleniyor.

### Güvenlik & İzlenebilirlik
- **Dosya indirme audit log** — EBYS evrak, araç belgesi ve e-fatura dosyaları indirildiğinde kullanıcı/zaman/IP audit loguna yazılıyor.
- **Yetkisiz menüleri tamamen gizle** — Loading skeleton ile auth state yenilemesi; STOK item-level yetki kontrolü; `menu.stok` prefix refactoring; `IDisposable` bellek sızıntısı düzeltmesi.
- **`IDbContextFactory` standardizasyonu** — Tüm background service'lerde doğru DbContext yaşam döngüsü sağlandı.

## 🔄 Yükseltme
v1.0.0 – v1.0.3 üzerine doğrudan kurulabilir. Yeni migration'lar (`BakimPeriyot`, `AracBakimUyari`) otomatik uygulanır.

## 🔒 SHA-256
```
{SHA256_PLACEHOLDER}
```
