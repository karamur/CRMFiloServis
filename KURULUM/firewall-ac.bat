@echo off
chcp 65001 >nul
title CRM Filo Servis - Guvenlik Duvari Ayarlari

echo ============================================
echo   Guvenlik Duvari Port Acma
echo ============================================
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [HATA] Yonetici olarak calistirin!
    pause
    exit /b 1
)

echo HTTP port (5190) aciliyor...
netsh advfirewall firewall delete rule name="CRM Filo Servis HTTP" >nul 2>&1
netsh advfirewall firewall add rule name="CRM Filo Servis HTTP" dir=in action=allow protocol=tcp localport=5190

echo HTTPS port (7113) aciliyor...
netsh advfirewall firewall delete rule name="CRM Filo Servis HTTPS" >nul 2>&1
netsh advfirewall firewall add rule name="CRM Filo Servis HTTPS" dir=in action=allow protocol=tcp localport=7113

echo.
echo [OK] Guvenlik duvari kurallari eklendi.
echo.
echo Ag uzerinden erisim icin bu PC'nin IP adresini ogrenmek:
echo.
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "IPv4"') do echo   %%a
echo.
echo Diger bilgisayarlardan erisim:
echo   http://YUKARDAKI_IP:5190
echo.
pause
