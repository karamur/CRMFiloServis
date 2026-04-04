#Requires -RunAsAdministrator
<#
.SYNOPSIS
    KOA Filo Servis - Otomatik Kurulum
#>

$ErrorActionPreference = "Stop"
$InstallPath = "C:\KOAFiloServis"
$AppName = "KOA Filo Servis"
$Port = 5000

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║       KOA Filo Servis - Kurulum Sihirbazi                 ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Mevcut kurulum kontrolü
if (Test-Path $InstallPath) {
    Write-Host "⚠ Mevcut kurulum bulundu" -ForegroundColor Yellow
    $confirm = Read-Host "Uzerine yazmak ister misiniz? (E/H)"
    if ($confirm -ne "E") { exit }
    Remove-Item $InstallPath -Recurse -Force
}

# Dosyaları kopyala
Write-Host "▶ [1/4] Dosyalar kopyalaniyor..." -ForegroundColor Blue
New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
Copy-Item -Path ".\app\*" -Destination $InstallPath -Recurse -Force
Write-Host "  ✓ $InstallPath" -ForegroundColor Green

# Firewall kuralı
Write-Host "▶ [2/4] Firewall kurali ekleniyor..." -ForegroundColor Blue
$rule = Get-NetFirewallRule -DisplayName $AppName -ErrorAction SilentlyContinue
if (-not $rule) {
    New-NetFirewallRule -DisplayName $AppName -Direction Inbound -Protocol TCP -LocalPort $Port -Action Allow | Out-Null
}
Write-Host "  ✓ Port $Port acildi" -ForegroundColor Green

# Masaüstü kısayolu
Write-Host "▶ [3/4] Kisayollar olusturuluyor..." -ForegroundColor Blue
$WshShell = New-Object -ComObject WScript.Shell

$DesktopShortcut = "$env:USERPROFILE\Desktop\$AppName.lnk"
$Shortcut = $WshShell.CreateShortcut($DesktopShortcut)
$Shortcut.TargetPath = "$InstallPath\KOAFiloServis.Web.exe"
$Shortcut.WorkingDirectory = $InstallPath
$Shortcut.Save()

$StartMenuShortcut = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\$AppName.lnk"
$Shortcut2 = $WshShell.CreateShortcut($StartMenuShortcut)
$Shortcut2.TargetPath = "$InstallPath\KOAFiloServis.Web.exe"
$Shortcut2.WorkingDirectory = $InstallPath
$Shortcut2.Save()
Write-Host "  ✓ Masaustu ve Baslat menusu" -ForegroundColor Green

Write-Host "▶ [4/4] Kurulum tamamlandi!" -ForegroundColor Blue

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "              KURULUM TAMAMLANDI!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "  Kurulum:    $InstallPath" -ForegroundColor White
Write-Host "  Web:        http://localhost:$Port" -ForegroundColor White
Write-Host ""

$start = Read-Host "Uygulamayi simdi baslatmak ister misiniz? (E/H)"
if ($start -eq "E") {
    Start-Process "$InstallPath\KOAFiloServis.Web.exe"
    Start-Sleep -Seconds 3
    Start-Process "http://localhost:$Port"
}
