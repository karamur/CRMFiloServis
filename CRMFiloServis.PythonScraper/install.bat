@echo off
echo Piyasa Scraper Kurulum ve Calistirma
echo =====================================

REM Python kontrolu
python --version >nul 2>&1
if errorlevel 1 (
    echo Python bulunamadi! Lutfen Python 3.10+ yukleyin.
    pause
    exit /b 1
)

REM Virtual environment olustur
if not exist "venv" (
    echo Virtual environment olusturuluyor...
    python -m venv venv
)

REM Aktivasyon
call venv\Scripts\activate.bat

REM Paketleri yukle
echo Paketler yukleniyor...
pip install -r requirements.txt

REM Playwright tarayicilarini yukle
echo Playwright tarayicilari yukleniyor...
playwright install chromium

echo.
echo Kurulum tamamlandi!
echo.
echo Servisi baslatmak icin: start_scraper.bat
pause
