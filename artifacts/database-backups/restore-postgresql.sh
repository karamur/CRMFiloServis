#!/bin/bash
#
# KOA Filo Servis - PostgreSQL Geri Yükleme Script'i
#
# Kullanım: ./restore-postgresql.sh <backup_file> [host] [database] [user]
#

set -e

BACKUP_FILE="${1}"
HOST="${2:-localhost}"
DATABASE="${3:-koafilo}"
USER="${4:-postgres}"

if [ -z "$BACKUP_FILE" ]; then
    echo "Kullanım: $0 <backup_file.sql.gz> [host] [database] [user]"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "✗ Yedek dosyası bulunamadı: $BACKUP_FILE"
    exit 1
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║    KOA Filo Servis - PostgreSQL Geri Yükleme              ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "  Yedek: $BACKUP_FILE"
echo "  Hedef: $HOST/$DATABASE"
echo ""
echo "⚠ Bu işlem mevcut verilerin üzerine yazacak!"
read -p "Devam etmek istiyor musunuz? (e/h): " CONFIRM
if [ "$CONFIRM" != "e" ]; then
    echo "İptal edildi."
    exit 0
fi

echo ""
echo "▶ Geri yükleme başlıyor..."
gunzip -c "$BACKUP_FILE" | psql -h "$HOST" -U "$USER" -d "$DATABASE"

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "            GERİ YÜKLEME TAMAMLANDI!"
echo "═══════════════════════════════════════════════════════════"
echo ""
