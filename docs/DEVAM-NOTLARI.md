# KOAFiloServis — Çalışma Notları (Devam Noktası)

> Son güncelleme: **v1.0.3 paketi üretildi** — Dosya şifreleme (AES-256-GCM + DPAPI) tamamlandı, migration aracı eklendi.
> Sonraki oturumda: kurulum doğrulama + migration çalıştırma + sonraki sprint. — IIS otomasyonu sertleştirildi, Hosting Bundle zorunlu.
> Sonraki oturumda test PC'de doğrulama + GitHub Release.

---

## 🆕 v1.0.2 — BU OTURUMDA TAMAMLANDI

### IIS Sorununu Kalıcı Çözüm
- **`setup/Setup.iss`** — `[Code]` bloğuna `InitializeSetup` eklendi:
  - IIS kurulu mu? (registry `HKLM:\SOFTWARE\Microsoft\InetStp` + `iiscore.dll`)
  - ASP.NET Core Module V2 var mı? (registry 2 path + `aspnetcorev2.dll`)
  - .NET 10 ASP.NET Core Runtime var mı? (`SOFTWARE\dotnet\Setup\InstalledVersions\...`)
  - Herhangi biri eksikse → **MsgBox + kurulum iptal** (dosyalar açılmadan önce!)
  - [Run] bölümündeki eski preinstall-check çağrısı kaldırıldı (artık gereksiz).
- **`setup/scripts/preinstall-check.ps1`** — runtime tanı aracı olarak tutuldu (exit 1 dönüyor, ileride manuel diagnostik için).
- **`setup/scripts/iis-configure.ps1`** zenginleştirildi:
  - `Test-PortFree` + `Find-FreePort` — 5190 dolu ise 5190..5194 dener
  - `iisreset /noforce` — AspNetCoreModule cache yenileme
  - `Test-Site` smoke test — `Invoke-WebRequest http://localhost:port` (20sn timeout)
  - Smoke test fail ise `stdout*.log` son 30 satırı console'a basılır
  - Site update senaryosunda eski HTTP binding'leri temizlenir
  - `enable32BitAppOnWin64=false`, `startMode=AlwaysRunning`, `autoStart=true`
  - `{app}\active-port.txt` — kullanılan port diske yazılıyor
- **`setup/build.ps1`** — Web publish sonrası `web.config` patch:
  - `stdoutLogEnabled="false"` → `"true"` (IIS sorunlarını tanımak için)

### Üretilen Paket
- **`D:\calisma\Claude-Code\KOAFiloServis\setup\output\KOAFiloServisKurulum-1.0.2.exe`** (147.21 MB)
- `F:\publish` bağlı değildi → CopyToPublish atlandı. Dış USB takılınca tekrar `-CopyToPublish` ile çalıştırılabilir.

---

## ✅ TAMAMLANDI (önceki sprintler)

### Kurulum Altyapısı (Inno Setup tabanlı)
- **Inno Setup 6.7.1** kuruldu (`C:\Users\muratk\AppData\Local\Programs\Inno Setup 6\ISCC.exe`)
- `setup/Setup.iss` — Inno Setup ana script
  - Port: **5190** (80 çakışıyordu)
  - Kısayol adı: **"Veri Aktarim (PG - SQLite)"** (`>` yasak karakter sorunu çözüldü)
  - Bileşenler: web (zorunlu), lisans, datasync
  - Korunan dosyalar (güncellemede): `dbsettings.json`, `data\*.db`, `uploads\`, `logs\`, `Backups\`
- `setup/scripts/iis-configure.ps1` — IIS site + AppPool + ACL + smoke test (v1.0.2'de zenginleştirildi)
- `setup/scripts/iis-remove.ps1` — uninstall IIS temizliği
- `setup/scripts/preinstall-check.ps1` — manuel diagnostik aracı
- `setup/build.ps1` — tek komut pipeline (Web+Lisans+DataSync publish + web.config patch + ISCC + opsiyonel F:\publish kopya)
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

## ✅ ÇÖZÜLDÜ: IIS Site Açılmıyordu (v1.0.1 → v1.0.2)

**Belirti (v1.0.1):** Test PC'de sorunsuz kuruldu ama `http://localhost:5190` IIS üzerinden açılmadı.
**Kök neden:** ASP.NET Core 10 Hosting Bundle yüklü değildi (muhtemelen); `web.config` `hostingModel="inprocess"` + `AspNetCoreModuleV2` olmadan IIS modülü yüklenmiyor.

**v1.0.2'de alınan önlemler:**
1. Kurulum **başlamadan önce** Hosting Bundle / IIS / .NET 10 Runtime kontrolü (`InitializeSetup`) — eksikse MsgBox + abort.
2. Smoke test: Kurulumdan sonra `http://localhost:<port>` otomatik çağrılır; fail olursa `stdout*.log` console'a basılır.
3. `stdoutLogEnabled="true"` — tanı kolaylığı.
4. `iisreset /noforce` — Hosting Bundle yeni yüklendiyse modül cache yenilenir.
5. Port 5190 dolu ise 5191..5194 arasından otomatik alternatif seçer, `{app}\active-port.txt`'ye yazar.

**Tanı komutları (hala faydalı):**
```powershell
# Hosting Bundle
Test-Path "HKLM:\SOFTWARE\Microsoft\IIS Extensions\IIS AspNetCore Module V2"

# stdout log (en kritik)
Get-Content C:\KOAFiloServis\logs\stdout*.log -Tail 50

# Kullanılan port
Get-Content C:\KOAFiloServis\active-port.txt
```

---

## 🔜 SONRAKI ADIMLAR

### 1) v1.0.2 Test PC Doğrulaması (öncelik)
- [ ] Test PC'de Hosting Bundle **yokken** kurulumu başlat → MsgBox ile durması gerekir ✓
- [ ] Hosting Bundle kurulu iken tekrar kur → `http://localhost:5190` Blazor açılmalı ✓
- [ ] Smoke test log'larına bak (kurulum sırasında görünüyor)
- [ ] `C:\KOAFiloServis\active-port.txt` dosyasının doğru porta işaret ettiğini doğrula
- [ ] `C:\KOAFiloServis\logs\stdout*.log` sorunsuz çalışıyorsa boş/kısa olmalı

### 2) GitHub Release v1.0.2
```powershell
# Önce F: takılıyken paketi kopyalamak gerekirse:
cd D:\calisma\Claude-Code\KOAFiloServis\setup
.\build.ps1 -Version 1.0.2 -SkipPublish -CopyToPublish

# Release oluştur
gh release create v1.0.2 `
    "D:\calisma\Claude-Code\KOAFiloServis\setup\output\KOAFiloServisKurulum-1.0.2.exe" `
    --title "v1.0.2 - IIS otomasyonu sertlestirildi" `
    --notes "Hosting Bundle / IIS / .NET 10 on-kontrolu (InitializeSetup), port cakismasi fallback (5190->5194), smoke test, iisreset, stdout log acik."
```

### 3) Git Commit + Push (bu oturum sonu)
```powershell
cd D:\calisma\Claude-Code\KOAFiloServis
git add setup/Setup.iss setup/build.ps1 setup/scripts/*.ps1 docs/DEVAM-NOTLARI.md
git commit -m "v1.0.2: IIS kurulum otomasyonu sertlestirildi (Hosting Bundle zorunlu, port fallback, smoke test)"
git push origin main
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
