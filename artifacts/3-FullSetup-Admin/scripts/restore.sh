#!/bin/bash
# KOA Filo Servis - Geri Yükleme
if [ -z "$1" ]; then
    echo "Kullanim: $0 <backup.sql.gz>"
    exit 1
fi

docker-compose stop app
gunzip -c "$1" | docker exec -i koafilo-db psql -U postgres -d koafilo
docker-compose start app

echo "Geri yukleme tamamlandi!"
