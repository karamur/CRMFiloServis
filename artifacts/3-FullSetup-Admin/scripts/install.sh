#!/bin/bash
# KOA Filo Servis - Kurulum
INSTALL_DIR="/opt/koafilo"

echo "KOA Filo Servis kuruluyor..."

# Docker kontrol
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sh
fi

# Dizin oluştur
mkdir -p "$INSTALL_DIR"
cp -r . "$INSTALL_DIR/"
cd "$INSTALL_DIR"

# SSL sertifikası
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout ssl/privkey.pem -out ssl/fullchain.pem \
    -subj "/CN=localhost" 2>/dev/null

# Başlat
docker-compose up -d

echo "Kurulum tamamlandi!"
echo "Web: http://localhost"
echo "Grafana: http://localhost:3000"
