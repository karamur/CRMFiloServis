# CRMFiloServis Publish Script
# Kullanım: .\publish.ps1 veya .\publish.ps1 -Proje [1|2|3|all]

param(
    [string]$Proje = ""
)

$Host.UI.RawUI.WindowTitle = "CRMFiloServis Publish"

# Veritabanı ayarları
$dbSettingsPath = "CRMFiloServis.Web\dbsettings.json"
$backupOutputDir = "publish\DatabaseBackup"

# Renk fonksiyonları
function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Success {
    param([string]$Text)
    Write-Host "[BASARILI] $Text" -ForegroundColor Green
}

function Write-Error {
    param([string]$Text)
    Write-Host "[HATA] $Text" -ForegroundColor Red
}

function Write-Info {
    param([string]$Text)
    Write-Host "[BILGI] $Text" -ForegroundColor Yellow
}

# Veritabanı yedeği alma fonksiyonu
function Backup-Database {
    Write-Info "Veritabani yedegi aliniyor..."

    if (-not (Test-Path $dbSettingsPath)) {
        Write-Error "dbsettings.json bulunamadi: $dbSettingsPath"
        return $false
    }

    # dbsettings.json oku
    $dbSettings = Get-Content $dbSettingsPath | ConvertFrom-Json
    $provider = $dbSettings.Provider
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

    # Backup klasörünü oluştur
    if (-not (Test-Path $backupOutputDir)) {
        New-Item -ItemType Directory -Path $backupOutputDir -Force | Out-Null
    }

    switch ($provider) {
        2 { # PostgreSQL
            $dbHost = $dbSettings.Host
            $dbPort = $dbSettings.Port
            $database = $dbSettings.DatabaseName
            $dbUser = $dbSettings.Username
            $dbPass = $dbSettings.Password
            $backupFile = "$backupOutputDir\${database}_PostgreSQL_$timestamp.sql"

            Write-Host "  Provider: PostgreSQL" -ForegroundColor Gray
            Write-Host "  Database: $database @ $dbHost" -ForegroundColor Gray

            # pg_dump ile yedek al
            $env:PGPASSWORD = $dbPass
            try {
                & pg_dump -h $dbHost -p $dbPort -U $dbUser -d $database -f $backupFile 2>&1 | Out-Null
                $exitCode = $LASTEXITCODE
            } finally {
                $env:PGPASSWORD = $null
            }

            if ($exitCode -eq 0 -and (Test-Path $backupFile)) {
                $fileSize = "{0:N2} KB" -f ((Get-Item $backupFile).Length / 1KB)
                Write-Success "PostgreSQL yedegi alindi: $backupFile ($fileSize)"
                return $true
            } else {
                Write-Error "PostgreSQL yedegi alinamadi! (Exit code: $exitCode)"
                return $false
            }
        }
        1 { # SQL Server
            $dbHost = $dbSettings.Host
            $database = $dbSettings.DatabaseName
            $backupFile = "$backupOutputDir\${database}_SQLServer_$timestamp.bak"

            Write-Host "  Provider: SQL Server" -ForegroundColor Gray
            Write-Host "  Database: $database @ $dbHost" -ForegroundColor Gray

            if ($dbSettings.UseIntegratedSecurity) {
                $connString = "Server=$dbHost;Database=$database;Integrated Security=True;TrustServerCertificate=True"
            } else {
                $dbUser = $dbSettings.Username
                $dbPass = $dbSettings.Password
                $connString = "Server=$dbHost;Database=$database;User Id=$dbUser;Password=$dbPass;TrustServerCertificate=True"
            }

            $backupQuery = "BACKUP DATABASE [$database] TO DISK = N'$((Resolve-Path $backupOutputDir).Path)\${database}_SQLServer_$timestamp.bak' WITH FORMAT, INIT, COMPRESSION"

            try {
                Invoke-Sqlcmd -ConnectionString $connString -Query $backupQuery -QueryTimeout 300
                if (Test-Path $backupFile) {
                    $fileSize = "{0:N2} MB" -f ((Get-Item $backupFile).Length / 1MB)
                    Write-Success "SQL Server yedegi alindi: $backupFile ($fileSize)"
                    return $true
                }
            } catch {
                Write-Error "SQL Server yedegi alinamadi: $_"
                return $false
            }
        }
        0 { # SQLite
            $sqliteDb = "CRMFiloServis.Web\CRMFiloServis.db"
            if (Test-Path $sqliteDb) {
                $backupFile = "$backupOutputDir\CRMFiloServis_SQLite_$timestamp.db"
                Copy-Item $sqliteDb $backupFile -Force
                $fileSize = "{0:N2} MB" -f ((Get-Item $backupFile).Length / 1MB)
                Write-Success "SQLite yedegi alindi: $backupFile ($fileSize)"
                return $true
            } else {
                Write-Error "SQLite veritabani bulunamadi: $sqliteDb"
                return $false
            }
        }
        default {
            Write-Error "Bilinmeyen veritabani provider: $provider"
            return $false
        }
    }

    return $false
}

# Proje tanımları
$projeler = @{
    "1" = @{
        Ad = "CRMFiloServis.Web"
        Yol = "CRMFiloServis.Web\CRMFiloServis.Web.csproj"
        CiktiKlasoru = "publish\Web"
        Aciklama = "Ana Web Uygulamasi (Blazor)"
        OzelParametreler = ""
    }
    "2" = @{
        Ad = "CRMFiloServis.LisansDesktop"
        Yol = "CRMFiloServis.LisansDesktop\CRMFiloServis.LisansDesktop.csproj"
        CiktiKlasoru = "publish\LisansDesktop"
        Aciklama = "Lisans Yonetim Desktop Uygulamasi"
        OzelParametreler = "-r win-x64 --self-contained true"
    }
    "3" = @{
        Ad = "CRMFiloServis.Installer"
        Yol = "CRMFiloServis.Installer\CRMFiloServis.Installer.csproj"
        CiktiKlasoru = "publish\Installer"
        Aciklama = "Kurulum Sihirbazi (Normal + Docker)"
        OzelParametreler = "-r win-x64 --self-contained true"
    }
}

function Show-Menu {
    Write-Header "CRMFiloServis Publish Araci"
    
    Write-Host "  Mevcut Projeler:" -ForegroundColor White
    Write-Host ""
    
    foreach ($key in $projeler.Keys | Sort-Object) {
        $proje = $projeler[$key]
        Write-Host "    [$key] " -ForegroundColor Yellow -NoNewline
        Write-Host "$($proje.Ad)" -ForegroundColor White -NoNewline
        Write-Host " - $($proje.Aciklama)" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "    [A] " -ForegroundColor Yellow -NoNewline
    Write-Host "Tum Projeleri Publish Et" -ForegroundColor White
    Write-Host "    [Q] " -ForegroundColor Yellow -NoNewline
    Write-Host "Cikis" -ForegroundColor White
    Write-Host ""
}

function Publish-Proje {
    param(
        [string]$ProjeKey
    )
    
    $proje = $projeler[$ProjeKey]
    
    if (-not $proje) {
        Write-Error "Gecersiz proje secimi: $ProjeKey"
        return $false
    }
    
    Write-Info "$($proje.Ad) publish ediliyor..."
    Write-Host "  Cikti klasoru: $($proje.CiktiKlasoru)" -ForegroundColor Gray
    
    # Çıktı klasörünü temizle
    if (Test-Path $proje.CiktiKlasoru) {
        Remove-Item -Path $proje.CiktiKlasoru -Recurse -Force
    }
    
    # Publish işlemi
    $publishArgs = "publish `"$($proje.Yol)`" -c Release -o `"$($proje.CiktiKlasoru)`""
    if ($proje.OzelParametreler) {
        $publishArgs += " $($proje.OzelParametreler)"
    }

    $publishResult = Invoke-Expression "dotnet $publishArgs" 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "$($proje.Ad) basariyla publish edildi!"
        
        # Dosya sayısını göster
        $dosyaSayisi = (Get-ChildItem -Path $proje.CiktiKlasoru -Recurse -File).Count
        $klasorBoyutu = "{0:N2} MB" -f ((Get-ChildItem -Path $proje.CiktiKlasoru -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB)
        Write-Host "  Dosya sayisi: $dosyaSayisi | Toplam boyut: $klasorBoyutu" -ForegroundColor Gray
        return $true
    } else {
        Write-Error "$($proje.Ad) publish edilirken hata olustu!"
        Write-Host $publishResult -ForegroundColor Red
        return $false
    }
}

function Publish-TumProjeler {
    Write-Header "Tum Projeler Publish Ediliyor"

    # Önce veritabanı yedeği al
    Write-Host ""
    $dbBackupResult = Backup-Database

    $basarili = 0
    $basarisiz = 0

    foreach ($key in $projeler.Keys | Sort-Object) {
        Write-Host ""
        if (Publish-Proje -ProjeKey $key) {
            $basarili++
        } else {
            $basarisiz++
        }
    }

    Write-Host ""
    Write-Header "Publish Ozeti"
    Write-Host "  Projeler Basarili: $basarili" -ForegroundColor Green
    Write-Host "  Projeler Basarisiz: $basarisiz" -ForegroundColor $(if ($basarisiz -gt 0) { "Red" } else { "Gray" })
    Write-Host "  Veritabani Yedegi: $(if ($dbBackupResult) { 'Alindi' } else { 'Alinamadi' })" -ForegroundColor $(if ($dbBackupResult) { "Green" } else { "Yellow" })

    # Publish klasör özeti
    Write-Host ""
    Write-Host "  Cikti Klasorleri:" -ForegroundColor White
    Get-ChildItem -Path publish -Directory | Where-Object { $_.Name -in @('Web', 'LisansDesktop', 'Installer', 'DatabaseBackup') } | ForEach-Object {
        $dir = $_
        $count = (Get-ChildItem -Path $_.FullName -Recurse -File -ErrorAction SilentlyContinue).Count
        $size = "{0:N2} MB" -f ((Get-ChildItem -Path $_.FullName -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB)
        Write-Host "    - $($dir.Name): $count dosya, $size" -ForegroundColor Gray
    }
}

# Ana çalışma
if ($Proje -ne "") {
    # Parametre ile çalıştırma
    if ($Proje -eq "all" -or $Proje -eq "A" -or $Proje -eq "a") {
        Publish-TumProjeler
    } elseif ($projeler.ContainsKey($Proje)) {
        Publish-Proje -ProjeKey $Proje
    } else {
        Write-Error "Gecersiz proje numarasi: $Proje"
        Write-Host "Kullanim: .\publish.ps1 -Proje [1|2|3|all]" -ForegroundColor Yellow
    }
} else {
    # İnteraktif mod
    do {
        Show-Menu
        $secim = Read-Host "Seciminiz"
        
        switch ($secim.ToUpper()) {
            "1" { Publish-Proje -ProjeKey "1"; Read-Host "Devam etmek icin Enter'a basin" }
            "2" { Publish-Proje -ProjeKey "2"; Read-Host "Devam etmek icin Enter'a basin" }
            "3" { Publish-Proje -ProjeKey "3"; Read-Host "Devam etmek icin Enter'a basin" }
            "A" { Publish-TumProjeler; Read-Host "Devam etmek icin Enter'a basin" }
            "Q" { Write-Host "Cikis yapiliyor..." -ForegroundColor Gray; break }
            default { Write-Error "Gecersiz secim! Lutfen 1, 2, 3, A veya Q girin." }
        }
        
        Clear-Host
    } while ($secim.ToUpper() -ne "Q")
}

Write-Host ""
