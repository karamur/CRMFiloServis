<#
.SYNOPSIS
    KOA Filo Servis - PostgreSQL Yedekleme Script'i

.DESCRIPTION
    PostgreSQL veritabanının tam yedeğini alır (pg_dump + gzip)

.PARAMETER Host
    PostgreSQL sunucu adresi (varsayılan: localhost)

.PARAMETER Port
    PostgreSQL port numarası (varsayılan: 5432)

.PARAMETER Database
    Veritabanı adı (varsayılan: koafilo)

.PARAMETER User
    Kullanıcı adı (varsayılan: postgres)

.PARAMETER Password
    Şifre (opsiyonel, interaktif sorulur)

.PARAMETER OutputDir
    Yedekleme dizini (varsayılan: .\backups)

.PARAMETER Retention
    Kaç günlük yedek tutulsun (varsayılan: 30)

.EXAMPLE
    .\backup-postgresql.ps1 -Host localhost -Database koafilo -User postgres
#>

param(
    [string]$Host = "localhost",
    [int]$Port = 5432,
    [string]$Database = "koafilo",
    [string]$User = "postgres",
    [string]$Password = "",
    [string]$OutputDir = ".\backups",
    [int]$Retention = 30
)

$ErrorActionPreference = "Stop"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupFile = Join-Path $OutputDir "postgresql_${Database}_${Timestamp}.sql"
$CompressedFile = "${BackupFile}.gz"

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║      KOA Filo Servis - PostgreSQL Yedekleme               ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Dizin oluştur
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    Write-Host "✓ Yedekleme dizini oluşturuldu: $OutputDir" -ForegroundColor Green
}

# pg_dump kontrolü
$pgDump = Get-Command pg_dump -ErrorAction SilentlyContinue
if (-not $pgDump) {
    # Yaygın kurulum yollarını kontrol et
    $pgPaths = @(
        "C:\Program Files\PostgreSQL\16\bin\pg_dump.exe",
        "C:\Program Files\PostgreSQL\15\bin\pg_dump.exe",
        "C:\Program Files\PostgreSQL\14\bin\pg_dump.exe"
    )
    foreach ($path in $pgPaths) {
        if (Test-Path $path) {
            $pgDump = $path
            break
        }
    }
}

if (-not $pgDump) {
    Write-Host "✗ pg_dump bulunamadı! PostgreSQL istemci araçlarını yükleyin." -ForegroundColor Red
    exit 1
}

# Şifre sorma
if ([string]::IsNullOrEmpty($Password)) {
    $SecurePassword = Read-Host "PostgreSQL şifresi" -AsSecureString
    $Password = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
    )
}

# Ortam değişkeni ile şifre
$env:PGPASSWORD = $Password

Write-Host "▶ Yedekleme başlıyor..." -ForegroundColor Blue
Write-Host "  Sunucu: ${Host}:${Port}" -ForegroundColor Gray
Write-Host "  Veritabanı: $Database" -ForegroundColor Gray

try {
    # pg_dump çalıştır
    $pgDumpArgs = @(
        "-h", $Host,
        "-p", $Port,
        "-U", $User,
        "-d", $Database,
        "-F", "p",           # Plain SQL format
        "-b",                # Blob'ları dahil et
        "--no-owner",        # Owner bilgilerini dahil etme
        "--no-privileges",   # Yetki bilgilerini dahil etme
        "-f", $BackupFile
    )
    
    & $pgDump @pgDumpArgs
    
    if ($LASTEXITCODE -ne 0) {
        throw "pg_dump başarısız oldu (Exit code: $LASTEXITCODE)"
    }
    
    Write-Host "✓ SQL dump oluşturuldu" -ForegroundColor Green
    
    # Sıkıştır
    Write-Host "▶ Sıkıştırılıyor..." -ForegroundColor Blue
    
    $content = [System.IO.File]::ReadAllBytes($BackupFile)
    $ms = New-Object System.IO.MemoryStream
    $gzip = New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionMode]::Compress)
    $gzip.Write($content, 0, $content.Length)
    $gzip.Close()
    [System.IO.File]::WriteAllBytes($CompressedFile, $ms.ToArray())
    $ms.Close()
    
    # Orijinal SQL dosyasını sil
    Remove-Item $BackupFile -Force
    
    $fileSize = (Get-Item $CompressedFile).Length / 1MB
    Write-Host "✓ Sıkıştırma tamamlandı: $([math]::Round($fileSize, 2)) MB" -ForegroundColor Green
    
    # Eski yedekleri temizle
    Write-Host "▶ Eski yedekler temizleniyor ($Retention gün öncesi)..." -ForegroundColor Blue
    $cutoffDate = (Get-Date).AddDays(-$Retention)
    $oldBackups = Get-ChildItem $OutputDir -Filter "postgresql_*.sql.gz" | 
                  Where-Object { $_.LastWriteTime -lt $cutoffDate }
    
    if ($oldBackups.Count -gt 0) {
        $oldBackups | Remove-Item -Force
        Write-Host "✓ $($oldBackups.Count) eski yedek silindi" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "              YEDEKLEME TAMAMLANDI!" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Dosya: $CompressedFile" -ForegroundColor White
    Write-Host "  Boyut: $([math]::Round($fileSize, 2)) MB" -ForegroundColor White
    Write-Host ""
    Write-Host "  Geri yükleme:" -ForegroundColor Yellow
    Write-Host "  gunzip -c `"$CompressedFile`" | psql -U $User -d $Database" -ForegroundColor Gray
    Write-Host ""
}
catch {
    Write-Host "✗ Hata: $_" -ForegroundColor Red
    exit 1
}
finally {
    $env:PGPASSWORD = ""
}
