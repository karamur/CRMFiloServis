<#
.SYNOPSIS
    KOA Filo Servis - SQLite Yedekleme Script'i

.DESCRIPTION
    SQLite veritabanının tam yedeğini alır (binary copy + SQL dump)

.PARAMETER DbPath
    SQLite veritabanı dosya yolu

.PARAMETER OutputDir
    Yedekleme dizini (varsayılan: .\backups)

.PARAMETER Retention
    Kaç günlük yedek tutulsun (varsayılan: 30)

.PARAMETER IncludeSqlDump
    SQL dump'ı da oluştur (varsayılan: true)

.EXAMPLE
    .\backup-sqlite.ps1 -DbPath "C:\KOAFiloServis\data\koafilo.db"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$DbPath,
    [string]$OutputDir = ".\backups",
    [int]$Retention = 30,
    [bool]$IncludeSqlDump = $true
)

$ErrorActionPreference = "Stop"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$DbName = [System.IO.Path]::GetFileNameWithoutExtension($DbPath)
$BackupBinary = Join-Path $OutputDir "sqlite_${DbName}_${Timestamp}.db.bak"
$BackupSql = Join-Path $OutputDir "sqlite_${DbName}_${Timestamp}.sql"

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║        KOA Filo Servis - SQLite Yedekleme                 ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Veritabanı kontrolü
if (-not (Test-Path $DbPath)) {
    Write-Host "✗ Veritabanı bulunamadı: $DbPath" -ForegroundColor Red
    exit 1
}

# Dizin oluştur
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    Write-Host "✓ Yedekleme dizini oluşturuldu: $OutputDir" -ForegroundColor Green
}

Write-Host "▶ Yedekleme başlıyor..." -ForegroundColor Blue
Write-Host "  Veritabanı: $DbPath" -ForegroundColor Gray

try {
    # Binary kopyası (WAL modu için güvenli)
    Write-Host "▶ Binary yedek oluşturuluyor..." -ForegroundColor Blue
    
    # SQLite'ın .backup komutu en güvenli yöntemdir
    $sqlite3 = Get-Command sqlite3 -ErrorAction SilentlyContinue
    
    if ($sqlite3) {
        # sqlite3 CLI ile yedekle
        & sqlite3 $DbPath ".backup '$BackupBinary'"
    }
    else {
        # sqlite3 yoksa dosya kopyası (WAL modunda riskli olabilir)
        Write-Host "  ⚠ sqlite3 CLI bulunamadı, dosya kopyası yapılıyor" -ForegroundColor Yellow
        Copy-Item $DbPath $BackupBinary -Force
        
        # WAL ve SHM dosyaları varsa onları da kopyala
        $walFile = "${DbPath}-wal"
        $shmFile = "${DbPath}-shm"
        if (Test-Path $walFile) {
            Copy-Item $walFile "${BackupBinary}-wal" -Force
        }
        if (Test-Path $shmFile) {
            Copy-Item $shmFile "${BackupBinary}-shm" -Force
        }
    }
    
    $binarySize = (Get-Item $BackupBinary).Length / 1MB
    Write-Host "✓ Binary yedek: $([math]::Round($binarySize, 2)) MB" -ForegroundColor Green
    
    # SQL dump
    if ($IncludeSqlDump -and $sqlite3) {
        Write-Host "▶ SQL dump oluşturuluyor..." -ForegroundColor Blue
        & sqlite3 $DbPath ".dump" | Out-File $BackupSql -Encoding UTF8
        
        # Sıkıştır
        $content = [System.IO.File]::ReadAllBytes($BackupSql)
        $ms = New-Object System.IO.MemoryStream
        $gzip = New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionMode]::Compress)
        $gzip.Write($content, 0, $content.Length)
        $gzip.Close()
        [System.IO.File]::WriteAllBytes("${BackupSql}.gz", $ms.ToArray())
        $ms.Close()
        
        Remove-Item $BackupSql -Force
        $sqlSize = (Get-Item "${BackupSql}.gz").Length / 1MB
        Write-Host "✓ SQL dump: $([math]::Round($sqlSize, 2)) MB" -ForegroundColor Green
    }
    
    # Eski yedekleri temizle
    Write-Host "▶ Eski yedekler temizleniyor ($Retention gün öncesi)..." -ForegroundColor Blue
    $cutoffDate = (Get-Date).AddDays(-$Retention)
    $oldBackups = Get-ChildItem $OutputDir -Filter "sqlite_*.db.bak" | 
                  Where-Object { $_.LastWriteTime -lt $cutoffDate }
    $oldSql = Get-ChildItem $OutputDir -Filter "sqlite_*.sql.gz" | 
              Where-Object { $_.LastWriteTime -lt $cutoffDate }
    
    $totalOld = $oldBackups.Count + $oldSql.Count
    if ($totalOld -gt 0) {
        $oldBackups | Remove-Item -Force
        $oldSql | Remove-Item -Force
        Write-Host "✓ $totalOld eski yedek silindi" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "              YEDEKLEME TAMAMLANDI!" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Binary: $BackupBinary ($([math]::Round($binarySize, 2)) MB)" -ForegroundColor White
    if ($IncludeSqlDump -and $sqlite3) {
        Write-Host "  SQL:    ${BackupSql}.gz ($([math]::Round($sqlSize, 2)) MB)" -ForegroundColor White
    }
    Write-Host ""
    Write-Host "  Geri yükleme (Binary):" -ForegroundColor Yellow
    Write-Host "  Copy-Item `"$BackupBinary`" `"$DbPath`" -Force" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Geri yükleme (SQL):" -ForegroundColor Yellow
    Write-Host "  sqlite3 `"$DbPath`" < (gunzip -c `"${BackupSql}.gz`")" -ForegroundColor Gray
    Write-Host ""
}
catch {
    Write-Host "✗ Hata: $_" -ForegroundColor Red
    exit 1
}
