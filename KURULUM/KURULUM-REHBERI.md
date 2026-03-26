# CRM Filo Servis - Kurulum ve Yayýn Rehberi

## ?? Ýçindekiler

1. [Gereksinimler](#gereksinimler)
2. [Hýzlý Kurulum (Otomatik)](#hýzlý-kurulum-otomatik)
3. [Manuel Kurulum (Adým Adým)](#manuel-kurulum-adým-adým)
4. [Að Üzerinden Eriþim (IP ile Yayýn)](#að-üzerinden-eriþim)
5. [Windows Servisi Olarak Çalýþtýrma](#windows-servisi)
6. [Veritabaný Yedekleme ve Geri Yükleme](#veritabaný-yönetimi)
7. [Sorun Giderme](#sorun-giderme)
8. [Dosya Yapýsý](#dosya-yapýsý)

---

## Gereksinimler

| Bileþen | Minimum | Önerilen |
|---------|---------|----------|
| Ýþletim Sistemi | Windows 10/11, Server 2019+ | Windows 11, Server 2022 |
| RAM | 4 GB | 8 GB |
| Disk | 2 GB boþ alan | 10 GB (yedekler için) |
| .NET | ASP.NET Core 10.0 Runtime | Hosting Bundle 10.0 |
| Veritabaný | PostgreSQL 15+ | PostgreSQL 16+ |

### Ýndirme Linkleri

- **.NET 10 Hosting Bundle**: https://dotnet.microsoft.com/download/dotnet/10.0
  - "Hosting Bundle" indirin (ASP.NET Core Runtime + Windows Server Hosting dahil)
- **PostgreSQL**: https://www.postgresql.org/download/windows/
  - Kurulum sýrasýnda þifrenizi not edin

---

## Hýzlý Kurulum (Otomatik)

### Adým 1: Geliþtirme PC'de Publish Edin

```
KURULUM\yayinla.bat
```

Bu komut projeyi derleyip `KURULUM\publish\` klasörüne çýkarýr.

### Adým 2: Hedef PC'ye Kopyalayýn

`KURULUM\` klasörünün tamamýný hedef PC'ye kopyalayýn (USB, að paylaþýmý vb.).

### Adým 3: Hedef PC'de Kurulumu Çalýþtýrýn

```
kur.bat  (Sað týkla ? Yönetici olarak çalýþtýr)
```

### Adým 4: Firewall Portlarýný Açýn

```
firewall-ac.bat  (Sað týkla ? Yönetici olarak çalýþtýr)
```

### Adým 5: Servisi Baþlatýn

```
servis-yonet.bat ? 1. Servisi Baþlat
```

**Eriþim**: `http://SUNUCU_IP:5190`

---

## Manuel Kurulum (Adým Adým)

### 1. .NET 10 Runtime Kurulumu

```powershell
# Mevcut .NET sürümlerini kontrol edin
dotnet --list-runtimes

# Eðer "Microsoft.AspNetCore.App 10.x" yoksa Hosting Bundle indirin
# https://dotnet.microsoft.com/download/dotnet/10.0
```

### 2. PostgreSQL Kurulumu

1. https://www.postgresql.org/download/windows/ adresinden indirin
2. Kurulum sihirbazýnda:
   - Port: `5432` (varsayýlan)
   - Superuser þifresi: güçlü bir þifre belirleyin (örn: `CrmFilo2025!`)
   - Locale: `Turkish, Turkey` seçin
3. Stack Builder'ý atlayabilirsiniz

### 3. Veritabaný Oluþturma

```powershell
# PowerShell veya CMD'de:
psql -U postgres -h localhost

# SQL konsolunda:
CREATE DATABASE "CRMFiloServisDb" 
  ENCODING 'UTF8' 
  LC_COLLATE 'Turkish_Turkey.1254' 
  LC_CTYPE 'Turkish_Turkey.1254' 
  TEMPLATE template0;
\q
```

### 4. Uygulamayý Publish Etme

Geliþtirme PC'de proje kök dizininde:

```powershell
# Self-contained (hedef PC'de .NET kurulu olmasa da çalýþýr)
dotnet publish CRMFiloServis.Web\CRMFiloServis.Web.csproj `
    -c Release `
    -r win-x64 `
    --self-contained true `
    -o C:\CRMFiloServis

# VEYA Framework-dependent (daha küçük boyut, hedef PC'de .NET gerekir)
dotnet publish CRMFiloServis.Web\CRMFiloServis.Web.csproj `
    -c Release `
    -o C:\CRMFiloServis
```

### 5. Ayarlarý Yapýlandýrma

`C:\CRMFiloServis\appsettings.json` dosyasýný düzenleyin:

```json
{
  "DatabaseProvider": "PostgreSQL",
  "ConnectionStrings": {
    "PostgreSQL": "Host=localhost;Port=5432;Database=CRMFiloServisDb;Username=postgres;Password=SIFRENIZ;Pooling=true;MinPoolSize=1;MaxPoolSize=20;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Warning",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

> ?? `Password=SIFRENIZ` kýsmýný PostgreSQL kurulumunda belirlediðiniz þifreyle deðiþtirin!

### 6. Ýlk Çalýþtýrma (Test)

```powershell
cd C:\CRMFiloServis
.\CRMFiloServis.Web.exe --urls "http://0.0.0.0:5190"
```

Tarayýcýda `http://localhost:5190` açýn. Çalýþtýðýný doðrulayýn, Ctrl+C ile durdurun.

---

## Að Üzerinden Eriþim

### IP Adresini Öðrenme

```powershell
ipconfig | findstr "IPv4"
```

Örnek çýktý: `IPv4 Address. . . : 192.168.1.100`

### Firewall Kuralý Ekleme

```powershell
# Yönetici PowerShell'de:
netsh advfirewall firewall add rule name="CRM Filo Servis HTTP" dir=in action=allow protocol=tcp localport=5190
netsh advfirewall firewall add rule name="CRM Filo Servis HTTPS" dir=in action=allow protocol=tcp localport=7113
```

Veya `firewall-ac.bat` dosyasýný yönetici olarak çalýþtýrýn.

### Eriþim Testi

Ayný aðdaki baþka bir bilgisayardan:

```
http://192.168.1.100:5190
```

> **Not**: IP adresi DHCP ile deðiþebilir. Sabit IP atanmasý önerilir.

### Sabit IP Atama (Önerilen)

1. **Ayarlar** ? **Að ve Ýnternet** ? **Ethernet** ? **IP ayarlarýný düzenle**
2. Manuel seçin:
   - IP adresi: `192.168.1.100` (örnek)
   - Alt að maskesi: `255.255.255.0`
   - Varsayýlan að geçidi: `192.168.1.1`
   - DNS: `8.8.8.8`

---

## Windows Servisi

Uygulama kapanmadan arka planda sürekli çalýþsýn istiyorsanýz Windows Servisi olarak kaydedin.

### Servisi Oluþturma

```powershell
# Yönetici PowerShell'de:
sc.exe create CRMFiloServis `
    binPath="C:\CRMFiloServis\CRMFiloServis.Web.exe --urls http://0.0.0.0:5190" `
    start=auto `
    DisplayName="CRM Filo Servis"

sc.exe description CRMFiloServis "CRM Filo Servis - Web Uygulamasi"
```

### Servis Komutlarý

```powershell
# Baþlat
sc.exe start CRMFiloServis

# Durdur
sc.exe stop CRMFiloServis

# Durum
sc.exe query CRMFiloServis

# Kaldýr
sc.exe stop CRMFiloServis
sc.exe delete CRMFiloServis
```

### Otomatik Baþlatma

Servis `start=auto` ile oluþturulduðu için bilgisayar her açýldýðýnda otomatik baþlar.

---

## Veritabaný Yönetimi

### Yedekleme

#### Otomatik (Bat dosyasý ile)
```
yedekle.bat
```

Yedekler `C:\CRMFiloServis\Backups\` dizinine kaydedilir. 30 günden eski yedekler otomatik silinir.

#### Manuel
```powershell
$env:PGPASSWORD = "SIFRENIZ"
pg_dump -U postgres -h localhost -d CRMFiloServisDb -f "C:\CRMFiloServis\Backups\yedek_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql" --no-owner --no-privileges --if-exists --clean
```

#### Zamanlanmýþ Yedekleme (Günlük)

1. **Görev Zamanlayýcý** açýn (taskschd.msc)
2. **Görev Oluþtur**:
   - Ad: `CRM Filo Servis Yedekleme`
   - Tetikleyici: Her gün saat 02:00
   - Eylem: Program baþlat ? `C:\CRMFiloServis\yedekle.bat`
   - Ayarlar: "Kullanýcý oturum açmamýþ olsa bile çalýþtýr"

### Geri Yükleme

```
geri-yukle.bat
```

Veya manuel:

```powershell
$env:PGPASSWORD = "SIFRENIZ"
# Mevcut baðlantýlarý kes
psql -U postgres -h localhost -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'CRMFiloServisDb' AND pid <> pg_backend_pid();"
# Veritabanýný sil ve yeniden oluþtur
psql -U postgres -h localhost -c "DROP DATABASE IF EXISTS ""CRMFiloServisDb"";"
psql -U postgres -h localhost -c "CREATE DATABASE ""CRMFiloServisDb"" ENCODING 'UTF8' TEMPLATE template0;"
# Yedeði geri yükle
psql -U postgres -h localhost -d CRMFiloServisDb -f "C:\CRMFiloServis\Backups\yedek_dosyasi.sql"
```

### Mevcut Veritabanýný Yeni PC'ye Taþýma

1. **Kaynak PC'de** yedek alýn:
   ```
   yedekle.bat
   ```

2. Yedek dosyasýný (`C:\CRMFiloServis\Backups\*.sql`) hedef PC'ye kopyalayýn

3. **Hedef PC'de** geri yükleyin:
   ```
   geri-yukle.bat
   ```

---

## Sorun Giderme

### Uygulama Baþlamýyor

```powershell
# Loglarý kontrol edin
type C:\CRMFiloServis\Logs\*.log

# Doðrudan konsolda çalýþtýrýp hatayý görün
cd C:\CRMFiloServis
.\CRMFiloServis.Web.exe --urls "http://0.0.0.0:5190"
```

### Port Zaten Kullanýmda

```powershell
# 5190 portunu kim kullanýyor?
netstat -ano | findstr ":5190"

# Ýþlemi sonlandýr (PID'yi yukarýdan alýn)
taskkill /PID <PID> /F
```

### PostgreSQL Baðlantý Hatasý

```powershell
# PostgreSQL servisi çalýþýyor mu?
Get-Service postgresql*

# Servis durmuþsa baþlat
Start-Service postgresql-x64-16  # versiyon numarasýný ayarlayýn
```

### Diðer PC'lerden Eriþilemiyor

1. Firewall kurallarý eklendi mi? ? `firewall-ac.bat`
2. IP adresi doðru mu? ? `ipconfig`
3. Ayný aðda mýsýnýz? ? Hedef PC'den `ping SUNUCU_IP`
4. Antivirus engelliyor olabilir ? `CRMFiloServis.Web.exe` için istisna ekleyin

### Veritabaný Tablo Hatasý ("relation does not exist")

Uygulama ilk çalýþtýðýnda tablolarý otomatik oluþturur. Eðer hata alýyorsanýz:

```powershell
# Uygulamayý durdurun, tekrar baþlatýn
sc.exe stop CRMFiloServis
sc.exe start CRMFiloServis
```

---

## Dosya Yapýsý

```
KURULUM\
??? KURULUM-REHBERI.md          # Bu dosya
??? appsettings.Production.json # Üretim ortamý ayarlarý
??? kur.bat                     # Otomatik kurulum scripti
??? yayinla.bat                 # Publish (derleme) scripti
??? yedekle.bat                 # Veritabaný yedekleme
??? geri-yukle.bat              # Veritabaný geri yükleme
??? servis-yonet.bat            # Windows servis yönetimi
??? firewall-ac.bat             # Güvenlik duvarý port açma
??? publish\                    # (yayinla.bat çalýþtýrýnca oluþur)
    ??? CRMFiloServis.Web.exe
    ??? appsettings.json
    ??? wwwroot\
    ??? ...
```

## Hýzlý Baþlangýç Özeti

```
???????????????????????????????????????????????????
?  GELÝÞTÝRME PC'DE                              ?
?  1. yayinla.bat çalýþtýr                        ?
?  2. KURULUM klasörünü USB'ye kopyala            ?
???????????????????????????????????????????????????
?  HEDEF PC'DE                                    ?
?  1. .NET 10 Hosting Bundle kur                  ?
?  2. PostgreSQL kur                              ?
?  3. kur.bat çalýþtýr (Yönetici)                 ?
?  4. appsettings.json'da þifreyi düzenle         ?
?  5. firewall-ac.bat çalýþtýr (Yönetici)         ?
?  6. servis-yonet.bat ? Baþlat                   ?
?                                                 ?
?  Eriþim: http://SUNUCU_IP:5190                  ?
???????????????????????????????????????????????????
```
