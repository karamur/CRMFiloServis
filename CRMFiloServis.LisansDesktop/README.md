# CRM Filo Servis - Lisans Oluþturucu Desktop Uygulamasý

## Kurulum

1. `CRMFiloServisLisans.exe` dosyasýný çalýþtýrýn
2. Veya `Kurulum.bat` ile otomatik kurulum yapýn

## Kullaným

### Lisans Oluþturma

1. **Lisans Tipi Seçin** veya **Özel Süre** girin:
   - Gün: 0-999
   - Ay: 0-99
   - Yýl: 0-99

2. **Müþteri Bilgileri**:
   - Firma Adý (zorunlu)
   - Yetkili Kiþi
   - Email
   - Telefon

3. **Müþteri Makine Kodu**:
   - Müþteriden alýn
   - Veya "Bu PC'nin Kodunu Al" butonuna týklayýn (test için)

4. **Oluþtur** butonuna týklayýn

5. **Lisans Anahtarý**:
   - Panoya kopyalayýn veya
   - Dosyaya kaydedin

### Lisans Doðrulama

1. Lisans Anahtarýný yapýþtýrýn
2. **Doðrula** butonuna týklayýn
3. Sonuçlarý görün:
   - ? Lisans geçerli
   - ? Lisans geçersiz
   - Makine kodu uyumu

## Önemli Notlar

?? **Makine Koduna Baðlý Lisans**
- Her lisans sadece 1 bilgisayara özeldir
- Baþka bilgisayarda çalýþmaz
- Donaným deðiþikliðinde yeni lisans gerekir

?? **Güvenlik**
- AES-256 þifreleme
- SHA-256 makine kodu hash'i
- Kopyalanamaz lisans sistemi

## Dosya Konumu

Kurulum Sonrasý:
- Program: `C:\Program Files\CRMFiloServisLisans\CRMFiloServisLisans.exe`
- Masaüstü Kýsayolu: `Desktop\CRM Lisans Oluþturucu.lnk`
- Baþlat Menüsü: `Start Menu\CRM Lisans Oluþturucu.lnk`

## Güncelleme Geçmiþi

### v2.0 (Mevcut)
- ? Makine koduna baðlý lisans
- ? Özel süre seçimi (Gün+Ay+Yýl)
- ? Makine kodu doðrulama
- ? Tek dosya EXE (128 MB)

### v1.0
- Temel lisans oluþturma
- 4 lisans tipi
- Dosyaya kaydetme
