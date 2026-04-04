#!/bin/bash
#
# KOA Filo Servis - SQLite Geri Yükleme Script'i
#
# Kullanım: ./restore-sqlite.sh <backup_file> <db_path>
#

set -e

BACKUP_FILE="${1}"
DB_PATH="${2}"

if [ -z "$BACKUP_FILE" ] || [ -z "$DB_PATH" ]; then
    echo "Kullanım: $0 <backup_file> <db_path>"
    echo ""
    echo "Örnekler:"
    echo "  $0 ./backups/sqlite_koafilo_20241201.db.bak ./data/koafilo.db"
    echo "  $0 ./backups/sqlite_koafilo_20241201.sql.gz ./data/koafilo.db"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "✗ Yedek dosyası bulunamadı: $BACKUP_FILE"
    exit 1
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║      KOA Filo Servis - SQLite Geri Yükleme                ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "  Yedek: $BACKUP_FILE"
echo "  Hedef: $DB_PATH"
echo ""
echo "⚠ Mevcut veritabanının üzerine yazılacak!"
read -p "Devam etmek istiyor musunuz? (e/h): " CONFIRM
if [ "$CONFIRM" != "e" ]; then
    echo "İptal edildi."
    exit 0
fi

# Hedef dizini oluştur
mkdir -p "$(dirname "$DB_PATH")"

echo ""
echo "▶ Geri yükleme başlıyor..."

if [[ "$BACKUP_FILE" == *.db.bak ]]; then
    # Binary geri yükleme
    cp "$BACKUP_FILE" "$DB_PATH"
    [ -f "${BACKUP_FILE}-wal" ] && cp "${BACKUP_FILE}-wal" "${DB_PATH}-wal"
    [ -f "${BACKUP_FILE}-shm" ] && cp "${BACKUP_FILE}-shm" "${DB_PATH}-shm"
    echo "✓ Binary geri yükleme tamamlandı"
    
elif [[ "$BACKUP_FILE" == *.sql.gz ]]; then
    # SQL dump geri yükleme
    if ! command -v sqlite3 &> /dev/null; then
        echo "✗ sqlite3 CLI gerekli!"
        exit 1
    fi
    
    rm -f "$DB_PATH"
    gunzip -c "$BACKUP_FILE" | sqlite3 "$DB_PATH"
    echo "✓ SQL dump geri yükleme tamamlandı"
else
    echo "✗ Desteklenmeyen yedek formatı"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "            GERİ YÜKLEME TAMAMLANDI!"
echo "═══════════════════════════════════════════════════════════"
echo ""
