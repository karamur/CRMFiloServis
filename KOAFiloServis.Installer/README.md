# KOA Filo Servis - Yedekleme & Kurulum Aracı

Windows Forms tabanlı masaüstü uygulama. PostgreSQL veritabanı yedekleme, geri yükleme ve uygulama kurulum işlemlerini tek bir arayüzden yönetir.

## 📋 Özellikler

### 📦 Yedek Al Sekmesi
- PostgreSQL veritabanı bağlantı ayarları
- Bağlantı testi
- `pg_dump` ile veritabanı yedeği alma
- ZIP formatında sıkıştırılmış yedek paketi (SQL + dbsettings.json)
- Yedek geçmişi listesi

### 📥 Yedek Yükle Sekmesi
- Hedef PostgreSQL bağlantı ayarları
- ZIP veya SQL dosyası seçimi
- Veritabanı otomatik oluşturma seçeneği
- Mevcut verileri temizleme seçeneği
- `psql` ile yedek geri yükleme

### ⚙️ Kurulum Sekmesi
- Normal (IIS/Windows) veya Docker kurulum seçenekleri
- Sıfır kurulum veya mevcut yedekle kurulum modları
- Kurulum paketi seçimi
- Hedef dizin seçimi
- IIS konfigürasyonu ve Docker Compose dosyası oluşturma

## 🔧 Gereksinimler

### PostgreSQL İşlemleri İçin
- PostgreSQL kurulu olmalı
- `pg_dump` ve `psql` araçları PATH'te veya PostgreSQL kurulum dizininde bulunmalı
- Tipik konum: `C:\Program Files\PostgreSQL\{version}\bin\`

### Kurulum İşlemleri İçin
- **Normal Kurulum:** IIS ve .NET 10 Hosting Bundle
- **Docker Kurulum:** Docker Desktop

## 📦 Kullanım

### Tek EXE Olarak Çalıştırma
```
KOAFiloServisKurulum.exe
```

### Yedek Alma
1. "Yedek Al" sekmesine geçin
2. PostgreSQL bağlantı bilgilerini girin
3. "Bağlantı Test" ile bağlantıyı doğrulayın
4. İsteğe bağlı: Yedek kayıt konumunu değiştirin
5. "Yedek Al" butonuna tıklayın

### Yedek Yükleme
1. "Yedek Yükle" sekmesine geçin
2. Hedef PostgreSQL bağlantı bilgilerini girin
3. "Bağlantı Test" ile bağlantıyı doğrulayın
4. ZIP veya SQL yedek dosyasını seçin
5. Seçenekleri ayarlayın (DB oluştur, temizle)
6. "Yedek Yükle" butonuna tıklayın

### Kurulum
1. "Kurulum" sekmesine geçin
2. Kurulum tipini seçin (Normal/Docker)
3. Kurulum modunu seçin (Sıfır/Mevcut Yedek)
4. Gerekirse yedek ve paket dosyalarını seçin
5. Hedef dizini belirleyin
6. "Kurulumu Başlat" butonuna tıklayın

## 📁 Yedek Dosya Formatı

ZIP yedek paketi şunları içerir:
- `database.sql` - PostgreSQL dump dosyası
- `dbsettings.json` - Bağlantı ayarları

## 🔑 Lisans

Uygulama alt kısmında makine kodu görüntülenir. Bu kod lisans aktivasyonu için kullanılır.

## 📝 Notlar

- Varsayılan yedek konumu: `Belgelerim\KOAFiloServis_Yedekler`
- `dbsettings.json` dosyası varsa, bağlantı ayarları otomatik yüklenir
- Yedek yükleme işlemi mevcut verileri değiştirebilir - dikkatli kullanın!
