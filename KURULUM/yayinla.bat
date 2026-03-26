@echo off
chcp 65001 >nul
title CRM Filo Servis - Publish (Yayin Hazirlama)
color 0E

echo ============================================
echo   Uygulama Yayin Hazirlama (Publish)
echo ============================================
echo.

:: Proje dizinine git
cd /d "%~dp0.."

echo [1/3] Temizleniyor...
dotnet clean CRMFiloServis.Web\CRMFiloServis.Web.csproj -c Release >nul 2>&1

echo [2/3] Publish ediliyor (self-contained)...
dotnet publish CRMFiloServis.Web\CRMFiloServis.Web.csproj ^
    -c Release ^
    -r win-x64 ^
    --self-contained true ^
    -o KURULUM\publish ^
    /p:PublishSingleFile=false ^
    /p:IncludeNativeLibrariesForSelfExtract=true

if %errorlevel% neq 0 (
    echo.
    echo [HATA] Publish basarisiz!
    pause
    exit /b 1
)

echo [3/3] Production ayarlari kopyalaniyor...
copy /Y "KURULUM\appsettings.Production.json" "KURULUM\publish\appsettings.json"

echo.
echo ============================================
echo   Publish Tamamlandi!
echo ============================================
echo.
echo   Cikti dizini: KURULUM\publish\
echo.
echo   Bu klasorun icerigini hedef PC'ye kopyalayin.
echo   Ardindan kur.bat dosyasini calistirin.
echo.
pause
