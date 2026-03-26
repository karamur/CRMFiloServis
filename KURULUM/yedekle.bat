@echo off
chcp 65001 >nul
title CRM Filo Servis - Veritabani Yedekleme
color 0B

echo ============================================
echo   Veritabani Yedekleme
echo ============================================
echo.

set PG_PASSWORD=CrmFilo2025!
set DB_NAME=CRMFiloServisDb
set PG_USER=postgres
set BACKUP_DIR=C:\CRMFiloServis\Backups

:: Tarih formati
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set DATETIME=%%I
set BACKUP_FILE=%BACKUP_DIR%\%DB_NAME%_%DATETIME:~0,8%_%DATETIME:~8,6%.sql

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

echo Yedekleniyor: %DB_NAME%
echo Dosya: %BACKUP_FILE%
echo.

set PGPASSWORD=%PG_PASSWORD%
pg_dump -U %PG_USER% -h localhost -d %DB_NAME% -f "%BACKUP_FILE%" --no-owner --no-privileges --if-exists --clean

if %errorlevel% equ 0 (
    echo.
    echo [OK] Yedekleme basarili!
    echo Dosya: %BACKUP_FILE%

    :: 30 gunlukten eski yedekleri sil
    forfiles /p "%BACKUP_DIR%" /m *.sql /d -30 /c "cmd /c del @file" 2>nul
    echo Eski yedekler temizlendi (30+ gun).
) else (
    echo.
    echo [HATA] Yedekleme basarisiz!
    echo pg_dump bulunamadi veya veritabani baglantisi kurulamadi.
)

echo.
pause
