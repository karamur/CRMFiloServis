@echo off
setlocal

set "ROOT=%~dp0"
set "PROJECT=%ROOT%KOAFiloServis.Web\KOAFiloServis.Web.csproj"
set "OUTPUT=%~1"
if "%OUTPUT%"=="" set "OUTPUT=%ROOT%artifacts\iis-package"
set "ZIP_PATH=%ROOT%artifacts\KOAFiloServis.IIS.zip"

echo KOA Filo Servis IIS publish paketi uretiliyor...
echo Proje: %PROJECT%
echo Cikti: %OUTPUT%

if exist "%OUTPUT%" rmdir /s /q "%OUTPUT%"
if not exist "%ROOT%artifacts" mkdir "%ROOT%artifacts"

dotnet publish "%PROJECT%" -c Release -o "%OUTPUT%"
if errorlevel 1 exit /b %errorlevel%

if exist "%ZIP_PATH%" del /f /q "%ZIP_PATH%"
pwsh -NoProfile -ExecutionPolicy Bypass -Command "Compress-Archive -Path '%OUTPUT%\*' -DestinationPath '%ZIP_PATH%' -Force"
if errorlevel 1 exit /b %errorlevel%

echo.
echo Paket hazir:
echo   Klasor : %OUTPUT%
echo   Zip    : %ZIP_PATH%
echo.
echo Sunucuda kurulum icin:
echo   kur.bat [HedefKlasor] [YedekKlasoru] [SiteAdi]

exit /b 0
