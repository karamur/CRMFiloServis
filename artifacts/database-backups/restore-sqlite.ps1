<#
.SYNOPSIS
    KOA Filo Servis - SQLite Geri Yükleme Script'i

.PARAMETER BackupFile
    Yedek dosyası (.db.bak veya .sql.gz)

.PARAMETER DbPath
    Hedef veritabanı yolu

.EXAMPLE
    .\restore-sqlite.ps1 -BackupFile ".\backups\sqlite_koafilo_20241201.db.bak" -DbPath "C:\KOAFiloServis\data\koafilo.db"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$BackupFile,
    [Parameter(Mandatory=$true)]
    [string]$DbPath
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║      KOA Filo Servis - SQLite Geri Yükleme                ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $BackupFile)) {
    Write-Host "✗ Yedek dosyası bulunamadı: $BackupFile" -ForegroundColor Red
    exit 1
}

Write-Host "  Yedek: $BackupFile" -ForegroundColor Gray
Write-Host "  Hedef: $DbPath" -ForegroundColor Gray
Write-Host ""

$confirm = Read-Host "⚠ Mevcut veritabanının üzerine yazılacak. Devam? (E/H)"
if ($confirm -ne "E") {
    Write-Host "İptal edildi." -ForegroundColor Yellow
    exit 0
}

try {
    # Hedef dizini oluştur
    $targetDir = Split-Path $DbPath -Parent
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    
    # Dosya türüne göre geri yükle
    if ($BackupFile -match "\.db\.bak$") {
        # Binary geri yükleme
        Write-Host "▶ Binary geri yükleme..." -ForegroundColor Blue
        Copy-Item $BackupFile $DbPath -Force
        
        # WAL dosyaları
        $walBackup = "${BackupFile}-wal"
        $shmBackup = "${BackupFile}-shm"
        if (Test-Path $walBackup) { Copy-Item $walBackup "${DbPath}-wal" -Force }
        if (Test-Path $shmBackup) { Copy-Item $shmBackup "${DbPath}-shm" -Force }
    }
    elseif ($BackupFile -match "\.sql\.gz$") {
        # SQL dump geri yükleme
        Write-Host "▶ SQL dump geri yükleme..." -ForegroundColor Blue
        
        $sqlite3 = Get-Command sqlite3 -ErrorAction SilentlyContinue
        if (-not $sqlite3) {
            Write-Host "✗ sqlite3 CLI gerekli!" -ForegroundColor Red
            exit 1
        }
        
        # Mevcut db'yi sil
        if (Test-Path $DbPath) { Remove-Item $DbPath -Force }
        
        # Sıkıştırmayı aç
        $compressedBytes = [System.IO.File]::ReadAllBytes($BackupFile)
        $ms = New-Object System.IO.MemoryStream($compressedBytes, 0, $compressedBytes.Length)
        $gzip = New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionMode]::Decompress)
        $reader = New-Object System.IO.StreamReader($gzip)
        $sql = $reader.ReadToEnd()
        $reader.Close()
        
        $tempSql = [System.IO.Path]::GetTempFileName()
        [System.IO.File]::WriteAllText($tempSql, $sql)
        
        & sqlite3 $DbPath ".read '$tempSql'"
        Remove-Item $tempSql -Force
    }
    else {
        Write-Host "✗ Desteklenmeyen yedek formatı" -ForegroundColor Red
        exit 1
    }
    
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
