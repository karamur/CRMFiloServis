# KOAFiloServis v1.0.6

**Tarih:** 2026-04-18
**Paket:** `KOAFiloServisKurulum-1.0.6.exe`

## 🎯 Ana Hedef
Muhasebe entegrasyonunun derinleştirilmesi (KDV hesap kodu eşleştirme, proforma fatura PDF),
kurulum paketlerinin yeniden yapılandırılması (güncelleme paketi, müşteri paketi, lisans paketi ayrımı).

## ✨ Yenilikler

### KDV Muhasebe Hesap Kodu Eşleştirmesi
- **KDV oranına göre otomatik muhasebe hesap kodu** eşleştirmesi eklendi.
  - %1, %10, %20 KDV oranları için ayrı 391 hesap alt kodları.
  - Fatura kaydedilirken KDV tutarı otomatik olarak doğru hesaba yazılıyor.
- KDV oran lookup mantığındaki eksik noktalar tamamlandı (2 edge case düzeltme).

### Proforma Fatura PDF
- **`/faturalar/proforma/{id}/yazdir`** — Antetli kâğıt şablonuyla proforma fatura yazdır/PDF sayfası eklendi.
- Şirket logosu, adres, vergi numarası bilgileri PDF'e otomatik yerleştiriliyor.
- Tarayıcıdan doğrudan yazdırma ve PDF indirme desteği.

### Kurulum Paketi Yeniden Yapısı
- **Güncelleme Paketi** (`KOAFiloServisGuncelle-x.x.x.exe`) — Mevcut kurulum üzerine veri kaybı olmadan güncelleme yapan ayrı paket eklendi. Güncelleme sihirbazı: otomatik yedekleme → servis durdurma → dosya güncelleme → migration → servis başlatma akışı.
- **Müşteri Paketi** (`KOAFiloServisKurulumMusteri-x.x.x.exe`) — Lisans aracı olmayan sadece web uygulaması içeren müşteri kurulum paketi eklendi.
- **`build.ps1`** güncellendi — 4 paket (Ana, Güncelleme, Müşteri, Lisans) tek komutla üretilebiliyor.
- **`update-server.ps1`** yeniden yazıldı — SSH üzerinden uzak sunucu güncelleme otomasyonu iyileştirildi.

## 🔄 Yükseltme
v1.0.0 – v1.0.5 üzerine doğrudan kurulabilir. Yeni muhasebe hesap kodu eşleştirmesi mevcut faturalara geriye dönük uygulanmaz; yeni faturalar için geçerlidir.

## 🔒 SHA-256
```
{SHA256_PLACEHOLDER}
```
