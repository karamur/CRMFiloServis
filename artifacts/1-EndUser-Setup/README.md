# KOA Filo Servis - Son Kullanıcı Kurulum Rehberi

## 📦 Paket İçeriği

```
1-EndUser-Setup/
├── app/
│   ├── KOAFiloServis.Web.exe    # Ana uygulama (107 MB, self-contained)
│   ├── appsettings.json         # Yapılandırma
│   └── wwwroot/                 # Statik dosyalar
├── Kur.bat                      # Çift tıkla kurulum
├── Baslat.bat                   # Hızlı başlatma
├── install.ps1                  # PowerShell kurulum
├── install-service.ps1          # Windows Service kurulumu
├── docker-compose.yml           # Docker ile kurulum
└── README.md                    # Bu dosya
```

---

## 🚀 Hızlı Kurulum (4 Yöntem)

### Yöntem 1: Çift Tıkla Kurulum (En Kolay) ⭐

```
1. "Kur.bat" dosyasına çift tıklayın
2. Kurulum otomatik tamamlanır
3. Tarayıcı otomatik açılır
```

---

### Yöntem 2: Direkt Çalıştırma

```
1. "Baslat.bat" dosyasına çift tıklayın
2. Tarayıcıda http://localhost:5000 açın
```

---

### Yöntem 3: PowerShell Kurulum (Önerilen)

```powershell
# PowerShell'i Yönetici olarak açın
.\install.ps1
```

Bu script:
- ✅ C:\KOAFiloServis dizinine kurar
- ✅ Masaüstü kısayolu oluşturur
- ✅ Başlat menüsüne ekler
- ✅ Firewall kuralı ekler

---

### Yöntem 4: Windows Service Olarak

```powershell
# Yönetici olarak çalıştırın
.\install-service.ps1
```

Service olarak kurulum:
- Bilgisayar açıldığında otomatik başlar
- Arka planda çalışır
- Windows Hizmetleri'nden yönetilir

---

### Yöntem 5: Docker ile

```bash
docker-compose up -d
```

---

## ⚙️ Yapılandırma

`app\appsettings.json` dosyasını düzenleyin:

### Veritabanı
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=koafilo;Username=postgres;Password=SIFRE"
  }
}
```

### Port Değiştirme
```json
{
  "Kestrel": {
    "Endpoints": {
      "Http": { "Url": "http://0.0.0.0:8080" }
    }
  }
}
```

---

## 📋 Sistem Gereksinimleri

| Bileşen | Minimum | Önerilen |
|---------|---------|----------|
| İşletim Sistemi | Windows 10 x64 | Windows 11/Server 2022 |
| RAM | 2 GB | 4 GB |
| Disk | 500 MB | 2 GB |
| .NET Runtime | Gerekmez (dahil) | - |

---

## 🔧 Sorun Giderme

### Uygulama Açılmıyor
1. Yönetici olarak çalıştırın
2. Antivirüs yazılımını kontrol edin
3. Port 5000'in boş olduğundan emin olun:
   ```powershell
   netstat -ano | findstr :5000
   ```

### Veritabanı Hatası
- SQLite kullanmak için `appsettings.json`:
  ```json
  "UseSqlite": true
  ```

---

## 📞 Destek

- **E-posta:** support@koafiloservis.com
- **Web:** https://koafiloservis.com

**Versiyon:** 1.0.0
