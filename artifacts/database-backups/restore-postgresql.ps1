<#
.SYNOPSIS
    KOA Filo Servis - PostgreSQL Geri Yükleme Script'i

.PARAMETER BackupFile
    Yedek dosyası yolu (.sql.gz)

.PARAMETER Host
    PostgreSQL sunucu adresi

.PARAMETER Database
    Veritabanı adı

.PARAMETER User
    Kullanıcı adı

.PARAMETER DropExisting
    Mevcut veritabanını sil ve yeniden oluştur

.EXAMPLE
    .\restore-postgresql.ps1 -BackupFile ".\backups\postgresql_koafilo_20241201_120000.sql.gz" -Host localhost -Database koafilo -User postgres
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$BackupFile,
    [string]$Host = "localhost",
    [int]$Port = 5432,
    [string]$Database = "koafilo",
    [string]$User = "postgres",
    [string]$Password = "",
    [switch]$DropExisting
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║    KOA Filo Servis - PostgreSQL Geri Yükleme              ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $BackupFile)) {
    Write-Host "✗ Yedek dosyası bulunamadı: $BackupFile" -ForegroundColor Red
    exit 1
}

# psql kontrolü
$psql = Get-Command psql -ErrorAction SilentlyContinue
if (-not $psql) {
    $pgPaths = @(
        "C:\Program Files\PostgreSQL\16\bin\psql.exe",
        "C:\Program Files\PostgreSQL\15\bin\psql.exe"
    )
    foreach ($path in $pgPaths) {
        if (Test-Path $path) { $psql = $path; break }
    }
}

if (-not $psql) {
    Write-Host "✗ psql bulunamadı!" -ForegroundColor Red
    exit 1
}

# Şifre
if ([string]::IsNullOrEmpty($Password)) {
    $SecurePassword = Read-Host "PostgreSQL şifresi" -AsSecureString
    $Password = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
    )
}
$env:PGPASSWORD = $Password

Write-Host "▶ Yedek dosyası: $BackupFile" -ForegroundColor Blue
Write-Host "  Hedef: ${Host}:${Port}/$Database" -ForegroundColor Gray

try {
    # Veritabanını yeniden oluştur
    if ($DropExisting) {
        Write-Host "▶ Mevcut veritabanı siliniyor..." -ForegroundColor Yellow
        & $psql -h $Host -p $Port -U $User -d postgres -c "DROP DATABASE IF EXISTS $Database;"
        & $psql -h $Host -p $Port -U $User -d postgres -c "CREATE DATABASE $Database;"
        Write-Host "✓ Veritabanı yeniden oluşturuldu" -ForegroundColor Green
    }
    
    # Sıkıştırmayı aç ve geri yükle
    Write-Host "▶ Geri yükleme başlıyor..." -ForegroundColor Blue
    
    $compressedBytes = [System.IO.File]::ReadAllBytes($BackupFile)
    $ms = New-Object System.IO.MemoryStream($compressedBytes, 0, $compressedBytes.Length)
    $gzip = New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionMode]::Decompress)
    $reader = New-Object System.IO.StreamReader($gzip)
    $sql = $reader.ReadToEnd()
    $reader.Close()
    $gzip.Close()
    $ms.Close()
    
    $tempSql = [System.IO.Path]::GetTempFileName()
    [System.IO.File]::WriteAllText($tempSql, $sql)
    
    & $psql -h $Host -p $Port -U $User -d $Database -f $tempSql
    
    Remove-Item $tempSql -Force
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "            GERİ YÜKLEME TAMAMLANDI!" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
}
catch {
    Write-Host "✗ Hata: $_" -ForegroundColor Red
    exit 1
}
finally {
    $env:PGPASSWORD = ""
}
