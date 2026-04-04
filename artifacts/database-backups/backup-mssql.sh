#!/bin/bash
#
# KOA Filo Servis - MS SQL Server Yedekleme Script'i
#
# Kullanım: ./backup-mssql.sh <server> <database> <user> [output_dir]
#
# Gereksinimler: sqlcmd (mssql-tools paketi)
#   Ubuntu: curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
#           sudo apt install mssql-tools unixodbc-dev
#
# Örnekler:
#   ./backup-mssql.sh localhost KOAFilo sa
#   ./backup-mssql.sh sql.example.com KOAFilo admin ./backups
#

set -e

# Parametreler
SERVER="${1:-localhost}"
DATABASE="${2:-KOAFilo}"
USER="${3:-sa}"
OUTPUT_DIR="${4:-./backups}"
RETENTION_DAYS="${5:-30}"

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Kullanım: $0 <server> <database> <user> [output_dir]"
    exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="mssql_${DATABASE}_${TIMESTAMP}.bak"
BACKUP_PATH="${OUTPUT_DIR}/${BACKUP_FILE}"

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║      KOA Filo Servis - MS SQL Server Yedekleme            ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# sqlcmd kontrolü
if ! command -v sqlcmd &> /dev/null; then
    echo "✗ sqlcmd bulunamadı! mssql-tools paketini yükleyin."
    echo ""
    echo "  Ubuntu/Debian:"
    echo "    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -"
    echo "    sudo add-apt-repository \"deb [arch=amd64] https://packages.microsoft.com/ubuntu/$(lsb_release -rs)/prod $(lsb_release -cs) main\""
    echo "    sudo apt update && sudo apt install mssql-tools unixodbc-dev"
    echo ""
    echo "  RHEL/CentOS:"
    echo "    sudo curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/8/prod.repo"
    echo "    sudo yum install mssql-tools unixODBC-devel"
    exit 1
fi

# Dizin oluştur
mkdir -p "$OUTPUT_DIR"

# Şifre sor
echo -n "SQL Server şifresi ($USER): "
read -s PASSWORD
echo ""

if [ -z "$PASSWORD" ]; then
    echo "✗ Şifre boş olamaz!"
    exit 1
fi

echo "▶ Yedekleme başlıyor..."
echo "  Sunucu: $SERVER"
echo "  Veritabanı: $DATABASE"
echo "  Kullanıcı: $USER"
echo ""

# SQL Server'da backup dizini farklı olabilir
# Yerel yedek alıp sonra transfer ediyoruz
SQL_BACKUP_PATH="/var/opt/mssql/backup/${BACKUP_FILE}"

# BACKUP komutu
BACKUP_SQL="BACKUP DATABASE [$DATABASE] TO DISK = N'$SQL_BACKUP_PATH' WITH FORMAT, INIT, COMPRESSION, STATS = 10"

echo "▶ BACKUP DATABASE çalışıyor..."
sqlcmd -S "$SERVER" -U "$USER" -P "$PASSWORD" -Q "$BACKUP_SQL" -b

if [ $? -eq 0 ]; then
    echo "✓ SQL Server yedeği oluşturuldu"
    
    # Docker container'dan dosya al (eğer Docker kullanılıyorsa)
    if docker ps --format '{{.Names}}' | grep -q "koafilo-db\|mssql"; then
        CONTAINER=$(docker ps --format '{{.Names}}' | grep -E "koafilo-db|mssql" | head -1)
        echo "▶ Docker container'dan dosya alınıyor: $CONTAINER"
        docker cp "${CONTAINER}:${SQL_BACKUP_PATH}" "$BACKUP_PATH"
        docker exec "$CONTAINER" rm -f "$SQL_BACKUP_PATH"
    else
        # Yerel SQL Server
        if [ -f "$SQL_BACKUP_PATH" ]; then
            mv "$SQL_BACKUP_PATH" "$BACKUP_PATH"
        else
            # Uzak sunucuda kaldı, kullanıcıyı bilgilendir
            echo "⚠ Yedek dosyası SQL Server'da: $SQL_BACKUP_PATH"
            BACKUP_PATH="$SQL_BACKUP_PATH"
        fi
    fi
    
    if [ -f "$BACKUP_PATH" ]; then
        FILE_SIZE=$(du -h "$BACKUP_PATH" | cut -f1)
    else
        FILE_SIZE="N/A"
    fi
else
    echo "✗ Yedekleme başarısız!"
    exit 1
fi

# Eski yedekleri temizle
echo ""
echo "▶ Eski yedekler temizleniyor ($RETENTION_DAYS gün öncesi)..."
DELETED=$(find "$OUTPUT_DIR" -name "mssql_*.bak" -mtime +$RETENTION_DAYS -delete -print 2>/dev/null | wc -l)
if [ "$DELETED" -gt 0 ]; then
    echo "✓ $DELETED eski yedek silindi"
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "              YEDEKLEME TAMAMLANDI!"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "  Dosya: $BACKUP_PATH"
echo "  Boyut: $FILE_SIZE"
echo ""
echo "  Geri yükleme:"
echo "  sqlcmd -S $SERVER -U $USER -Q \"RESTORE DATABASE [$DATABASE] FROM DISK = N'$BACKUP_PATH'\""
echo ""
