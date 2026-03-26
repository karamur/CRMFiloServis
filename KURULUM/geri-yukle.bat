@echo off
chcp 65001 >nul
title CRM Filo Servis - Veritabani Geri Yukleme
color 0C

echo ============================================
echo   Veritabani Geri Yukleme
echo ============================================
echo.
echo [UYARI] Bu islem mevcut veritabanini SILIP yedeði geri yukler!
echo.

set PG_PASSWORD=CrmFilo2025!
set DB_NAME=CRMFiloServisDb
set PG_USER=postgres
set BACKUP_DIR=C:\CRMFiloServis\Backups

:: Mevcut yedekleri listele
echo Mevcut yedekler:
echo ----------------
dir /b /o-d "%BACKUP_DIR%\*.sql" 2>nul
echo.

set /p BACKUP_FILE="Yedek dosya adi (ornek: CRMFiloServisDb_20250326_120000.sql): "

if not exist "%BACKUP_DIR%\%BACKUP_FILE%" (
    echo [HATA] Dosya bulunamadi: %BACKUP_DIR%\%BACKUP_FILE%
    pause
    exit /b 1
)

set /p ONAY="Emin misiniz? Mevcut veriler silinecek! (E/H): "
if /i not "%ONAY%"=="E" (
    echo Islem iptal edildi.
    pause
    exit /b 0
)

echo.
echo Geri yukleniyor...
set PGPASSWORD=%PG_PASSWORD%

:: Oncelikle mevcut baglantilarý kes
psql -U %PG_USER% -h localhost -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '%DB_NAME%' AND pid <> pg_backend_pid();" 2>nul

:: Veritabanini sil ve yeniden olustur
psql -U %PG_USER% -h localhost -c "DROP DATABASE IF EXISTS \"%DB_NAME%\";"
psql -U %PG_USER% -h localhost -c "CREATE DATABASE \"%DB_NAME%\" ENCODING 'UTF8' TEMPLATE template0;"

:: Yedeði geri yukle
psql -U %PG_USER% -h localhost -d %DB_NAME% -f "%BACKUP_DIR%\%BACKUP_FILE%"

if %errorlevel% equ 0 (
    echo.
    echo [OK] Geri yukleme basarili!
) else (
    echo.
    echo [UYARI] Geri yukleme sirasinda bazi uyarilar olabilir, bu normaldir.
)

echo.
pause
