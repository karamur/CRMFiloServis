@echo off
chcp 65001 >nul
title CRM Filo Servis - Mevcut DB'yi Tasi
color 0D

echo ============================================
echo   Mevcut Veritabani Yedegi Al (Tasima icin)
echo ============================================
echo.
echo Bu script gelistirme PC'sindeki veritabanindan
echo yedek alir. Hedef PC'de geri-yukle.bat ile
echo yuklenir.
echo.

:: Mevcut appsettings.json'dan bilgileri oku
set PG_USER=postgres
set PG_HOST=localhost
set PG_PORT=5432
set /p PG_PASSWORD="PostgreSQL sifresi: "
set /p DB_NAME="Veritabani adi (varsayilan: DestekCRMServisBlazorDb): "
if "%DB_NAME%"=="" set DB_NAME=DestekCRMServisBlazorDb

set BACKUP_DIR=%~dp0
set BACKUP_FILE=%BACKUP_DIR%veritabani-yedek.sql

echo.
echo Yedekleniyor: %DB_NAME%
echo Dosya: %BACKUP_FILE%
echo.

set PGPASSWORD=%PG_PASSWORD%
pg_dump -U %PG_USER% -h %PG_HOST% -p %PG_PORT% -d %DB_NAME% -f "%BACKUP_FILE%" --no-owner --no-privileges --if-exists --clean

if %errorlevel% equ 0 (
    echo.
    echo ============================================
    echo   [OK] Yedek basariyla alindi!
    echo   Dosya: %BACKUP_FILE%
    echo ============================================
    echo.
    echo   Bu dosyayi KURULUM klasoruyle birlikte
    echo   hedef PC'ye kopyalayin.
    echo   Hedef PC'de geri-yukle.bat ile yukleyin.
) else (
    echo.
    echo [HATA] Yedekleme basarisiz!
    echo pg_dump PATH'de tanimli mi kontrol edin.
    echo PostgreSQL bin klasorunu PATH'e ekleyin:
    echo   ornek: C:\Program Files\PostgreSQL\16\bin
)

echo.
pause
