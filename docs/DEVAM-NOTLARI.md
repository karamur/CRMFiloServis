# KOAFiloServis — Çalışma Notları (Devam Noktası)

> Son güncelleme: v1.0.1 paketi test edildi, IIS sorunu kaldı.
> Sonraki oturumda buradan devam edilecek.

---

## ✅ TAMAMLANDI

### Kurulum Altyapısı (yeni Inno Setup tabanlı)
- **Inno Setup 6.7.1** kuruldu (`C:\Users\muratk\AppData\Local\Programs\Inno Setup 6\ISCC.exe`)
- `setup/Setup.iss` — Inno Setup ana script
  - Port: **5190** (80 çakışıyordu)
  - Kısayol adı: **"Veri Aktarim (PG - SQLite)"** (`>` yasak karakter sorunu çözüldü)
  - Bileşenler: web (zorunlu), lisans, datasync
  - Korunan dosyalar (güncellemede): `dbsettings.json`, `data\*.db`, `uploads\`, `logs\`, `Backups\`
- `setup/scripts/iis-configure.ps1` — IIS site + AppPool + ACL (idempotent)
- `setup/scripts/iis-remove.ps1` — uninstall IIS temizliği
- `setup/scripts/preinstall-check.ps1` — IIS + Hosting Bundle kontrolü (sadece uyarı, engellemez)
- `setup/build.ps1` — tek komut pipeline (Web+Lisans+DataSync publish + ISCC + opsiyonel F:\publish kopya)
- `setup/README.md` — kullanım kılavuzu

### KOAFiloServis.DataSync Projesi
- `KOAFiloServis.DataSync/KOAFiloServis.DataSync.csproj` — net10.0-windows, WinExe
- `Program.cs` — STAThread, args varsa CLI yoksa UI
- `CliRunner.cs` — `export --pg "..." --sqlite "..."` komutu
- `Exporters/PostgresToSqliteExporter.cs` — raw SQL, sqlite_master + information_schema kesişimi, FK off + DELETE + batch INSERT
- `UI/MainForm.cs` — WinForms 780x640 (Host/Port/DB/User/Pass + Test/Start + Marquee + log)
- `app.manifest` — UAC asInvoker + DPI aware

### Database Migration
- `KOAFiloServis.Web/Data/Migrations/FaturaGibDurumMigrationHelper.cs` genişletildi
- 15 kolon idempotent (hem SQLite hem PG): `EslesenFaturaId`, `MahsupKapatildi`, `MahsupTarihi`, `FirmalarArasiFatura`, `KarsiFirmaId`, `MuhasebeFisId`, `MuhasebeFisiOlusturuldu`, `Tevkifat*`

### GitHub
- README.md güncellendi: Tek paket installer, modül modül bileşenler, lisans yönetimi, yedekleme & geri yükleme bölümleri
- `.gitignore`: `setup/payload/`, `setup/output/`, `archive/`, `setup-build.log`
- **Commit:** `cafe374` (push edildi: github.com/karamur/KOAFiloServis main)
- Eski projeler arşive taşındı: `archive/KOAFiloServis.Installer/`, `archive/Deploy-IIS-sfx/`, `archive/scripts-paketle/`

### Üretilmiş Paket
- **`F:\publish\Installer\KOAFiloServisKurulum-1.0.1.exe`** (147 MB)
- `setup/output/KOAFiloServisKurulum-1.0.1.exe` (kaynak)
- Test PC'de **kuruldu**, Başlat menüsü çalıştı

### Dokümantasyon
- `F:\publish\kurulum-sirasi.txt` yeni Inno Setup akışına göre güncellendi

---

## ⚠️ AÇIK SORUN (sonraki oturum başlangıcı)

### IIS Site 5190'da Açılmıyor
**Belirti:** Test PC'de v1.0.1 sorunsuz kuruldu. Ama `http://localhost:5190` IIS üzerinden açılmadı.
**Workaround:** `C:\KOAFiloServis\KOAFiloServis.Web.exe` doğrudan çalıştırılınca uygulama çalışıyor (Kestrel tek başına OK).

**Olası sebepler (öncelik sırası):**
1. **(EN OLASI) ASP.NET Core 10 Hosting Bundle yüklü değil** — `web.config` `hostingModel="inprocess"` + `AspNetCoreModuleV2` kullanıyor; Hosting Bundle olmadan IIS modülü yüklenmez.
2. AppPool **"No Managed Code"** ayarı düşmüş olabilir — `iis-configure.ps1` ayarlıyor ama doğrulanmalı.
3. AppPool kimliği (`IIS AppPool\KOAFiloServis`) `C:\KOAFiloServis` üzerinde okuma izni alamamış olabilir.
4. Port 5190 başka bir process tarafından dinleniyor olabilir.

**Test PC'de tanı komutları (yönetici PowerShell):**
```powershell
# 1) Hosting Bundle kontrolü
Test-Path "HKLM:\SOFTWARE\Microsoft\IIS Extensions\IIS AspNetCore Module V2"
Get-ChildItem "HKLM:\SOFTWARE\Microsoft\IIS Extensions\IIS AspNetCore Module V2\Handlers" -ErrorAction SilentlyContinue

# 2) AppPool durumu
Import-Module WebAdministration
Get-Item "IIS:\AppPools\KOAFiloServis" | Select name, state, managedRuntimeVersion, @{n='Identity';e={$_.processModel.identityType}}

# 3) Site bindings ve durum
Get-Website -Name KOAFiloServis | Select Name, State, PhysicalPath, @{n='Bindings';e={($_.Bindings.Collection -join '|')}}

# 4) Port dolu mu?
Get-NetTCPConnection -LocalPort 5190 -ErrorAction SilentlyContinue | Select LocalAddress, State, OwningProcess

# 5) ACL — IIS AppPool\KOAFiloServis Modify hakkı var mı?
(Get-Acl C:\KOAFiloServis).Access | Where-Object { $_.IdentityReference -like "*KOAFiloServis*" }

# 6) IIS log + stdout log (en kritik!)
Get-Content C:\KOAFiloServis\logs\stdout*.log -Tail 50 -ErrorAction SilentlyContinue
Get-WinEvent -LogName Application -MaxEvents 20 | Where-Object { $_.ProviderName -like "*IIS*" -or $_.ProviderName -like "*ASP.NET*" } | Format-List TimeCreated, Message
```

**Hızlı çözüm:** Hosting Bundle indir+kur → `iisreset` → tekrar dene:
- https://dotnet.microsoft.com/download/dotnet/10.0 → "Hosting Bundle"

---

## 🔜 SONRAKI ADIMLAR (öncelik sırası)

### v1.0.2 — IIS Sorununu Kalıcı Çöz
1. **`setup/scripts/preinstall-check.ps1` sertleştir:**
   - Hosting Bundle yoksa **`exit 1`** dön (kurulumu durdur)
   - Setup.iss'te `[Run]` adımına `Check: NeedsHostingBundle` koşulu ekle
2. **`setup/scripts/iis-configure.ps1` zenginleştir:**
   - `iisreset` çağır (modül kayıt için)
   - Port 5190 dolu mu kontrol → doluysa 5191/5192 dene
   - Kurulum sonunda `Invoke-WebRequest http://localhost:5190 -UseBasicParsing -TimeoutSec 10` smoke test
3. **stdout log'u aç** (web.config içinde `stdoutLogEnabled="true"`) — sorunlar görünür olsun
4. Yeni paket: `setup\build.ps1 -Version 1.0.2 -CopyToPublish`

### Sonra — GitHub Release
```powershell
gh release create v1.0.2 `
    "F:\publish\Installer\KOAFiloServisKurulum-1.0.2.exe" `
    --title "v1.0.2 - IIS otomasyonu sertleştirildi" `
    --notes "Hosting Bundle zorunlu, port çakışması tespit, smoke test."
```

### Daha Sonra (bağımsız sprint)
- **PDF şifreleme:** Yedek PDF ekleri için AES-256-GCM + DPAPI master.key
- **Watermark + audit log** (opsiyonel)
- `docs/BASITLESTIRME_VE_OTOMASYON_ONERILERI.md` madde 2.7: yedek sağlığı build pipeline'a entegrasyon

---

## 📂 ÖNEMLİ DOSYA YOLLARI

| Amaç | Yol |
|---|---|
| Inno Setup script | `setup/Setup.iss` |
| Build pipeline | `setup/build.ps1` |
| IIS otomasyon | `setup/scripts/iis-configure.ps1` |
| Hosting Bundle kontrol | `setup/scripts/preinstall-check.ps1` |
| DataSync exporter | `KOAFiloServis.DataSync/Exporters/PostgresToSqliteExporter.cs` |
| Web web.config (publish) | `setup/payload/Web/web.config` |
| Migration helper | `KOAFiloServis.Web/Data/Migrations/FaturaGibDurumMigrationHelper.cs` |
| Son üretilen paket | `F:/publish/Installer/KOAFiloServisKurulum-1.0.1.exe` |
| Kurulum kılavuzu | `F:/publish/kurulum-sirasi.txt` |

---

## 🔧 ÇEVRE BİLGİSİ

- **Geliştirme PC:** `D:\calisma\Claude-Code\KOAFiloServis`
- **Hedef PC kurulum:** `C:\KOAFiloServis` (sabit, `DisableDirPage=yes`)
- **HTTP port:** 5190 (80 doluydu)
- **IDE:** Visual Studio Enterprise 2026 (18.5.0)
- **Shell:** pwsh.exe
- **Git:** github.com/karamur/KOAFiloServis (main, son commit `cafe374`)
- **.NET:** 10.0
- **Inno Setup:** 6.7.1
