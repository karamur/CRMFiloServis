@echo off
chcp 65001 >nul
title CRM Filo Servis - Kurulum Scripti
color 0A

echo ============================================
echo   CRM Filo Servis - Otomatik Kurulum
echo ============================================
echo.

:: ---- Yonetici kontrolu ----
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [HATA] Bu script yonetici olarak calistirilmalidir!
    echo Sag tikla ^> "Yonetici olarak calistir" secin.
    pause
    exit /b 1
)

:: ---- Degiskenler ----
set INSTALL_DIR=C:\CRMFiloServis
set PG_PASSWORD=CrmFilo2025!
set DB_NAME=CRMFiloServisDb
set PG_USER=postgres
set HTTP_PORT=5190
set HTTPS_PORT=7113

echo [1/6] Kurulum dizini olusturuluyor...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%INSTALL_DIR%\Data" mkdir "%INSTALL_DIR%\Data"
if not exist "%INSTALL_DIR%\Backups" mkdir "%INSTALL_DIR%\Backups"
if not exist "%INSTALL_DIR%\Logs" mkdir "%INSTALL_DIR%\Logs"

echo [2/6] .NET 10 Runtime kontrol ediliyor...
dotnet --list-runtimes 2>nul | findstr "Microsoft.AspNetCore.App 10" >nul
if %errorlevel% neq 0 (
    echo.
    echo [!] .NET 10 ASP.NET Core Runtime bulunamadi!
    echo     Lutfen asagidaki linkten indirin:
    echo     https://dotnet.microsoft.com/download/dotnet/10.0
    echo.
    echo     "ASP.NET Core Runtime 10.x" - Windows x64 Hosting Bundle indirin.
    echo.
    pause
    exit /b 1
) else (
    echo     .NET 10 Runtime mevcut. OK
)

echo [3/6] PostgreSQL kontrol ediliyor...
where psql >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [!] PostgreSQL bulunamadi!
    echo     Lutfen asagidaki linkten indirin:
    echo     https://www.postgresql.org/download/windows/
    echo     Kurulum sirasinda sifre olarak: %PG_PASSWORD% girin.
    echo.
    pause
    exit /b 1
) else (
    echo     PostgreSQL mevcut. OK
)

echo [4/6] Veritabani olusturuluyor...
set PGPASSWORD=%PG_PASSWORD%
psql -U %PG_USER% -h localhost -tc "SELECT 1 FROM pg_database WHERE datname = '%DB_NAME%'" | findstr "1" >nul
if %errorlevel% neq 0 (
    psql -U %PG_USER% -h localhost -c "CREATE DATABASE \"%DB_NAME%\" ENCODING 'UTF8' LC_COLLATE 'Turkish_Turkey.1254' LC_CTYPE 'Turkish_Turkey.1254' TEMPLATE template0;"
    if %errorlevel% equ 0 (
        echo     Veritabani olusturuldu: %DB_NAME%
    ) else (
        echo [UYARI] Veritabani olusturulamadi. Manuel olusturmaniz gerekebilir.
    )
) else (
    echo     Veritabani zaten mevcut: %DB_NAME%
)

echo [5/6] Uygulama dosyalari kopyalaniyor...
echo     Publish klasorunun "%INSTALL_DIR%" altina kopyalandigini kontrol edin.
if exist "publish\*" (
    xcopy /E /Y /Q "publish\*" "%INSTALL_DIR%\"
    echo     Dosyalar kopyalandi.
) else (
    echo [UYARI] "publish" klasoru bulunamadi.
    echo     Once asagidaki komutu calistirin:
    echo     dotnet publish CRMFiloServis.Web -c Release -o publish
)

echo [6/6] Windows Servisi olusturuluyor...
sc query CRMFiloServis >nul 2>&1
if %errorlevel% neq 0 (
    sc create CRMFiloServis binPath="%INSTALL_DIR%\CRMFiloServis.Web.exe --urls http://0.0.0.0:%HTTP_PORT%" start=auto DisplayName="CRM Filo Servis"
    sc description CRMFiloServis "CRM Filo Servis - Web Uygulamasi"
    echo     Windows servisi olusturuldu.
) else (
    echo     Windows servisi zaten mevcut.
)

echo.
echo ============================================
echo   Kurulum Tamamlandi!
echo ============================================
echo.
echo   Uygulama Adresi: http://localhost:%HTTP_PORT%
echo   Ag Erisimi:      http://BILGISAYAR_IP:%HTTP_PORT%
echo.
echo   Servisi baslatmak icin:
echo     sc start CRMFiloServis
echo.
echo   Veya dogrudan calistirmak icin:
echo     cd %INSTALL_DIR%
echo     CRMFiloServis.Web.exe
echo.
pause
