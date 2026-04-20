# KOAFiloServis v1.0.8

**Tarih:** 2026-04-20
**Paket:** `KOAFiloServisKurulum-1.0.8.exe`

## 🎯 Ana Hedef
Personel muhasebe hesap entegrasyonunun tamamlanması (195/335 avans-borç otomasyonu),
KolayGiriş avans akışındaki kritik hataların giderilmesi ve README dökümantasyonu yenilenmesi.

## ✨ Yenilikler

### Personel Muhasebe Hesap Entegrasyonu
- **Personel kartı — 195 / 335 hesap görünümü** — Personel detay sayfasında muhasebe hesap entegrasyonu bölümü; atanmış 195.xx (Personel Avans) ve 335.xx (Personel Borç) hesapları gösteriliyor.
- **Otomatik hesap açılması** — Yeni personel kaydedildiğinde `195.01.{personelId}` ve `335.01.{personelId}` alt hesapları otomatik oluşturuluyor; muhasebe ağacına manuel müdahale gerekmiyor.

### KolayGiriş — Avans & Borç Otomasyonu
- **195/335 hesapları otomatik atama** — KolayGiriş'te avans girildiğinde 195 hesabı, borç girildiğinde 335 hesabı otomatik seçiliyor; kullanıcı hesap kodu aramak zorunda değil.
- **`SoforService.GetPersonelAvansHesabi` / `GetPersonelBorcHesabi`** — Personel adıyla fallback arama desteği; hesap henüz ID ile bulunamazsa isim eşleşmesi deneniyor.
- **Hata detay loglama** — KolayGiriş avans akışında oluşan hatalar artık ayrıntılı log kaydıyla izlenebiliyor.

### Hata Düzeltmeleri
- **FisNo duplicate key hatası giderildi** — Muhasebe fişi oluştururken aynı tarihte çakışan sıra numarası sorunu düzeltildi.
- **PersonelAvans FK hatası giderildi** — Avans kaydı oluşturulurken PersonelId foreign key kısıtı ihlali düzeltildi.
- **Maaş hareketinde avans(-) ve harcama(+)** — Maaş detay ekranında avans kesintileri ve harcama eklemeleri "Eklemeler" sütununda doğru işaretle gösterildi.

### Dökümantasyon
- **README yenilendi** — Profesyonel banner (Capsule Render), güncel badge'ler (.NET 10, Blazor, PostgreSQL, EF Core, Lisans), modül tablosu ve kurulum rehberi güncellendi.

## 🔄 Yükseltme
v1.0.0 – v1.0.7 üzerine doğrudan kurulabilir. Yeni personel hesap migration'ı otomatik uygulanır.

**Not:** Kurulumdan sonra mevcut personel kayıtları için `/ayarlar/personel-hesap-eslestir` sayfasını ziyaret ederek eksik 195/335 hesaplarını otomatik oluşturabilirsiniz (isteğe bağlı, yeni personeller için otomatik çalışır).

## 📦 Paketler

| Paket | Boyut | Açıklama |
|-------|-------|----------|
| `KOAFiloServisKurulum-1.0.8.exe` | 147.5 MB | Tam kurulum (Web + DataSync + LisansDesktop) |
| `KOAFiloServisGuncelle-1.0.8.exe` | 147.5 MB | Mevcut kurulum üzerine güncelleme |
| `KOAFiloServisKurulumMusteri-1.0.8.exe` | 115.0 MB | Müşteri paketi (Lisans aracı hariç) |
| `KOALisansArac-1.0.8.exe` | 35.7 MB | Yalnızca Lisans yönetim aracı |

## 🔒 SHA-256
```
{SHA256_PLACEHOLDER}
```
