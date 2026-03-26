@echo off
chcp 65001 >nul
title CRM Filo Servis - Servis Yonetimi

echo ============================================
echo   CRM Filo Servis - Servis Yonetimi
echo ============================================
echo.
echo   1. Servisi Baslat
echo   2. Servisi Durdur
echo   3. Servisi Yeniden Baslat
echo   4. Servis Durumunu Gor
echo   5. Servisi Kaldir
echo   6. Dogrudan Calistir (Konsol Modu)
echo   7. Cikis
echo.

set /p SECIM="Seciminiz (1-7): "

if "%SECIM%"=="1" (
    net start CRMFiloServis
    echo.
    echo Servis baslatildi. Erisim: http://localhost:5190
)
if "%SECIM%"=="2" (
    net stop CRMFiloServis
    echo Servis durduruldu.
)
if "%SECIM%"=="3" (
    net stop CRMFiloServis
    timeout /t 3 >nul
    net start CRMFiloServis
    echo Servis yeniden baslatildi.
)
if "%SECIM%"=="4" (
    sc query CRMFiloServis
)
if "%SECIM%"=="5" (
    net stop CRMFiloServis 2>nul
    sc delete CRMFiloServis
    echo Servis kaldirildi.
)
if "%SECIM%"=="6" (
    echo.
    echo Konsol modunda baslatiliyor...
    echo Durdurmak icin Ctrl+C basin.
    echo.
    cd /d C:\CRMFiloServis
    CRMFiloServis.Web.exe --urls "http://0.0.0.0:5190"
)

echo.
pause
