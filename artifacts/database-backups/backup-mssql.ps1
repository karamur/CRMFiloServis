<#
.SYNOPSIS
    KOA Filo Servis - MS SQL Server Yedekleme Script'i

.DESCRIPTION
    MS SQL Server veritabanının tam yedeğini alır (BACKUP DATABASE)

.PARAMETER Server
    SQL Server adresi (varsayılan: localhost)

.PARAMETER Database
    Veritabanı adı (varsayılan: KOAFilo)

.PARAMETER TrustedConnection
    Windows Authentication kullan

.PARAMETER User
    SQL Authentication kullanıcı adı

.PARAMETER Password
    SQL Authentication şifresi

.PARAMETER OutputDir
    Yedekleme dizini (varsayılan: .\backups)

.PARAMETER Retention
    Kaç günlük yedek tutulsun (varsayılan: 30)

.PARAMETER Compression
    Yedekleme sıkıştırma (varsayılan: true, SQL Server 2008+)

.EXAMPLE
    .\backup-mssql.ps1 -Server localhost -Database KOAFilo -TrustedConnection
    .\backup-mssql.ps1 -Server sql.example.com -Database KOAFilo -User sa -Password "P@ssw0rd"
#>

param(
    [string]$Server = "localhost",
    [string]$Database = "KOAFilo",
    [switch]$TrustedConnection,
    [string]$User = "",
    [string]$Password = "",
    [string]$OutputDir = ".\backups",
    [int]$Retention = 30,
    [bool]$Compression = $true
)

$ErrorActionPreference = "Stop"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupFile = Join-Path $OutputDir "mssql_${Database}_${Timestamp}.bak"

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║      KOA Filo Servis - MS SQL Server Yedekleme            ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Dizin oluştur
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    Write-Host "✓ Yedekleme dizini oluşturuldu: $OutputDir" -ForegroundColor Green
}

# Connection string oluştur
if ($TrustedConnection) {
    $ConnectionString = "Server=$Server;Database=master;Trusted_Connection=True;TrustServerCertificate=True"
    Write-Host "  Kimlik: Windows Authentication" -ForegroundColor Gray
}
else {
    if ([string]::IsNullOrEmpty($User)) {
        $User = Read-Host "SQL Server kullanıcı adı"
    }
    if ([string]::IsNullOrEmpty($Password)) {
        $SecurePassword = Read-Host "SQL Server şifresi" -AsSecureString
        $Password = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
        )
    }
    $ConnectionString = "Server=$Server;Database=master;User Id=$User;Password=$Password;TrustServerCertificate=True"
    Write-Host "  Kimlik: SQL Authentication ($User)" -ForegroundColor Gray
}

Write-Host "▶ Yedekleme başlıyor..." -ForegroundColor Blue
Write-Host "  Sunucu: $Server" -ForegroundColor Gray
Write-Host "  Veritabanı: $Database" -ForegroundColor Gray

try {
    # SQL bağlantısı
    $Connection = New-Object System.Data.SqlClient.SqlConnection($ConnectionString)
    $Connection.Open()
    
    # Backup komutu
    $BackupPath = (Resolve-Path $OutputDir).Path
    $FullBackupPath = Join-Path $BackupPath "mssql_${Database}_${Timestamp}.bak"
    
    $BackupSql = @"
BACKUP DATABASE [$Database] 
TO DISK = N'$FullBackupPath'
WITH FORMAT, 
     INIT, 
     NAME = N'$Database - Full Backup',
     SKIP, 
     NOREWIND, 
     NOUNLOAD,
     STATS = 10
"@

    # Sıkıştırma ekle (SQL Server 2008+)
    if ($Compression) {
        $BackupSql = $BackupSql -replace "STATS = 10", "COMPRESSION, STATS = 10"
    }
    
    $Command = New-Object System.Data.SqlClient.SqlCommand($BackupSql, $Connection)
    $Command.CommandTimeout = 3600  # 1 saat
    
    Write-Host "▶ BACKUP DATABASE çalışıyor..." -ForegroundColor Blue
    $Command.ExecuteNonQuery() | Out-Null
    
    $Connection.Close()
    
    if (Test-Path $FullBackupPath) {
        $fileSize = (Get-Item $FullBackupPath).Length / 1MB
        Write-Host "✓ Yedekleme tamamlandı: $([math]::Round($fileSize, 2)) MB" -ForegroundColor Green
    }
    else {
        throw "Yedekleme dosyası oluşturulamadı"
    }
    
    # Eski yedekleri temizle
    Write-Host "▶ Eski yedekler temizleniyor ($Retention gün öncesi)..." -ForegroundColor Blue
    $cutoffDate = (Get-Date).AddDays(-$Retention)
    $oldBackups = Get-ChildItem $OutputDir -Filter "mssql_*.bak" | 
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
    Write-Host "  Dosya: $FullBackupPath" -ForegroundColor White
    Write-Host "  Boyut: $([math]::Round($fileSize, 2)) MB" -ForegroundColor White
    Write-Host ""
    Write-Host "  Geri yükleme:" -ForegroundColor Yellow
    Write-Host "  RESTORE DATABASE [$Database] FROM DISK = N'$FullBackupPath'" -ForegroundColor Gray
    Write-Host ""
}
catch {
    Write-Host "✗ Hata: $_" -ForegroundColor Red
    if ($Connection.State -eq 'Open') {
        $Connection.Close()
    }
    exit 1
}
