<#
.SYNOPSIS
    KOA Filo Servis - MS SQL Server Geri Yükleme Script'i

.PARAMETER BackupFile
    Yedek dosyası (.bak)

.PARAMETER Server
    SQL Server adresi

.PARAMETER Database
    Hedef veritabanı adı

.EXAMPLE
    .\restore-mssql.ps1 -BackupFile ".\backups\mssql_KOAFilo_20241201.bak" -Server localhost -Database KOAFilo -TrustedConnection
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$BackupFile,
    [string]$Server = "localhost",
    [string]$Database = "KOAFilo",
    [switch]$TrustedConnection,
    [string]$User = "",
    [string]$Password = ""
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║    KOA Filo Servis - MS SQL Server Geri Yükleme           ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $BackupFile)) {
    Write-Host "✗ Yedek dosyası bulunamadı: $BackupFile" -ForegroundColor Red
    exit 1
}

$FullBackupPath = (Resolve-Path $BackupFile).Path

Write-Host "  Yedek: $FullBackupPath" -ForegroundColor Gray
Write-Host "  Hedef: $Server/$Database" -ForegroundColor Gray
Write-Host ""

$confirm = Read-Host "⚠ Mevcut veritabanının üzerine yazılacak. Devam? (E/H)"
if ($confirm -ne "E") {
    Write-Host "İptal edildi." -ForegroundColor Yellow
    exit 0
}

# Connection string
if ($TrustedConnection) {
    $ConnectionString = "Server=$Server;Database=master;Trusted_Connection=True;TrustServerCertificate=True"
}
else {
    if ([string]::IsNullOrEmpty($User)) { $User = Read-Host "Kullanıcı adı" }
    if ([string]::IsNullOrEmpty($Password)) {
        $SecurePassword = Read-Host "Şifre" -AsSecureString
        $Password = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
        )
    }
    $ConnectionString = "Server=$Server;Database=master;User Id=$User;Password=$Password;TrustServerCertificate=True"
}

try {
    $Connection = New-Object System.Data.SqlClient.SqlConnection($ConnectionString)
    $Connection.Open()
    
    # Mevcut bağlantıları kes
    Write-Host "▶ Mevcut bağlantılar kesiliyor..." -ForegroundColor Blue
    $killSql = @"
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = '$Database')
BEGIN
    ALTER DATABASE [$Database] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
END
"@
    $cmd = New-Object System.Data.SqlClient.SqlCommand($killSql, $Connection)
    $cmd.ExecuteNonQuery() | Out-Null
    
    # Restore
    Write-Host "▶ RESTORE DATABASE çalışıyor..." -ForegroundColor Blue
    $restoreSql = @"
RESTORE DATABASE [$Database] 
FROM DISK = N'$FullBackupPath'
WITH REPLACE, RECOVERY, STATS = 10;
ALTER DATABASE [$Database] SET MULTI_USER;
"@
    $cmd = New-Object System.Data.SqlClient.SqlCommand($restoreSql, $Connection)
    $cmd.CommandTimeout = 3600
    $cmd.ExecuteNonQuery() | Out-Null
    
    $Connection.Close()
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "            GERİ YÜKLEME TAMAMLANDI!" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
}
catch {
    Write-Host "✗ Hata: $_" -ForegroundColor Red
    if ($Connection.State -eq 'Open') { $Connection.Close() }
    exit 1
}
