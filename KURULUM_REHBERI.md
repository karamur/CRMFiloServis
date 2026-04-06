# CRM Filo Servis - Kurulum Rehberi

Bu belge, CRM Filo Servis uygulamasının sunucu kurulumu, veritabanı yedekleme ve güncelleme işlemlerini açıklar.

## İçindekiler
1. [Sistem Gereksinimleri](#sistem-gereksinimleri)
2. [Windows Server Kurulumu](#windows-server-kurulumu)
3. [Linux Server Kurulumu](#linux-server-kurulumu)
4. [PostgreSQL Veritabanı Kurulumu](#postgresql-veritabanı-kurulumu)
5. [Uygulama Kurulumu](#uygulama-kurulumu)
6. [Veritabanı Yedekleme](#veritabanı-yedekleme)
7. [Güncelleme İşlemleri](#güncelleme-işlemleri)
8. [Sorun Giderme](#sorun-giderme)

---

## Sistem Gereksinimleri

### Minimum Gereksinimler
- **İşlemci:** 2 çekirdek
- **RAM:** 4 GB
- **Disk:** 50 GB SSD
- **İşletim Sistemi:** Windows Server 2019+ veya Ubuntu 20.04+

### Önerilen Gereksinimler
- **İşlemci:** 4+ çekirdek
- **RAM:** 8+ GB
- **Disk:** 100+ GB SSD
- **İşletim Sistemi:** Windows Server 2022 veya Ubuntu 22.04 LTS

### Yazılım Gereksinimleri
- .NET 10 Runtime
- PostgreSQL 14+
- ASP.NET Core Hosting Bundle (Windows)

---

## Windows Server Kurulumu

### 1. .NET 10 Runtime Kurulumu

```powershell
# .NET 10 ASP.NET Core Hosting Bundle indir ve kur
# https://dotnet.microsoft.com/download/dotnet/10.0

# PowerShell ile kontrol
dotnet --list-runtimes
```

### 2. IIS Kurulumu (Opsiyonel)

```powershell
# IIS ve ASP.NET Core modülünü kur
Install-WindowsFeature -Name Web-Server -IncludeManagementTools
Install-WindowsFeature -Name Web-Asp-Net45
```

### 3. Uygulama Klasörü Oluşturma

```powershell
# Uygulama klasörünü oluştur
New-Item -Path "C:\CRMFiloServis" -ItemType Directory

# Gerekli izinleri ayarla
$acl = Get-Acl "C:\CRMFiloServis"
$permission = "IIS AppPool\CRMFiloServis","FullControl","ContainerInherit,ObjectInherit","None","Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($permission)
$acl.SetAccessRule($accessRule)
Set-Acl "C:\CRMFiloServis" $acl
```

### 4. Windows Servis Olarak Çalıştırma

```powershell
# Servisi oluştur
sc.exe create CRMFiloServis binPath="C:\CRMFiloServis\CRMFiloServis.Web.exe" start=auto

# Servisi başlat
sc.exe start CRMFiloServis

# Servis durumunu kontrol et
sc.exe query CRMFiloServis
```

---

## Linux Server Kurulumu

### 1. .NET 10 Runtime Kurulumu (Ubuntu)

```bash
# Microsoft paket deposunu ekle
wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# .NET Runtime kur
sudo apt-get update
sudo apt-get install -y aspnetcore-runtime-10.0

# Kontrol et
dotnet --list-runtimes
```

### 2. Uygulama Klasörü ve Kullanıcı Oluşturma

```bash
# Uygulama klasörünü oluştur
sudo mkdir -p /opt/crm-filo-servis
sudo mkdir -p /var/log/crm-filo-servis

# Uygulama kullanıcısı oluştur
sudo useradd -r -s /bin/false crmfiloservis

# İzinleri ayarla
sudo chown -R crmfiloservis:crmfiloservis /opt/crm-filo-servis
sudo chown -R crmfiloservis:crmfiloservis /var/log/crm-filo-servis
```

### 3. Systemd Servis Dosyası Oluşturma

```bash
sudo nano /etc/systemd/system/crm-filo-servis.service
```

İçeriği:
```ini
[Unit]
Description=CRM Filo Servis Web Uygulamasi
After=network.target postgresql.service

[Service]
WorkingDirectory=/opt/crm-filo-servis
ExecStart=/usr/bin/dotnet /opt/crm-filo-servis/CRMFiloServis.Web.dll
Restart=always
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=crm-filo-servis
User=crmfiloservis
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=ASPNETCORE_URLS=http://0.0.0.0:5190
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false

[Install]
WantedBy=multi-user.target
```

### 4. Servisi Başlatma

```bash
# Systemd'yi yeniden yükle
sudo systemctl daemon-reload

# Servisi etkinleştir ve başlat
sudo systemctl enable crm-filo-servis
sudo systemctl start crm-filo-servis

# Durumu kontrol et
sudo systemctl status crm-filo-servis

# Logları izle
sudo journalctl -u crm-filo-servis -f
```

---

## PostgreSQL Veritabanı Kurulumu

### Windows'ta PostgreSQL Kurulumu

1. https://www.postgresql.org/download/windows/ adresinden indirin
2. Kurulum sihirbazını takip edin
3. Şifrenizi not edin
4. Port: 5432 (varsayılan)

### Linux'ta PostgreSQL Kurulumu

```bash
# PostgreSQL kur
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib

# PostgreSQL'i başlat
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Veritabanı ve kullanıcı oluştur
sudo -u postgres psql
```

PostgreSQL komutları:
```sql
-- Kullanıcı oluştur
CREATE USER crm_filo_user WITH PASSWORD 'GucluSifre123!';

-- Veritabanı oluştur
CREATE DATABASE crm_filo_db OWNER crm_filo_user;

-- Yetkileri ver
GRANT ALL PRIVILEGES ON DATABASE crm_filo_db TO crm_filo_user;

-- Çık
\q
```

### Uzak Bağlantı İzni (pg_hba.conf)

```bash
sudo nano /etc/postgresql/14/main/pg_hba.conf
```

Ekle:
```
# IPv4 local connections:
host    crm_filo_db     crm_filo_user   0.0.0.0/0       scram-sha-256
```

```bash
sudo nano /etc/postgresql/14/main/postgresql.conf
```

Değiştir:
```
listen_addresses = '*'
```

PostgreSQL'i yeniden başlat:
```bash
sudo systemctl restart postgresql
```

---

## Uygulama Kurulumu

### 1. Dosyaları Kopyalama

```bash
# Uygulamayı hedefe kopyala
scp -r ./publish/* kullanici@sunucu:/opt/crm-filo-servis/
```

### 2. Veritabanı Bağlantısını Yapılandırma

`dbsettings.json` dosyasını oluşturun veya düzenleyin:

```json
{
  "Provider": 1,
  "Host": "localhost",
  "Port": 5432,
  "Database": "crm_filo_db",
  "Username": "crm_filo_user",
  "Password": "GucluSifre123!",
  "SslMode": 0
}
```

**Provider Değerleri:**
- 0 = SQLite
- 1 = PostgreSQL
- 2 = MySQL
- 3 = SQL Server

### 3. İlk Çalıştırma

```bash
cd /opt/crm-filo-servis
dotnet CRMFiloServis.Web.dll
```

Uygulama otomatik olarak:
- Veritabanı tablolarını oluşturur
- Varsayılan admin kullanıcısını oluşturur
- Gerekli seed verilerini yükler

**Varsayılan Giriş Bilgileri:**
- Kullanıcı Adı: `admin`
- Şifre: `Admin123!`

---

## Veritabanı Yedekleme

### PostgreSQL Yedekleme (Manuel)

```bash
# Tüm veritabanını yedekle
pg_dump -U crm_filo_user -h localhost -d crm_filo_db -F c -f /backup/crm_filo_$(date +%Y%m%d_%H%M%S).backup

# SQL formatında yedekle
pg_dump -U crm_filo_user -h localhost -d crm_filo_db > /backup/crm_filo_$(date +%Y%m%d_%H%M%S).sql
```

### PostgreSQL Yedekleme (Otomatik - Cron)

```bash
# Crontab düzenle
crontab -e

# Her gün gece 02:00'de yedekle
0 2 * * * pg_dump -U crm_filo_user -h localhost -d crm_filo_db -F c -f /backup/crm_filo_$(date +\%Y\%m\%d).backup 2>> /var/log/backup.log
```

### Yedekten Geri Yükleme

```bash
# Özel format yedekten geri yükle
pg_restore -U crm_filo_user -h localhost -d crm_filo_db -c /backup/crm_filo_20250406.backup

# SQL formatından geri yükle
psql -U crm_filo_user -h localhost -d crm_filo_db < /backup/crm_filo_20250406.sql
```

### Uygulama İçinden Yedekleme

Uygulama **Ayarlar > Veritabanı Yedekleme** bölümünden:
1. Manuel yedek alabilirsiniz
2. Otomatik yedekleme zamanlaması yapabilirsiniz
3. Yedek dosyalarını indirebilirsiniz

---

## Güncelleme İşlemleri

### 1. Yedek Al
```bash
# Önce veritabanı yedeği al
pg_dump -U crm_filo_user -h localhost -d crm_filo_db -F c -f /backup/pre_update_$(date +%Y%m%d_%H%M%S).backup

# Uygulama dosyalarını yedekle
cp -r /opt/crm-filo-servis /opt/crm-filo-servis.backup
```

### 2. Servisi Durdur
```bash
sudo systemctl stop crm-filo-servis
```

### 3. Yeni Dosyaları Kopyala
```bash
# Eski dosyaları temizle (dbsettings.json ve wwwroot/uploads hariç)
cd /opt/crm-filo-servis
rm -rf *.dll *.exe *.json
# dbsettings.json'ı koru
cp ../crm-filo-servis.backup/dbsettings.json .

# Yeni dosyaları kopyala
scp -r ./publish/* kullanici@sunucu:/opt/crm-filo-servis/
```

### 4. Migration'ları Uygula
Uygulama ilk çalıştığında otomatik olarak bekleyen migration'ları uygular.

### 5. Servisi Başlat
```bash
sudo systemctl start crm-filo-servis
sudo systemctl status crm-filo-servis
```

### 6. Test Et
- Web arayüzüne giriş yapın
- Temel işlevleri test edin
- Logları kontrol edin

### Geri Alma (Rollback)

```bash
# Servisi durdur
sudo systemctl stop crm-filo-servis

# Eski dosyaları geri yükle
rm -rf /opt/crm-filo-servis
cp -r /opt/crm-filo-servis.backup /opt/crm-filo-servis

# Veritabanını geri yükle (gerekirse)
pg_restore -U crm_filo_user -h localhost -d crm_filo_db -c /backup/pre_update_*.backup

# Servisi başlat
sudo systemctl start crm-filo-servis
```

---

## Sorun Giderme

### Uygulama Başlamıyor

1. **Log dosyalarını kontrol edin:**
   ```bash
   sudo journalctl -u crm-filo-servis -n 100
   ```

2. **Veritabanı bağlantısını kontrol edin:**
   ```bash
   psql -U crm_filo_user -h localhost -d crm_filo_db
   ```

3. **Port kullanımını kontrol edin:**
   ```bash
   sudo lsof -i :5190
   ```

### Veritabanı Bağlantı Hatası

1. PostgreSQL servisini kontrol edin:
   ```bash
   sudo systemctl status postgresql
   ```

2. Bağlantı bilgilerini doğrulayın:
   ```bash
   cat /opt/crm-filo-servis/dbsettings.json
   ```

3. Firewall ayarlarını kontrol edin:
   ```bash
   sudo ufw status
   sudo ufw allow 5432/tcp
   ```

### Performans Sorunları

1. **Sistem kaynaklarını kontrol edin:**
   ```bash
   htop
   df -h
   ```

2. **PostgreSQL optimizasyonu:**
   ```sql
   -- Yavaş sorguları bul
   SELECT pid, now() - pg_stat_activity.query_start AS duration, query
   FROM pg_stat_activity
   WHERE (now() - pg_stat_activity.query_start) > interval '5 minutes';
   ```

3. **Veritabanı bakımı:**
   ```sql
   VACUUM ANALYZE;
   REINDEX DATABASE crm_filo_db;
   ```

---

## Güvenlik Önerileri

1. **Güçlü şifreler kullanın**
2. **Firewall yapılandırın** - Sadece gerekli portları açın
3. **SSL/TLS kullanın** - Nginx veya IIS ile reverse proxy
4. **Düzenli yedek alın** - Otomatik yedekleme zamanlaması
5. **Güncellemeleri takip edin** - Güvenlik yamaları
6. **Log rotasyonu yapın** - Disk dolmasını önleyin

### Nginx Reverse Proxy (Örnek)

```nginx
server {
    listen 80;
    server_name crm.sirketiniz.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name crm.sirketiniz.com;

    ssl_certificate /etc/letsencrypt/live/crm.sirketiniz.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/crm.sirketiniz.com/privkey.pem;

    location / {
        proxy_pass http://localhost:5190;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

---

## Destek

Sorularınız için:
- GitHub: https://github.com/karamur/CRMFiloServis
- E-posta: destek@allglb.com

---

*Son Güncelleme: Nisan 2025*
