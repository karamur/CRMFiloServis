"""
Piyasa Arastirma - Python Web Scraper
Sahibinden ve Arabam.com'dan ilan verileri ceker
Flask API olarak calisir, .NET uygulamasindan cagrilir
"""

from flask import Flask, request, jsonify
from playwright.sync_api import sync_playwright
import re
from datetime import datetime, timedelta
from typing import List, Dict, Any
import logging

# Logging ayarlari
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

class PiyasaScraper:
    def __init__(self):
        self.playwright = None
        self.browser = None

    def __enter__(self):
        self.playwright = sync_playwright().start()
        self.browser = self.playwright.chromium.launch(
            headless=True,
            args=['--no-sandbox', '--disable-dev-shm-usage']
        )
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.browser:
            self.browser.close()
        if self.playwright:
            self.playwright.stop()

    def slugify(self, text: str) -> str:
        """Turkce karakterleri ve bosluklari URL'ye uygun hale getirir"""
        if not text:
            return ""
        text = text.lower()
        replacements = {
            'ý': 'i', 'ö': 'o', 'ü': 'u', 
            'þ': 's', 'ð': 'g', 'ç': 'c',
            ' ': '-', '.': '', ',': ''
        }
        for old, new in replacements.items():
            text = text.replace(old, new)
        return text.replace('--', '-').strip('-')

    def parse_fiyat(self, text: str) -> int:
        """Fiyat metninden sayi cikarir"""
        if not text:
            return 0
        # "1.850.000 TL" formatini parse et
        match = re.search(r'([\d\.]+)\s*(?:TL|?|tl)', text, re.IGNORECASE)
        if match:
            fiyat_str = match.group(1).replace('.', '')
            try:
                return int(fiyat_str)
            except:
                pass
        # Sadece rakam gruplari
        match = re.search(r'(\d{1,3}(?:\.\d{3})+)', text)
        if match:
            fiyat_str = match.group().replace('.', '')
            try:
                fiyat = int(fiyat_str)
                if fiyat > 50000:
                    return fiyat
            except:
                pass
        return 0

    def parse_yil(self, text: str) -> int:
        """Yil bilgisini cikarir"""
        if not text:
            return 0
        match = re.search(r'\b(20[0-2]\d|19[89]\d)\b', text)
        if match:
            try:
                return int(match.group())
            except:
                pass
        return 0

    def parse_kilometre(self, text: str) -> int:
        """Kilometre bilgisini cikarir"""
        if not text:
            return 0
        match = re.search(r'(\d{1,3}(?:[.,]\d{3})*)\s*km', text, re.IGNORECASE)
        if match:
            km_str = match.group(1).replace('.', '').replace(',', '')
            try:
                return int(km_str)
            except:
                pass
        return 0

    def parse_tarih(self, text: str) -> str:
        """Tarih bilgisini parse eder"""
        if not text:
            return datetime.today().strftime('%Y-%m-%d')

        text_lower = text.lower().strip()

        if 'bugün' in text_lower or 'bugun' in text_lower:
            return datetime.today().strftime('%Y-%m-%d')

        if 'dün' in text_lower or 'dun' in text_lower:
            return (datetime.today() - timedelta(days=1)).strftime('%Y-%m-%d')

        # "X gun once" formatý
        gun_match = re.search(r'(\d+)\s*(?:gün|gun)\s*önce', text_lower)
        if gun_match:
            gun = int(gun_match.group(1))
            return (datetime.today() - timedelta(days=gun)).strftime('%Y-%m-%d')

        # dd.mm.yyyy veya dd/mm/yyyy
        tarih_match = re.search(r'(\d{2})[./](\d{2})[./](\d{4})', text)
        if tarih_match:
            try:
                g = int(tarih_match.group(1))
                a = int(tarih_match.group(2))
                y = int(tarih_match.group(3))
                return f"{y:04d}-{a:02d}-{g:02d}"
            except:
                pass

        return datetime.today().strftime('%Y-%m-%d')

    def tara_sahibinden(self, marka: str, model: str, ilan_tarih_gun: int = 2, 
                        yil_min: int = None, yil_max: int = None) -> List[Dict[str, Any]]:
        """Sahibinden.com'dan ilan verileri ceker"""
        ilanlar = []

        try:
            context = self.browser.new_context(
                user_agent='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
            )
            page = context.new_page()

            # URL olustur
            marka_slug = self.slugify(marka)
            model_slug = self.slugify(model)
            url = f"https://www.sahibinden.com/otomobil-{marka_slug}-{model_slug}?sorting=date_desc"

            if yil_min:
                url += f"&a5_min={yil_min}"
            if yil_max:
                url += f"&a5_max={yil_max}"

            # Tarih filtresi
            if ilan_tarih_gun > 0:
                if ilan_tarih_gun <= 1:
                    url += "&date=1day"
                elif ilan_tarih_gun <= 3:
                    url += "&date=3days"
                elif ilan_tarih_gun <= 7:
                    url += "&date=7days"
                elif ilan_tarih_gun <= 15:
                    url += "&date=15days"
                elif ilan_tarih_gun <= 30:
                    url += "&date=30days"

            logger.info(f"Sahibinden URL: {url}")
            page.goto(url, wait_until='networkidle')
            page.wait_for_timeout(2000)

            # Cookie kabul
            try:
                cookie_btn = page.locator("#onetrust-accept-btn-handler")
                if cookie_btn.is_visible():
                    cookie_btn.click()
                    page.wait_for_timeout(500)
            except:
                pass

            # Ilan satirlarini al
            rows = page.locator("tr.searchResultsItem, tbody tr[data-id]").all()
            logger.info(f"Sahibinden: {len(rows)} satir bulundu")

            for row in rows[:30]:
                try:
                    ilan = {
                        'kaynak': 'Sahibinden.com',
                        'marka': marka,
                        'model': model
                    }

                    # Ilan ID
                    ilan['ilan_no'] = row.get_attribute('data-id') or ''

                    # Link ve Baslik
                    try:
                        link = row.locator("td.searchResultsTitleValue a").first
                        href = link.get_attribute('href') or ''
                        ilan['ilan_url'] = f"https://www.sahibinden.com{href}" if not href.startswith('http') else href
                        ilan['baslik'] = (link.text_content() or '').strip()
                    except:
                        continue

                    # Fiyat
                    try:
                        fiyat_text = row.locator("td.searchResultsPriceValue").text_content() or ''
                        ilan['fiyat'] = self.parse_fiyat(fiyat_text)
                    except:
                        ilan['fiyat'] = 0

                    # Yil, KM, Renk
                    try:
                        attrs = row.locator("td.searchResultsAttributeValue").all()
                        if len(attrs) >= 1:
                            ilan['yil'] = self.parse_yil(attrs[0].text_content() or '')
                        if len(attrs) >= 2:
                            ilan['kilometre'] = self.parse_kilometre(attrs[1].text_content() or '')
                        if len(attrs) >= 3:
                            ilan['renk'] = (attrs[2].text_content() or '').strip()
                    except:
                        pass

                    # Resim
                    try:
                        img = row.locator("td.searchResultsLargeThumbnail img").first
                        img_src = img.get_attribute('src') or img.get_attribute('data-src') or ''
                        if img_src and 'placeholder' not in img_src:
                            # Buyuk resme cevir
                            img_src = img_src.replace('_thmb.', '_x5.').replace('/thumbs/', '/')
                            ilan['resim_url'] = f"https:{img_src}" if not img_src.startswith('http') else img_src
                    except:
                        pass

                    # Konum
                    try:
                        loc_text = row.locator("td.searchResultsLocationValue").text_content() or ''
                        loc_parts = loc_text.split('\n')
                        ilan['sehir'] = loc_parts[0].strip() if loc_parts else ''
                        ilan['ilce'] = loc_parts[1].strip() if len(loc_parts) > 1 else ''
                    except:
                        pass

                    # Tarih
                    try:
                        date_text = row.locator("td.searchResultsDateValue").text_content() or ''
                        ilan['ilan_tarihi'] = self.parse_tarih(date_text)
                    except:
                        ilan['ilan_tarihi'] = datetime.today().strftime('%Y-%m-%d')

                    if ilan.get('fiyat', 0) > 0 and ilan.get('ilan_url'):
                        ilanlar.append(ilan)

                except Exception as e:
                    logger.debug(f"Sahibinden ilan parse hatasi: {e}")

            page.close()
            context.close()

        except Exception as e:
            logger.error(f"Sahibinden tarama hatasi: {e}")

        return ilanlar

    def tara_arabam(self, marka: str, model: str, ilan_tarih_gun: int = 2,
                    yil_min: int = None, yil_max: int = None) -> List[Dict[str, Any]]:
        """Arabam.com'dan ilan verileri ceker"""
        ilanlar = []

        try:
            context = self.browser.new_context(
                user_agent='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
            )
            page = context.new_page()

            # URL olustur
            marka_slug = self.slugify(marka)
            model_slug = self.slugify(model)
            url = f"https://www.arabam.com/ikinci-el/{marka_slug}-{model_slug}?sort=3"

            if yil_min:
                url += f"&minYear={yil_min}"
            if yil_max:
                url += f"&maxYear={yil_max}"

            # Tarih filtresi
            if ilan_tarih_gun > 0:
                if ilan_tarih_gun <= 1:
                    url += "&listingDate=1"
                elif ilan_tarih_gun <= 3:
                    url += "&listingDate=3"
                elif ilan_tarih_gun <= 7:
                    url += "&listingDate=7"
                elif ilan_tarih_gun <= 15:
                    url += "&listingDate=15"
                elif ilan_tarih_gun <= 30:
                    url += "&listingDate=30"

            logger.info(f"Arabam URL: {url}")
            page.goto(url, wait_until='networkidle')
            page.wait_for_timeout(3000)

            # Cookie kabul
            try:
                cookie_btn = page.locator("button[data-testid='accept-all-cookies'], #onetrust-accept-btn-handler").first
                if cookie_btn.is_visible():
                    cookie_btn.click()
                    page.wait_for_timeout(1000)
            except:
                pass

            # Sayfanin yuklenmesini bekle
            page.wait_for_load_state('networkidle')
            page.wait_for_timeout(2000)

            # Tum ilan linklerini al
            all_links = page.locator("a[href*='/ilan/']").all()
            logger.info(f"Arabam: {len(all_links)} link bulundu")

            processed_ilan_nos = set()

            for link in all_links[:50]:
                try:
                    href = link.get_attribute('href') or ''
                    if not href or '/ilan/' not in href:
                        continue

                    # URL normalize
                    if not href.startswith('http'):
                        href = f"https://www.arabam.com{href}"

                    # Ilan numarasini cek
                    ilan_no_match = re.search(r'/(\d{7,})(?:/|$|\?)', href)
                    if not ilan_no_match:
                        continue

                    ilan_no = ilan_no_match.group(1)

                    # Duplicate kontrolu
                    if ilan_no in processed_ilan_nos:
                        continue
                    processed_ilan_nos.add(ilan_no)

                    # /detay'i kaldir
                    href = re.sub(r'/detay$', '', href)

                    ilan = {
                        'kaynak': 'Arabam.com',
                        'marka': marka,
                        'model': model,
                        'ilan_no': ilan_no,
                        'ilan_url': href
                    }

                    # Parent container
                    try:
                        container = link.locator("xpath=./ancestor::tr[contains(@class, 'listing')]").first
                        if not container.is_visible():
                            container = link.locator("xpath=./ancestor::*[contains(@class, 'listing')]").first
                    except:
                        container = link.locator("xpath=./..").first

                    container_text = ''
                    try:
                        container_text = container.text_content() if container else link.text_content() or ''
                    except:
                        container_text = link.text_content() or ''

                    # Baslik
                    try:
                        title_el = container.locator("h3, .listing-title, [class*='title']").first
                        ilan['baslik'] = (title_el.text_content() or '').strip()
                    except:
                        ilan['baslik'] = (link.text_content() or f"{marka} {model}").strip()

                    # Fiyat, Yil, KM
                    ilan['fiyat'] = self.parse_fiyat(container_text)
                    ilan['yil'] = self.parse_yil(container_text)
                    ilan['kilometre'] = self.parse_kilometre(container_text)

                    # Resim
                    try:
                        img = container.locator("img").first if container else link.locator("img").first
                        img_src = img.get_attribute('src') or img.get_attribute('data-src') or ''
                        if img_src and 'placeholder' not in img_src and 'logo' not in img_src:
                            # Buyuk resme cevir: _120x90 -> _580x435
                            img_src = re.sub(r'_\d+x\d+\.', '_580x435.', img_src)
                            ilan['resim_url'] = f"https:{img_src}" if not img_src.startswith('http') else img_src
                    except:
                        pass

                    ilan['ilan_tarihi'] = datetime.today().strftime('%Y-%m-%d')

                    if ilan.get('fiyat', 0) > 0:
                        ilanlar.append(ilan)
                        logger.debug(f"Arabam ilan: No={ilan_no}, URL={href}, Fiyat={ilan['fiyat']}")

                except Exception as e:
                    logger.debug(f"Arabam link parse hatasi: {e}")

            logger.info(f"Arabam: {len(ilanlar)} ilan eklendi")
            page.close()
            context.close()

        except Exception as e:
            logger.error(f"Arabam tarama hatasi: {e}")

        return ilanlar


# Flask API Endpoints

@app.route('/api/tara', methods=['POST'])
def tara():
    """Tum kaynaklardan ilan verilerini ceker"""
    try:
        data = request.get_json()
        marka = data.get('marka', '')
        model = data.get('model', '')
        ilan_tarih_gun = data.get('ilan_tarih_gun', 2)
        yil_min = data.get('yil_min')
        yil_max = data.get('yil_max')
        kaynaklar = data.get('kaynaklar', ['sahibinden', 'arabam'])

        if not marka or not model:
            return jsonify({'error': 'Marka ve model gerekli'}), 400

        tum_ilanlar = []

        with PiyasaScraper() as scraper:
            if 'sahibinden' in kaynaklar:
                logger.info(f"Sahibinden taraniyor: {marka} {model}")
                sahibinden_ilanlar = scraper.tara_sahibinden(
                    marka, model, ilan_tarih_gun, yil_min, yil_max
                )
                tum_ilanlar.extend(sahibinden_ilanlar)

            if 'arabam' in kaynaklar:
                logger.info(f"Arabam taraniyor: {marka} {model}")
                arabam_ilanlar = scraper.tara_arabam(
                    marka, model, ilan_tarih_gun, yil_min, yil_max
                )
                tum_ilanlar.extend(arabam_ilanlar)

        # Istatistikler
        fiyatlar = [i['fiyat'] for i in tum_ilanlar if i.get('fiyat', 0) > 0]

        result = {
            'toplam_ilan': len(tum_ilanlar),
            'ortalama_fiyat': sum(fiyatlar) / len(fiyatlar) if fiyatlar else 0,
            'en_dusuk_fiyat': min(fiyatlar) if fiyatlar else 0,
            'en_yuksek_fiyat': max(fiyatlar) if fiyatlar else 0,
            'ilanlar': tum_ilanlar
        }

        return jsonify(result)

    except Exception as e:
        logger.error(f"API hatasi: {e}")
        return jsonify({'error': str(e)}), 500


@app.route('/api/sahibinden', methods=['POST'])
def tara_sahibinden():
    """Sadece Sahibinden'den ilan ceker"""
    try:
        data = request.get_json()
        marka = data.get('marka', '')
        model = data.get('model', '')
        ilan_tarih_gun = data.get('ilan_tarih_gun', 2)

        with PiyasaScraper() as scraper:
            ilanlar = scraper.tara_sahibinden(marka, model, ilan_tarih_gun)

        return jsonify({'ilanlar': ilanlar, 'toplam': len(ilanlar)})

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/arabam', methods=['POST'])
def tara_arabam():
    """Sadece Arabam'dan ilan ceker"""
    try:
        data = request.get_json()
        marka = data.get('marka', '')
        model = data.get('model', '')
        ilan_tarih_gun = data.get('ilan_tarih_gun', 2)

        with PiyasaScraper() as scraper:
            ilanlar = scraper.tara_arabam(marka, model, ilan_tarih_gun)

        return jsonify({'ilanlar': ilanlar, 'toplam': len(ilanlar)})

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/health', methods=['GET'])
def health():
    """Servis saglik kontrolu"""
    return jsonify({'status': 'ok', 'service': 'piyasa-scraper'})


if __name__ == '__main__':
    print("Piyasa Scraper API baslatiliyor...")
    print("Endpoints:")
    print("  POST /api/tara - Tum kaynaklardan tara")
    print("  POST /api/sahibinden - Sadece Sahibinden")
    print("  POST /api/arabam - Sadece Arabam")
    print("  GET /api/health - Saglik kontrolu")
    app.run(host='0.0.0.0', port=5050, debug=True)
