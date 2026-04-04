# KOA Filo Servis - Kurumsal Kurulum Rehberi

## 📦 Paket İçeriği

```
3-FullSetup-Admin/
├── app/
│   └── KOAFiloServis.Web.exe    # Ana uygulama (107 MB)
├── Kur.bat                      # Tam kurulum
├── docker-compose.yml           # Full stack
├── nginx/
│   └── nginx.conf               # Reverse proxy
├── monitoring/
│   ├── prometheus.yml           # Metrikler
│   └── grafana-dashboard.json   # Dashboard
├── scripts/
│   ├── install.sh               # Linux kurulum
│   ├── backup.sh                # Yedekleme
│   └── restore.sh               # Geri yükleme
├── web-landing/
│   └── index.html               # Tanıtım sayfası
├── admin-panel/
│   └── index.html               # Yönetim paneli
└── README.md
```

---

## 🚀 Kurulum

### Windows - Çift Tıkla Kurulum

```
1. "Kur.bat" dosyasına çift tıklayın
2. Tüm bileşenler otomatik kurulur
```

### Docker - Full Stack

```bash
docker-compose up -d
```

Bu komut aşağıdakileri başlatır:
- ✅ KOA Filo Servis (Ana uygulama)
- ✅ PostgreSQL (Veritabanı)
- ✅ Redis (Cache)
- ✅ Nginx (Reverse proxy)
- ✅ Prometheus (Metrikler)
- ✅ Grafana (Dashboard)

---

## 🌐 Erişim Noktaları

| Servis | URL | Varsayılan Giriş |
|--------|-----|------------------|
| **Web Uygulaması** | http://localhost | - |
| **Yönetim Paneli** | http://localhost/admin | admin / admin |
| **Grafana** | http://localhost:3000 | admin / grafana |
| **Prometheus** | http://localhost:9090 | - |

---

## ⚙️ Yapılandırma

### .env Dosyası

```env
POSTGRES_PASSWORD=GucluSifre123!
REDIS_PASSWORD=RedisSifre123!
GRAFANA_PASSWORD=GrafanaAdmin!
```

### SSL Sertifikası (Let's Encrypt)

```bash
./scripts/setup-ssl.sh yourdomain.com admin@yourdomain.com
```

---

## 📊 Monitoring

### Prometheus Metrikleri
- HTTP istek sayısı ve süreleri
- Veritabanı bağlantıları
- Bellek ve CPU kullanımı

### Grafana Dashboard
- Hazır paneller
- Trend analizleri
- Alert tanımları

---

## 🔧 Yedekleme

### Manuel Yedekleme
```bash
./scripts/backup.sh
```

### Otomatik Yedekleme (Cron)
```bash
# Her gün 03:00'da
0 3 * * * /opt/koafiloservis/backup.sh
```

### Geri Yükleme
```bash
./scripts/restore.sh /path/to/backup.sql.gz
```

---

## 📞 Destek

- **E-posta:** enterprise@koafiloservis.com
- **SLA:** 7/24 (Enterprise lisans)

**Versiyon:** 1.0.0
