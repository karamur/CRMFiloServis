#!/bin/bash
#
# KOA Filo Servis - PostgreSQL Yedekleme Script'i
#
# Kullanım: ./backup-postgresql.sh [host] [database] [user] [output_dir]
#
# Örnekler:
#   ./backup-postgresql.sh localhost koafilo postgres
#   ./backup-postgresql.sh db.example.com koafilo admin /var/backups
#

set -e

# Parametreler
HOST="${1:-localhost}"
DATABASE="${2:-koafilo}"
USER="${3:-postgres}"
OUTPUT_DIR="${4:-./backups}"
RETENTION_DAYS="${5:-30}"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${OUTPUT_DIR}/postgresql_${DATABASE}_${TIMESTAMP}.sql.gz"

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║      KOA Filo Servis - PostgreSQL Yedekleme               ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Dizin oluştur
mkdir -p "$OUTPUT_DIR"

# pg_dump kontrolü
if ! command -v pg_dump &> /dev/null; then
    echo "✗ pg_dump bulunamadı! PostgreSQL istemci araçlarını yükleyin."
    echo "  Ubuntu/Debian: sudo apt install postgresql-client"
    echo "  RHEL/CentOS:   sudo yum install postgresql"
    exit 1
fi

echo "▶ Yedekleme başlıyor..."
echo "  Sunucu: $HOST"
echo "  Veritabanı: $DATABASE"
echo "  Kullanıcı: $USER"
echo ""

# pg_dump çalıştır ve sıkıştır
pg_dump -h "$HOST" -U "$USER" -d "$DATABASE" \
    -F p -b --no-owner --no-privileges | gzip > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    FILE_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "✓ Yedekleme tamamlandı: $BACKUP_FILE ($FILE_SIZE)"
else
    echo "✗ Yedekleme başarısız!"
    exit 1
fi

# Eski yedekleri temizle
echo ""
echo "▶ Eski yedekler temizleniyor ($RETENTION_DAYS gün öncesi)..."
DELETED=$(find "$OUTPUT_DIR" -name "postgresql_*.sql.gz" -mtime +$RETENTION_DAYS -delete -print | wc -l)
if [ "$DELETED" -gt 0 ]; then
    echo "✓ $DELETED eski yedek silindi"
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "              YEDEKLEME TAMAMLANDI!"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "  Dosya: $BACKUP_FILE"
echo "  Boyut: $FILE_SIZE"
echo ""
echo "  Geri yükleme:"
echo "  gunzip -c \"$BACKUP_FILE\" | psql -U $USER -d $DATABASE"
echo ""
