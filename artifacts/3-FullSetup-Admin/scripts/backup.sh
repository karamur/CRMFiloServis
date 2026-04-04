#!/bin/bash
# KOA Filo Servis - Yedekleme
BACKUP_DIR="/var/backups/koafilo"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"
docker exec koafilo-db pg_dump -U postgres koafilo | gzip > "$BACKUP_DIR/backup_$TIMESTAMP.sql.gz"
find "$BACKUP_DIR" -name "*.sql.gz" -mtime +30 -delete

echo "Yedekleme tamamlandi: $BACKUP_DIR/backup_$TIMESTAMP.sql.gz"
