using System.Diagnostics;
using System.IO.Compression;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.Data.Sqlite;
using Npgsql;
using Spectre.Console;

namespace KOABackupTool;

class Program
{
    private static string _host = "localhost";
    private static int _port = 5432;
    private static string _database = "DestekCRMServisBlazorDb";
    private static string _username = "postgres";
    private static string _password = "Fast123";
    private static string _backupFolder = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "KOA_Backups");

    private static readonly string ConfigFile = Path.Combine(
        Path.GetDirectoryName(Environment.ProcessPath) ?? AppContext.BaseDirectory, 
        "backup-settings.json");

    static async Task Main(string[] args)
    {
        Console.OutputEncoding = Encoding.UTF8;

        // Kayıtlı ayarları yükle
        LoadSettings();

        AnsiConsole.Write(new FigletText("KOA Backup").Centered().Color(Color.Blue));
        AnsiConsole.MarkupLine("[grey]PostgreSQL Yedekleme Araci v1.1[/]");
        if (File.Exists(ConfigFile))
            AnsiConsole.MarkupLine($"[grey]Ayarlar yuklendi: {_host}:{_port}/{_database}[/]");
        AnsiConsole.WriteLine();

        while (true)
        {
            var choice = AnsiConsole.Prompt(new SelectionPrompt<string>().Title("[green]Ne yapmak istiyorsunuz?[/]").PageSize(10)
                .AddChoices(new[] { "1. Yedek Al", "2. Yedek Yukle", "3. PostgreSQL -> SQLite", "4. Ayarlar", "5. Klasor Ac", "6. Listele", "7. Cikis" }));
            switch (choice[0])
            {
                case '1': await CreateBackupAsync(); break;
                case '2': await RestoreBackupAsync(); break;
                case '3': await ConvertToSqliteAsync(); break;
                case '4': ConfigureConnection(); break;
                case '5': OpenBackupFolder(); break;
                case '6': ListBackups(); break;
                case '7': return;
            }
            AnsiConsole.WriteLine();
        }
    }

    static void LoadSettings()
    {
        try
        {
            if (File.Exists(ConfigFile))
            {
                var json = File.ReadAllText(ConfigFile);
                var settings = JsonSerializer.Deserialize<BackupSettings>(json);
                if (settings != null)
                {
                    _host = settings.Host ?? _host;
                    _port = settings.Port > 0 ? settings.Port : _port;
                    _database = settings.Database ?? _database;
                    _username = settings.Username ?? _username;
                    _password = settings.Password ?? _password;
                    _backupFolder = settings.BackupFolder ?? _backupFolder;
                }
            }
        }
        catch { /* İlk çalıştırma veya bozuk dosya */ }
    }

    static void SaveSettings()
    {
        try
        {
            var settings = new BackupSettings
            {
                Host = _host,
                Port = _port,
                Database = _database,
                Username = _username,
                Password = _password,
                BackupFolder = _backupFolder
            };
            var json = JsonSerializer.Serialize(settings, new JsonSerializerOptions { WriteIndented = true });
            File.WriteAllText(ConfigFile, json);
            AnsiConsole.MarkupLine($"[green]Ayarlar kaydedildi: {ConfigFile}[/]");
        }
        catch (Exception ex)
        {
            AnsiConsole.MarkupLine($"[yellow]Ayarlar kaydedilemedi: {ex.Message}[/]");
        }
    }

    static void ConfigureConnection()
    {
        _host = AnsiConsole.Prompt(new TextPrompt<string>("[green]Host:[/]").DefaultValue(_host));
        _port = AnsiConsole.Prompt(new TextPrompt<int>("[green]Port:[/]").DefaultValue(_port));
        _database = AnsiConsole.Prompt(new TextPrompt<string>("[green]Database:[/]").DefaultValue(_database));
        _username = AnsiConsole.Prompt(new TextPrompt<string>("[green]User:[/]").DefaultValue(_username));
        _password = AnsiConsole.Prompt(new TextPrompt<string>("[green]Password:[/]").Secret('*'));
        _backupFolder = AnsiConsole.Prompt(new TextPrompt<string>("[green]Backup Folder:[/]").DefaultValue(_backupFolder));

        // Bağlantıyı test et
        try 
        { 
            using var c = new NpgsqlConnection(GetConnectionString()); 
            c.Open(); 
            AnsiConsole.MarkupLine("[green]Baglanti basarili![/]");

            // Ayarları kaydet
            SaveSettings();
        }
        catch (Exception ex) 
        { 
            AnsiConsole.MarkupLine("[red]Baglanti hatasi: " + ex.Message + "[/]"); 
        }
    }

    static string GetConnectionString() => $"Host={_host};Port={_port};Database={_database};Username={_username};Password={_password}";

    static async Task CreateBackupAsync()
    {
        if (string.IsNullOrEmpty(_password)) _password = AnsiConsole.Prompt(new TextPrompt<string>("[yellow]Password:[/]").Secret('*'));
        Directory.CreateDirectory(_backupFolder);
        var timestamp = DateTime.Now.ToString("yyyy-MM-dd_HH-mm-ss");
        var backupFile = Path.Combine(_backupFolder, $"{_database}_backup_{timestamp}.sql");
        var compressedFile = backupFile + ".gz";

        // pg_dump yolunu bul
        var pgDumpPath = FindPgDump();

        if (pgDumpPath != null)
        {
            // pg_dump ile tam yedek al
            await CreateFullDumpAsync(pgDumpPath, backupFile, compressedFile);
        }
        else
        {
            // pg_dump bulunamazsa basit yedek al
            AnsiConsole.MarkupLine("[yellow]pg_dump bulunamadi, basit yedek alinacak...[/]");
            await CreateSimpleBackupAsync(backupFile, compressedFile);
        }
    }

    static string? FindPgDump()
    {
        // Olası pg_dump konumları
        var possiblePaths = new[]
        {
            @"C:\Program Files\PostgreSQL\17\bin\pg_dump.exe",
            @"C:\Program Files\PostgreSQL\16\bin\pg_dump.exe",
            @"C:\Program Files\PostgreSQL\15\bin\pg_dump.exe",
            @"C:\Program Files\PostgreSQL\14\bin\pg_dump.exe",
            @"C:\Program Files (x86)\PostgreSQL\17\bin\pg_dump.exe",
            @"C:\Program Files (x86)\PostgreSQL\16\bin\pg_dump.exe",
            "pg_dump.exe", // PATH'te varsa
            "pg_dump"
        };

        foreach (var path in possiblePaths)
        {
            if (File.Exists(path)) return path;
        }

        // PATH'te ara
        try
        {
            var result = System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo
            {
                FileName = "where",
                Arguments = "pg_dump",
                RedirectStandardOutput = true,
                UseShellExecute = false,
                CreateNoWindow = true
            });
            result?.WaitForExit();
            var output = result?.StandardOutput.ReadToEnd()?.Trim();
            if (!string.IsNullOrEmpty(output) && File.Exists(output.Split('\n')[0]))
                return output.Split('\n')[0].Trim();
        }
        catch { }

        return null;
    }

    static async Task CreateFullDumpAsync(string pgDumpPath, string backupFile, string compressedFile)
    {
        try
        {
            await AnsiConsole.Status().Spinner(Spinner.Known.Dots).StartAsync("pg_dump ile tam yedek aliniyor...", async ctx =>
            {
                var psi = new System.Diagnostics.ProcessStartInfo
                {
                    FileName = pgDumpPath,
                    Arguments = $"-h {_host} -p {_port} -U {_username} -d {_database} -F p -b -v --no-owner --no-acl -f \"{backupFile}\"",
                    RedirectStandardError = true,
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };
                psi.Environment["PGPASSWORD"] = _password;

                using var process = System.Diagnostics.Process.Start(psi);
                if (process == null) throw new Exception("pg_dump baslatilamadi");

                var errorTask = process.StandardError.ReadToEndAsync();
                await process.WaitForExitAsync();

                if (process.ExitCode != 0)
                {
                    var error = await errorTask;
                    throw new Exception($"pg_dump hatasi: {error}");
                }

                ctx.Status("Sikistiriliyor...");

                // Gzip sıkıştır
                await using (var fs = File.OpenRead(backupFile))
                await using (var cs = File.Create(compressedFile))
                await using (var gz = new GZipStream(cs, CompressionLevel.Optimal))
                    await fs.CopyToAsync(gz);

                File.Delete(backupFile);
            });

            var fileInfo = new FileInfo(compressedFile);
            AnsiConsole.MarkupLine($"[green]Tam yedek olusturuldu: {compressedFile}[/]");
            AnsiConsole.MarkupLine($"[grey]Boyut: {FormatSize(fileInfo.Length)}[/]");
        }
        catch (Exception ex) 
        { 
            AnsiConsole.MarkupLine($"[red]pg_dump hatasi: {ex.Message}[/]");
            AnsiConsole.MarkupLine("[yellow]Basit yedek deneniyor...[/]");
            await CreateSimpleBackupAsync(backupFile, compressedFile);
        }
    }

    static async Task CreateSimpleBackupAsync(string backupFile, string compressedFile)
    {
        try
        {
            await AnsiConsole.Progress().StartAsync(async ctx => {
                var task = ctx.AddTask("[green]Yedekleniyor[/]");
                using var conn = new NpgsqlConnection(GetConnectionString());
                await conn.OpenAsync();
                task.Increment(5);

                var sb = new StringBuilder();
                sb.AppendLine("-- KOA Filo Servis PostgreSQL Backup");
                sb.AppendLine("-- Database: " + _database);
                sb.AppendLine("-- Date: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                sb.AppendLine("-- Tool: KOABackupTool v1.0");
                sb.AppendLine();
                sb.AppendLine("SET client_encoding = 'UTF8';");
                sb.AppendLine();

                // Önce __EFMigrationsHistory tablosunu oluştur ve yedekle
                sb.AppendLine("-- EF Core Migrations History");
                sb.AppendLine(@"CREATE TABLE IF NOT EXISTS ""__EFMigrationsHistory"" (
    ""MigrationId"" character varying(150) NOT NULL,
    ""ProductVersion"" character varying(32) NOT NULL,
    CONSTRAINT ""PK___EFMigrationsHistory"" PRIMARY KEY (""MigrationId"")
);");
                sb.AppendLine();

                // Migration verilerini yedekle
                using (var cmd = new NpgsqlCommand("SELECT \"MigrationId\", \"ProductVersion\" FROM \"__EFMigrationsHistory\" ORDER BY \"MigrationId\"", conn))
                {
                    try
                    {
                        using var r = await cmd.ExecuteReaderAsync();
                        while (await r.ReadAsync())
                        {
                            sb.AppendLine($"INSERT INTO \"__EFMigrationsHistory\" (\"MigrationId\", \"ProductVersion\") VALUES ('{r.GetString(0)}', '{r.GetString(1)}') ON CONFLICT DO NOTHING;");
                        }
                    }
                    catch { /* Tablo yoksa devam et */ }
                }
                sb.AppendLine();
                task.Increment(5);

                // Diğer tabloları listele (__EFMigrationsHistory hariç)
                var tables = new List<string>();
                using (var cmd = new NpgsqlCommand("SELECT tablename FROM pg_tables WHERE schemaname='public' AND tablename != '__EFMigrationsHistory' ORDER BY tablename", conn))
                using (var r = await cmd.ExecuteReaderAsync()) while (await r.ReadAsync()) tables.Add(r.GetString(0));
                task.Increment(10);

                foreach (var table in tables)
                {
                    sb.AppendLine($"-- Table: {table}");
                    sb.AppendLine($"DROP TABLE IF EXISTS \"{table}\" CASCADE;");
                    using (var cmd = new NpgsqlCommand($"SELECT 'CREATE TABLE \"{table}\" (' || string_agg('\"' || a.attname || '\" ' || pg_catalog.format_type(a.atttypid, a.atttypmod), ', ' ORDER BY a.attnum) || ')' FROM pg_attribute a WHERE a.attrelid = '{table}'::regclass AND a.attnum > 0 AND NOT a.attisdropped", conn))
                    {
                        var createStmt = await cmd.ExecuteScalarAsync();
                        if (createStmt != null) sb.AppendLine(createStmt.ToString() + ";");
                    }
                    using (var cmd = new NpgsqlCommand($"SELECT * FROM \"{table}\"", conn))
                    using (var r = await cmd.ExecuteReaderAsync())
                    {
                        var cols = Enumerable.Range(0, r.FieldCount).Select(i => $"\"{r.GetName(i)}\"").ToList();
                        while (await r.ReadAsync())
                        {
                            var vals = Enumerable.Range(0, r.FieldCount).Select(i => r.IsDBNull(i) ? "NULL" : FormatValue(r.GetValue(i))).ToList();
                            sb.AppendLine($"INSERT INTO \"{table}\" ({string.Join(",", cols)}) VALUES ({string.Join(",", vals)});");
                        }
                    }
                    sb.AppendLine();
                    task.Increment(70.0 / tables.Count);
                }

                await File.WriteAllTextAsync(backupFile, sb.ToString());
                await using (var fs = File.OpenRead(backupFile))
                await using (var cs = File.Create(compressedFile))
                await using (var gz = new GZipStream(cs, CompressionLevel.Optimal))
                    await fs.CopyToAsync(gz);
                File.Delete(backupFile);
                task.Increment(10);
            });
            AnsiConsole.MarkupLine("[green]Yedek olusturuldu: " + compressedFile + "[/]");
        }
        catch (Exception ex) { AnsiConsole.MarkupLine("[red]" + ex.Message + "[/]"); }
    }

    static async Task EnsureDatabaseExistsAsync()
    {
        // postgres veritabanına bağlan ve hedef veritabanını kontrol et/oluştur
        var masterConnStr = $"Host={_host};Port={_port};Database=postgres;Username={_username};Password={_password}";

        try
        {
            using var conn = new NpgsqlConnection(masterConnStr);
            await conn.OpenAsync();

            // Veritabanı var mı kontrol et
            using var checkCmd = new NpgsqlCommand($"SELECT 1 FROM pg_database WHERE datname = '{_database}'", conn);
            var exists = await checkCmd.ExecuteScalarAsync();

            if (exists == null)
            {
                AnsiConsole.MarkupLine($"[yellow]Veritabani '{_database}' bulunamadi, olusturuluyor...[/]");
                using var createCmd = new NpgsqlCommand($"CREATE DATABASE \"{_database}\" ENCODING 'UTF8'", conn);
                await createCmd.ExecuteNonQueryAsync();
                AnsiConsole.MarkupLine($"[green]Veritabani '{_database}' olusturuldu![/]");
            }
        }
        catch (Exception ex)
        {
            AnsiConsole.MarkupLine($"[red]Veritabani kontrol hatasi: {ex.Message}[/]");
            throw;
        }
    }

    static async Task EnsureMigrationTableExistsAsync(NpgsqlConnection conn)
    {
        // EF Core migration tablosunu oluştur
        var createTableSql = @"
            CREATE TABLE IF NOT EXISTS ""__EFMigrationsHistory"" (
                ""MigrationId"" character varying(150) NOT NULL,
                ""ProductVersion"" character varying(32) NOT NULL,
                CONSTRAINT ""PK___EFMigrationsHistory"" PRIMARY KEY (""MigrationId"")
            );";

        using var cmd = new NpgsqlCommand(createTableSql, conn);
        await cmd.ExecuteNonQueryAsync();
    }

    static async Task RestoreBackupAsync()
    {
        if (!Directory.Exists(_backupFolder)) { AnsiConsole.MarkupLine("[red]Klasor yok[/]"); return; }
        var files = Directory.GetFiles(_backupFolder, "*.sql.gz").Concat(Directory.GetFiles(_backupFolder, "*.sql")).OrderByDescending(File.GetCreationTime).ToList();
        if (!files.Any()) { AnsiConsole.MarkupLine("[yellow]Yedek yok[/]"); return; }

        var sel = AnsiConsole.Prompt(new SelectionPrompt<string>().Title("[green]Sec:[/]").AddChoices(files.Select(Path.GetFileName).Append("Geri")));
        if (sel == "Geri") return;
        var file = files.First(f => Path.GetFileName(f) == sel);
        if (!AnsiConsole.Confirm("Devam?", false)) return;
        if (string.IsNullOrEmpty(_password)) _password = AnsiConsole.Prompt(new TextPrompt<string>("[yellow]Password:[/]").Secret('*'));

        // Veritabanı yoksa oluştur
        await EnsureDatabaseExistsAsync();

        // psql yolunu bul ve kullan
        var psqlPath = FindPsql();
        if (psqlPath != null)
        {
            await RestoreWithPsqlAsync(psqlPath, file);
        }
        else
        {
            await RestoreWithNpgsqlAsync(file);
        }
    }

    static string? FindPsql()
    {
        var possiblePaths = new[]
        {
            @"C:\Program Files\PostgreSQL\17\bin\psql.exe",
            @"C:\Program Files\PostgreSQL\16\bin\psql.exe",
            @"C:\Program Files\PostgreSQL\15\bin\psql.exe",
            @"C:\Program Files\PostgreSQL\14\bin\psql.exe",
            "psql.exe",
            "psql"
        };

        foreach (var path in possiblePaths)
        {
            if (File.Exists(path)) return path;
        }
        return null;
    }

    static async Task RestoreWithPsqlAsync(string psqlPath, string file)
    {
        try
        {
            await AnsiConsole.Status().Spinner(Spinner.Known.Dots).StartAsync("psql ile geri yukleniyor...", async ctx =>
            {
                // Önce gz dosyasını aç
                string sqlFile = file;
                bool tempFile = false;

                if (file.EndsWith(".gz"))
                {
                    ctx.Status("Dosya aciliyor...");
                    sqlFile = Path.GetTempFileName();
                    tempFile = true;
                    await using var fs = File.OpenRead(file);
                    await using var gz = new GZipStream(fs, CompressionMode.Decompress);
                    await using var output = File.Create(sqlFile);
                    await gz.CopyToAsync(output);
                }

                ctx.Status("Veritabani hazirlaniyor...");

                // Önce mevcut tabloları sil
                var dropPsi = new System.Diagnostics.ProcessStartInfo
                {
                    FileName = psqlPath,
                    Arguments = $"-h {_host} -p {_port} -U {_username} -d {_database} -c \"DO $$ DECLARE r RECORD; BEGIN FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP EXECUTE 'DROP TABLE IF EXISTS \\\"' || r.tablename || '\\\" CASCADE'; END LOOP; END $$;\"",
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };
                dropPsi.Environment["PGPASSWORD"] = _password;

                using (var dropProcess = System.Diagnostics.Process.Start(dropPsi))
                {
                    if (dropProcess != null) await dropProcess.WaitForExitAsync();
                }

                ctx.Status("SQL yukleniyor...");

                var psi = new System.Diagnostics.ProcessStartInfo
                {
                    FileName = psqlPath,
                    Arguments = $"-h {_host} -p {_port} -U {_username} -d {_database} -f \"{sqlFile}\" -v ON_ERROR_STOP=0",
                    RedirectStandardError = true,
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };
                psi.Environment["PGPASSWORD"] = _password;

                using var process = System.Diagnostics.Process.Start(psi);
                if (process == null) throw new Exception("psql baslatilamadi");

                await process.WaitForExitAsync();

                if (tempFile && File.Exists(sqlFile))
                    File.Delete(sqlFile);
            });

            AnsiConsole.MarkupLine("[green]Yedek basariyla yuklendi![/]");
        }
        catch (Exception ex)
        {
            AnsiConsole.MarkupLine($"[red]psql hatasi: {ex.Message}[/]");
            AnsiConsole.MarkupLine("[yellow]Alternatif yontem deneniyor...[/]");
            await RestoreWithNpgsqlAsync(file);
        }
    }

    static async Task RestoreWithNpgsqlAsync(string file)
    {
        try
        {
            string sql;
            if (file.EndsWith(".gz")) { await using var fs = File.OpenRead(file); await using var gz = new GZipStream(fs, CompressionMode.Decompress); using var sr = new StreamReader(gz); sql = await sr.ReadToEndAsync(); }
            else sql = await File.ReadAllTextAsync(file);

            using var conn = new NpgsqlConnection(GetConnectionString());
            await conn.OpenAsync();

            // Migration tablosunu oluştur
            await EnsureMigrationTableExistsAsync(conn);

            // Önce mevcut tabloları sil (foreign key sorunlarını önlemek için)
            AnsiConsole.MarkupLine("[grey]Mevcut tablolar siliniyor...[/]");
            using (var dropCmd = new NpgsqlCommand(@"
                DO $$ DECLARE r RECORD;
                BEGIN
                    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename != '__EFMigrationsHistory') LOOP
                        EXECUTE 'DROP TABLE IF EXISTS ""' || r.tablename || '"" CASCADE';
                    END LOOP;
                END $$;", conn))
            {
                await dropCmd.ExecuteNonQueryAsync();
            }

            AnsiConsole.MarkupLine("[grey]SQL komutlari calistiriliyor...[/]");

            // Foreign key kontrollerini devre dışı bırak
            using (var fkCmd = new NpgsqlCommand("SET session_replication_role = 'replica';", conn))
                await fkCmd.ExecuteNonQueryAsync();

            var statements = sql.Split(';').Where(s => !string.IsNullOrWhiteSpace(s) && !s.TrimStart().StartsWith("--")).ToList();
            int success = 0, failed = 0;
            var errors = new List<string>();

            foreach (var stmt in statements)
            {
                try 
                { 
                    using var cmd = new NpgsqlCommand(stmt.Trim(), conn); 
                    await cmd.ExecuteNonQueryAsync();
                    success++;
                } 
                catch (Exception ex) 
                { 
                    failed++;
                    if (errors.Count < 5) errors.Add(ex.Message.Split('\n')[0]);
                }
            }

            // Foreign key kontrollerini tekrar etkinleştir
            using (var fkCmd = new NpgsqlCommand("SET session_replication_role = 'origin';", conn))
                await fkCmd.ExecuteNonQueryAsync();

            AnsiConsole.MarkupLine($"[green]Yuklendi! ({success} basarili, {failed} atlandi)[/]");
            if (errors.Any())
            {
                AnsiConsole.MarkupLine("[yellow]Bazi hatalar:[/]");
                foreach (var e in errors) AnsiConsole.MarkupLine($"[grey]  - {e}[/]");
            }
        }
        catch (Exception ex) { AnsiConsole.MarkupLine("[red]" + ex.Message + "[/]"); }
    }

    static void OpenBackupFolder() { Directory.CreateDirectory(_backupFolder); System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo { FileName = _backupFolder, UseShellExecute = true }); }
    
    static void ListBackups()
    {
        if (!Directory.Exists(_backupFolder)) { AnsiConsole.MarkupLine("[yellow]Klasor yok[/]"); return; }
        var files = Directory.GetFiles(_backupFolder, "*.sql*").Select(f => new FileInfo(f)).OrderByDescending(f => f.CreationTime);
        var table = new Table().AddColumn("Dosya").AddColumn("Boyut").AddColumn("Tarih");
        foreach (var f in files) table.AddRow(f.Name, FormatSize(f.Length), f.CreationTime.ToString("dd.MM.yyyy HH:mm"));
        AnsiConsole.Write(table);
    }

    static string FormatValue(object v) => v switch { string s => $"'{s.Replace("'", "''")}'", DateTime d => $"'{d:yyyy-MM-dd HH:mm:ss}'", bool b => b ? "TRUE" : "FALSE", _ => v?.ToString() ?? "NULL" };
    static string FormatSize(long b) { var s = new[] { "B", "KB", "MB", "GB" }; var i = 0; double d = b; while (d >= 1024 && i < 3) { d /= 1024; i++; } return $"{d:0.#} {s[i]}"; }

    #region PostgreSQL -> SQLite Dönüştürme

    static async Task ConvertToSqliteAsync()
    {
        if (!Directory.Exists(_backupFolder)) { AnsiConsole.MarkupLine("[red]Yedek klasoru yok[/]"); return; }

        var files = Directory.GetFiles(_backupFolder, "*.sql.gz")
            .Concat(Directory.GetFiles(_backupFolder, "*.sql"))
            .OrderByDescending(File.GetCreationTime).ToList();

        if (!files.Any()) { AnsiConsole.MarkupLine("[yellow]Yedek dosyasi yok[/]"); return; }

        var sel = AnsiConsole.Prompt(new SelectionPrompt<string>()
            .Title("[green]Donusturulecek PostgreSQL yedegini secin:[/]")
            .AddChoices(files.Select(Path.GetFileName).Append("Geri")!));

        if (sel == "Geri") return;

        var sourceFile = files.First(f => Path.GetFileName(f) == sel);
        var sqliteFile = Path.Combine(_backupFolder, 
            Path.GetFileNameWithoutExtension(sourceFile).Replace(".sql", "") + "_sqlite.db");

        if (File.Exists(sqliteFile))
        {
            if (!AnsiConsole.Confirm($"[yellow]{Path.GetFileName(sqliteFile)} zaten var. Uzerine yazilsin mi?[/]", false))
                return;
            File.Delete(sqliteFile);
        }

        try
        {
            await AnsiConsole.Progress().StartAsync(async ctx =>
            {
                var task = ctx.AddTask("[green]PostgreSQL -> SQLite donusturuluyor[/]", maxValue: 100);

                // 1. SQL dosyasını oku
                task.Description = "[grey]Yedek dosyasi okunuyor...[/]";
                string sql;
                if (sourceFile.EndsWith(".gz"))
                {
                    await using var fs = File.OpenRead(sourceFile);
                    await using var gz = new GZipStream(fs, CompressionMode.Decompress);
                    using var sr = new StreamReader(gz);
                    sql = await sr.ReadToEndAsync();
                }
                else
                {
                    sql = await File.ReadAllTextAsync(sourceFile);
                }
                task.Increment(10);

                // 2. SQLite veritabanı oluştur
                task.Description = "[grey]SQLite veritabani olusturuluyor...[/]";
                await using var conn = new SqliteConnection($"Data Source={sqliteFile}");
                await conn.OpenAsync();
                task.Increment(5);

                // 3. SQL'i ayrıştır ve tablolara böl
                task.Description = "[grey]SQL ifadeleri ayristiriliyor...[/]";
                var tableData = ParsePostgreSqlDump(sql);
                task.Increment(10);

                // 4. Migration tablosunu oluştur
                await CreateSqliteMigrationTableAsync(conn);
                task.Increment(5);

                // 5. Her tablo için dönüştürme yap
                var increment = 60.0 / Math.Max(tableData.Count, 1);
                int successTables = 0, failedTables = 0;
                var errors = new List<string>();

                foreach (var (tableName, tableInfo) in tableData)
                {
                    task.Description = $"[grey]Tablo: {tableName}[/]";
                    try
                    {
                        await ConvertTableToSqliteAsync(conn, tableName, tableInfo);
                        successTables++;
                    }
                    catch (Exception ex)
                    {
                        failedTables++;
                        if (errors.Count < 10) errors.Add($"{tableName}: {ex.Message.Split('\n')[0]}");
                    }
                    task.Increment(increment);
                }

                task.Increment(10);
                task.Description = "[green]Tamamlandi![/]";

                AnsiConsole.MarkupLine($"\n[green]SQLite veritabani olusturuldu: {sqliteFile}[/]");
                AnsiConsole.MarkupLine($"[grey]Tablolar: {successTables} basarili, {failedTables} hatali[/]");

                if (errors.Any())
                {
                    AnsiConsole.MarkupLine("[yellow]Hatalar:[/]");
                    foreach (var e in errors) AnsiConsole.MarkupLine($"[grey]  - {e}[/]");
                }

                var fileInfo = new FileInfo(sqliteFile);
                AnsiConsole.MarkupLine($"[grey]Boyut: {FormatSize(fileInfo.Length)}[/]");
            });
        }
        catch (Exception ex)
        {
            AnsiConsole.MarkupLine($"[red]Donusturme hatasi: {ex.Message}[/]");
        }
    }

    static Dictionary<string, TableInfo> ParsePostgreSqlDump(string sql)
    {
        var tables = new Dictionary<string, TableInfo>(StringComparer.OrdinalIgnoreCase);
        var lines = sql.Split('\n');

        string? currentTable = null;
        var createBuffer = new StringBuilder();
        bool inCreateTable = false;

        foreach (var rawLine in lines)
        {
            var line = rawLine.Trim();
            if (string.IsNullOrEmpty(line) || line.StartsWith("--")) continue;

            // CREATE TABLE tespit
            var createMatch = Regex.Match(line, @"CREATE TABLE\s+(?:IF NOT EXISTS\s+)?""?(\w+)""?\s*\(", RegexOptions.IgnoreCase);
            if (createMatch.Success)
            {
                currentTable = createMatch.Groups[1].Value;
                if (!tables.ContainsKey(currentTable))
                    tables[currentTable] = new TableInfo();
                inCreateTable = true;
                createBuffer.Clear();
                createBuffer.AppendLine(line);
                continue;
            }

            // CREATE TABLE devam
            if (inCreateTable && currentTable != null)
            {
                createBuffer.AppendLine(line);
                if (line.Contains(");") || (line.EndsWith(")") && !line.Contains("(")))
                {
                    tables[currentTable].CreateStatement = createBuffer.ToString();
                    inCreateTable = false;
                }
                continue;
            }

            // INSERT INTO tespit
            var insertMatch = Regex.Match(line, @"INSERT INTO\s+""?(\w+)""?\s*\(", RegexOptions.IgnoreCase);
            if (insertMatch.Success)
            {
                var tableName = insertMatch.Groups[1].Value;
                if (!tables.ContainsKey(tableName))
                    tables[tableName] = new TableInfo();
                tables[tableName].InsertStatements.Add(line);
            }
        }

        return tables;
    }

    static async Task CreateSqliteMigrationTableAsync(SqliteConnection conn)
    {
        var sql = @"CREATE TABLE IF NOT EXISTS ""__EFMigrationsHistory"" (
            ""MigrationId"" TEXT NOT NULL PRIMARY KEY,
            ""ProductVersion"" TEXT NOT NULL
        );";
        await using var cmd = new SqliteCommand(sql, conn);
        await cmd.ExecuteNonQueryAsync();
    }

    static async Task ConvertTableToSqliteAsync(SqliteConnection conn, string tableName, TableInfo tableInfo)
    {
        // 1. CREATE TABLE'ı SQLite formatına çevir
        if (!string.IsNullOrEmpty(tableInfo.CreateStatement))
        {
            var sqliteCreate = ConvertCreateTableToSqlite(tableName, tableInfo.CreateStatement);
            try
            {
                await using var createCmd = new SqliteCommand(sqliteCreate, conn);
                await createCmd.ExecuteNonQueryAsync();
            }
            catch (SqliteException ex) when (ex.SqliteErrorCode == 1) // Table exists
            {
                // Tablo zaten var, devam et
            }
        }

        // 2. INSERT'leri çevir ve çalıştır
        if (tableInfo.InsertStatements.Any())
        {
            await using var transaction = await conn.BeginTransactionAsync();
            try
            {
                foreach (var insert in tableInfo.InsertStatements)
                {
                    var sqliteInsert = ConvertInsertToSqlite(insert);
                    try
                    {
                        await using var insertCmd = new SqliteCommand(sqliteInsert, conn, (SqliteTransaction)transaction);
                        await insertCmd.ExecuteNonQueryAsync();
                    }
                    catch { /* Tek satır hatası, devam et */ }
                }
                await transaction.CommitAsync();
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }
    }

    static string ConvertCreateTableToSqlite(string tableName, string pgCreate)
    {
        var result = pgCreate;

        // DROP TABLE ekle
        var dropTable = $"DROP TABLE IF EXISTS \"{tableName}\";\n";

        // PostgreSQL -> SQLite veri tipi dönüşümleri
        result = Regex.Replace(result, @"\bSERIAL\b", "INTEGER", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bBIGSERIAL\b", "INTEGER", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bSMALLSERIAL\b", "INTEGER", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bcharacter varying\s*\(\d+\)", "TEXT", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bVARCHAR\s*\(\d+\)", "TEXT", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bCHAR\s*\(\d+\)", "TEXT", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bTEXT\b", "TEXT", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bTIMESTAMP\s*(WITHOUT TIME ZONE|WITH TIME ZONE)?\b", "TEXT", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bTIMESTAMPTZ\b", "TEXT", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bDATE\b", "TEXT", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bTIME\s*(WITHOUT TIME ZONE|WITH TIME ZONE)?\b", "TEXT", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bBOOLEAN\b", "INTEGER", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bBYTEA\b", "BLOB", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bUUID\b", "TEXT", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bJSON\b", "TEXT", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bJSONB\b", "TEXT", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bINTEGER\b", "INTEGER", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bBIGINT\b", "INTEGER", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bSMALLINT\b", "INTEGER", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bDOUBLE PRECISION\b", "REAL", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bREAL\b", "REAL", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bNUMERIC\s*(\(\d+(,\s*\d+)?\))?", "REAL", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bDECIMAL\s*(\(\d+(,\s*\d+)?\))?", "REAL", RegexOptions.IgnoreCase);

        // PostgreSQL spesifik ifadeleri kaldır
        result = Regex.Replace(result, @"\bDEFAULT\s+nextval\([^)]+\)", "", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bDEFAULT\s+now\(\)", "DEFAULT CURRENT_TIMESTAMP", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bDEFAULT\s+CURRENT_TIMESTAMP", "DEFAULT CURRENT_TIMESTAMP", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bDEFAULT\s+'[^']*'::[\w\s]+", match => 
        {
            var val = Regex.Match(match.Value, @"'[^']*'").Value;
            return $"DEFAULT {val}";
        }, RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"::\w+(\[\])?", "", RegexOptions.IgnoreCase); // Type casts

        // CONSTRAINT isimlerini koru ama formatı düzelt
        result = Regex.Replace(result, @"CONSTRAINT\s+""(\w+)""\s+PRIMARY KEY", "PRIMARY KEY", RegexOptions.IgnoreCase);

        // ON CONFLICT, DEFERRABLE vb. kaldır
        result = Regex.Replace(result, @"\bON CONFLICT[^,)]*", "", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bDEFERRABLE[^,)]*", "", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bINITIALLY[^,)]*", "", RegexOptions.IgnoreCase);

        // Boş satırları ve fazla virgülleri temizle
        result = Regex.Replace(result, @",\s*,", ",");
        result = Regex.Replace(result, @",\s*\)", ")");

        return dropTable + result;
    }

    static string ConvertInsertToSqlite(string pgInsert)
    {
        var result = pgInsert;

        // TRUE/FALSE -> 1/0
        result = Regex.Replace(result, @"\bTRUE\b", "1", RegexOptions.IgnoreCase);
        result = Regex.Replace(result, @"\bFALSE\b", "0", RegexOptions.IgnoreCase);

        // Type casts kaldır
        result = Regex.Replace(result, @"::\w+(\[\])?", "", RegexOptions.IgnoreCase);

        // ON CONFLICT kaldır
        result = Regex.Replace(result, @"\bON CONFLICT[^;]*", "", RegexOptions.IgnoreCase);

        // E'...' escape syntax -> normal string
        result = Regex.Replace(result, @"E'([^']*)'", "'$1'");

        return result.TrimEnd(';') + ";";
    }

    #endregion
}

class TableInfo
{
    public string? CreateStatement { get; set; }
    public List<string> InsertStatements { get; } = new();
}

class BackupSettings
{
    public string? Host { get; set; }
    public int Port { get; set; }
    public string? Database { get; set; }
    public string? Username { get; set; }
    public string? Password { get; set; }
    public string? BackupFolder { get; set; }
}
