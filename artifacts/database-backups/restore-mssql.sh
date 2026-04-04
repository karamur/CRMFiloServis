#!/bin/bash
#
# KOA Filo Servis - MS SQL Server Geri Yükleme Script'i
#
# Kullanım: ./restore-mssql.sh <backup_file> <server> <database> <user>
#

set -e

BACKUP_FILE="${1}"
SERVER="${2:-localhost}"
DATABASE="${3:-KOAFilo}"
USER="${4:-sa}"

if [ -z "$BACKUP_FILE" ]; then
    echo "Kullanım: $0 <backup_file.bak> <server> <database> <user>"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "✗ Yedek dosyası bulunamadı: $BACKUP_FILE"
    exit 1
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║    KOA Filo Servis - MS SQL Server Geri Yükleme           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "  Yedek: $BACKUP_FILE"
echo "  Hedef: $SERVER/$DATABASE"
echo ""
echo "⚠ Mevcut veritabanının üzerine yazılacak!"
read -p "Devam etmek istiyor musunuz? (e/h): " CONFIRM
if [ "$CONFIRM" != "e" ]; then
    echo "İptal edildi."
    exit 0
fi

echo ""
echo -n "SQL Server şifresi ($USER): "
read -s PASSWORD
echo ""

# Docker container ise önce dosyayı kopyala
BACKUP_NAME=$(basename "$BACKUP_FILE")
SQL_BACKUP_PATH="/var/opt/mssql/backup/${BACKUP_NAME}"

if docker ps --format '{{.Names}}' | grep -qE "koafilo-db|mssql"; then
    CONTAINER=$(docker ps --format '{{.Names}}' | grep -E "koafilo-db|mssql" | head -1)
    echo "▶ Docker container'a dosya kopyalanıyor: $CONTAINER"
    docker cp "$BACKUP_FILE" "${CONTAINER}:${SQL_BACKUP_PATH}"
    RESTORE_PATH="$SQL_BACKUP_PATH"
else
    RESTORE_PATH="$BACKUP_FILE"
fi

echo "▶ RESTORE DATABASE çalışıyor..."

RESTORE_SQL="
ALTER DATABASE [$DATABASE] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [$DATABASE] FROM DISK = N'$RESTORE_PATH' WITH REPLACE, RECOVERY, STATS = 10;
ALTER DATABASE [$DATABASE] SET MULTI_USER;
"

sqlcmd -S "$SERVER" -U "$USER" -P "$PASSWORD" -Q "$RESTORE_SQL" -b

if [ $? -eq 0 ]; then
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "            GERİ YÜKLEME TAMAMLANDI!"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
else
    echo "✗ Geri yükleme başarısız!"
    exit 1
fi
