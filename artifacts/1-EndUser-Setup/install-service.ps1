#Requires -RunAsAdministrator
<#
.SYNOPSIS
    KOA Filo Servis - Windows Service Kurulumu
#>

$ServiceName = "KOAFiloServis"
$DisplayName = "KOA Filo Servis"
$InstallPath = "C:\KOAFiloServis"
$ExePath = "$InstallPath\KOAFiloServis.Web.exe"

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║    KOA Filo Servis - Windows Service Kurulumu             ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Mevcut service kontrolü
$existing = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "⚠ Mevcut servis bulundu" -ForegroundColor Yellow
    Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
    sc.exe delete $ServiceName | Out-Null
    Start-Sleep -Seconds 2
    Write-Host "  ✓ Eski servis kaldirildi" -ForegroundColor Green
}

# Uygulama kontrolü
if (-not (Test-Path $ExePath)) {
    Write-Host "✗ Uygulama bulunamadi: $ExePath" -ForegroundColor Red
    Write-Host "  Once install.ps1 veya Kur.bat calistirin" -ForegroundColor Yellow
    exit 1
}

# Service oluştur
Write-Host "▶ Service olusturuluyor..." -ForegroundColor Blue
New-Service -Name $ServiceName -BinaryPathName $ExePath -DisplayName $DisplayName -StartupType Automatic -Description "KOA Filo Servis - Filo Yonetim Uygulamasi" | Out-Null

# Recovery ayarları
sc.exe failure $ServiceName reset= 86400 actions= restart/5000/restart/10000/restart/30000 | Out-Null

# Servisi başlat
Write-Host "▶ Service baslatiliyor..." -ForegroundColor Blue
Start-Service -Name $ServiceName
Start-Sleep -Seconds 3

$svc = Get-Service -Name $ServiceName
Write-Host ""
if ($svc.Status -eq "Running") {
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "         SERVICE KURULUMU TAMAMLANDI!" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Service:  $ServiceName (Calisiyor)" -ForegroundColor White
    Write-Host "  Web:      http://localhost:5000" -ForegroundColor White
    Write-Host ""
    Write-Host "  Komutlar:" -ForegroundColor Yellow
    Write-Host "    Durdur:     Stop-Service $ServiceName" -ForegroundColor Gray
    Write-Host "    Baslat:     Start-Service $ServiceName" -ForegroundColor Gray
    Write-Host "    Kaldir:     sc.exe delete $ServiceName" -ForegroundColor Gray
} else {
    Write-Host "⚠ Service durumu: $($svc.Status)" -ForegroundColor Yellow
}
