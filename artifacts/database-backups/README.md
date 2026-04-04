# KOA Filo Servis - Veritabanı Yedekleme Araçları

## 📦 Desteklenen Veritabanları

| Veritabanı | Script (Windows) | Script (Linux) |
|------------|------------------|----------------|
| PostgreSQL | `backup-postgresql.ps1` | `backup-postgresql.sh` |
| SQLite | `backup-sqlite.ps1` | `backup-sqlite.sh` |
| MS SQL Server | `backup-mssql.ps1` | `backup-mssql.sh` |

---

## 🚀 Hızlı Kullanım

### PostgreSQL

```powershell
# Windows
.\backup-postgresql.ps1 -Host localhost -Database koafilo -User postgres

# Linux/macOS
./backup-postgresql.sh localhost koafilo postgres
```

### SQLite

```powershell
# Windows
.\backup-sqlite.ps1 -DbPath "C:\KOAFiloServis\data\koafilo.db"

# Linux/macOS
./backup-sqlite.sh /opt/koafilo/data/koafilo.db
```

### MS SQL Server

```powershell
# Windows
.\backup-mssql.ps1 -Server localhost -Database KOAFilo -TrustedConnection

# Linux/macOS (sqlcmd gerekli)
./backup-mssql.sh localhost KOAFilo sa
```

---

## 📁 Yedekleme Formatları

| Veritabanı | Format | Açıklama |
|------------|--------|----------|
| PostgreSQL | `.sql.gz` | pg_dump + gzip sıkıştırma |
| SQLite | `.db.bak` + `.sql` | Binary kopyası + SQL dump |
| MS SQL Server | `.bak` | Native SQL Server backup |

---

## 🔄 Geri Yükleme

### PostgreSQL
```bash
gunzip -c backup_20241201_120000.sql.gz | psql -U postgres -d koafilo
```

### SQLite
```bash
# Binary geri yükleme
cp backup_20241201_120000.db.bak koafilo.db

# SQL'den geri yükleme
sqlite3 koafilo.db < backup_20241201_120000.sql
```

### MS SQL Server
```sql
RESTORE DATABASE KOAFilo FROM DISK = 'C:\Backups\backup_20241201_120000.bak'
```

---

## ⏰ Otomatik Yedekleme (Zamanlanmış Görev)

### Windows Task Scheduler
```powershell
# Her gün 03:00'da PostgreSQL yedeği
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\KOAFiloServis\backup-postgresql.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 3:00AM
Register-ScheduledTask -TaskName "KOAFilo-DailyBackup" -Action $action -Trigger $trigger
```

### Linux Cron
```bash
# Her gün 03:00'da PostgreSQL yedeği
0 3 * * * /opt/koafilo/backup-postgresql.sh localhost koafilo postgres
```

---

## 📞 Destek

- **E-posta:** support@koafiloservis.com
