#!/bin/bash
#
# KOA Filo Servis - SQLite Yedekleme Script'i
#
# Kullanım: ./backup-sqlite.sh <db_path> [output_dir] [retention_days]
#
# Örnekler:
#   ./backup-sqlite.sh /opt/koafilo/data/koafilo.db
#   ./backup-sqlite.sh ./koafilo.db ./backups 30
#

set -e

# Parametreler
DB_PATH="${1}"
OUTPUT_DIR="${2:-./backups}"
RETENTION_DAYS="${3:-30}"

if [ -z "$DB_PATH" ]; then
    echo "Kullanım: $0 <db_path> [output_dir] [retention_days]"
    exit 1
fi

if [ ! -f "$DB_PATH" ]; then
    echo "✗ Veritabanı bulunamadı: $DB_PATH"
    exit 1
fi

DB_NAME=$(basename "$DB_PATH" .db)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_BINARY="${OUTPUT_DIR}/sqlite_${DB_NAME}_${TIMESTAMP}.db.bak"
BACKUP_SQL="${OUTPUT_DIR}/sqlite_${DB_NAME}_${TIMESTAMP}.sql.gz"

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║        KOA Filo Servis - SQLite Yedekleme                 ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Dizin oluştur
mkdir -p "$OUTPUT_DIR"

echo "▶ Yedekleme başlıyor..."
echo "  Veritabanı: $DB_PATH"
echo ""

# sqlite3 kontrolü
if command -v sqlite3 &> /dev/null; then
    # sqlite3 CLI ile yedekle (en güvenli)
    echo "▶ Binary yedek oluşturuluyor..."
    sqlite3 "$DB_PATH" ".backup '$BACKUP_BINARY'"
    BINARY_SIZE=$(du -h "$BACKUP_BINARY" | cut -f1)
    echo "✓ Binary yedek: $BINARY_SIZE"
    
    # SQL dump
    echo "▶ SQL dump oluşturuluyor..."
    sqlite3 "$DB_PATH" ".dump" | gzip > "$BACKUP_SQL"
    SQL_SIZE=$(du -h "$BACKUP_SQL" | cut -f1)
    echo "✓ SQL dump: $SQL_SIZE"
else
    # sqlite3 yoksa dosya kopyası
    echo "⚠ sqlite3 CLI bulunamadı, dosya kopyası yapılıyor"
    cp "$DB_PATH" "$BACKUP_BINARY"
    
    # WAL dosyaları
    [ -f "${DB_PATH}-wal" ] && cp "${DB_PATH}-wal" "${BACKUP_BINARY}-wal"
    [ -f "${DB_PATH}-shm" ] && cp "${DB_PATH}-shm" "${BACKUP_BINARY}-shm"
    
    BINARY_SIZE=$(du -h "$BACKUP_BINARY" | cut -f1)
    echo "✓ Binary yedek: $BINARY_SIZE"
fi

# Eski yedekleri temizle
echo ""
echo "▶ Eski yedekler temizleniyor ($RETENTION_DAYS gün öncesi)..."
DELETED_BIN=$(find "$OUTPUT_DIR" -name "sqlite_*.db.bak" -mtime +$RETENTION_DAYS -delete -print | wc -l)
DELETED_SQL=$(find "$OUTPUT_DIR" -name "sqlite_*.sql.gz" -mtime +$RETENTION_DAYS -delete -print | wc -l)
TOTAL_DELETED=$((DELETED_BIN + DELETED_SQL))
if [ "$TOTAL_DELETED" -gt 0 ]; then
    echo "✓ $TOTAL_DELETED eski yedek silindi"
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "              YEDEKLEME TAMAMLANDI!"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "  Binary: $BACKUP_BINARY ($BINARY_SIZE)"
if [ -f "$BACKUP_SQL" ]; then
    echo "  SQL:    $BACKUP_SQL ($SQL_SIZE)"
fi
echo ""
echo "  Geri yükleme (Binary):"
echo "  cp \"$BACKUP_BINARY\" \"$DB_PATH\""
echo ""
echo "  Geri yükleme (SQL):"
echo "  gunzip -c \"$BACKUP_SQL\" | sqlite3 \"$DB_PATH\""
echo ""
