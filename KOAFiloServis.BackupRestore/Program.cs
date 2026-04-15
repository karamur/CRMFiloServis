using System.Diagnostics;
using System.IO.Compression;
using System.Text.Json;
using Spectre.Console;

namespace KOAFiloServis.BackupRestore;

/// <summary>
/// KOA Filo Servis - PostgreSQL Yedek Geri Yükleme Aracı
/// </summary>
class Program
{
    private static readonly string AppTitle = "KOA Filo Servis - PostgreSQL Yedek Geri Yükleme";

    static async Task<int> Main(string[] args)
    {
        Console.OutputEncoding = System.Text.Encoding.UTF8;
        Console.Title = AppTitle;

        AnsiConsole.Write(new FigletText("KOA Filo Servis").Color(Color.Blue));
        AnsiConsole.MarkupLine("[bold cyan]PostgreSQL Yedek Geri Yükleme Aracı[/]");
        AnsiConsole.MarkupLine("[dim]Versiyon 1.0.0[/]");
        AnsiConsole.WriteLine();

        try
        {
            // Menü göster
            var choice = AnsiConsole.Prompt(
                new SelectionPrompt<string>()
                    .Title("[yellow]Ne yapmak istiyorsunuz?[/]")
                    .AddChoices(new[]
                    {
                        "🔄 Yedekten Geri Yükle",
                        "📦 Yeni Yedek Al",
                        "🔍 Yedek Dosyasını Kontrol Et",
                        "⚙️ PostgreSQL Bağlantı Testi",
                        "❌ Çıkış"
                    }));

            return choice switch
            {
                "🔄 Yedekten Geri Yükle" => await RestoreBackupAsync(),
                "📦 Yeni Yedek Al" => await CreateBackupAsync(),
                "🔍 Yedek Dosyasını Kontrol Et" => await InspectBackupAsync(),
                "⚙️ PostgreSQL Bağlantı Testi" => await TestConnectionAsync(),
                _ => 0
            };
        }
        catch (Exception ex)
        {
            AnsiConsole.WriteException(ex);
            return 1;
        }
        finally
        {
            AnsiConsole.WriteLine();
            AnsiConsole.MarkupLine("[dim]Çıkmak için bir tuşa basın...[/]");
            Console.ReadKey(true);
        }
    }

    /// <summary>
    /// Yedekten geri yükleme işlemi
    /// </summary>
    static async Task<int> RestoreBackupAsync()
    {
        AnsiConsole.MarkupLine("\n[bold green]== Yedekten Geri Yükleme ==[/]\n");

        // Yedek dosyası seç
        var backupPath = AnsiConsole.Ask<string>("[yellow]Yedek dosyası yolu (.sql veya .zip):[/]");

        if (!File.Exists(backupPath))
        {
            AnsiConsole.MarkupLine("[red]HATA: Dosya bulunamadı![/]");
            return 1;
        }

        string sqlFilePath = backupPath;
        string? tempDir = null;
        DbSettings? dbSettings = null;

        // ZIP dosyasıysa aç
        if (backupPath.EndsWith(".zip", StringComparison.OrdinalIgnoreCase))
        {
            tempDir = Path.Combine(Path.GetTempPath(), $"koa_restore_{Guid.NewGuid():N}");
            Directory.CreateDirectory(tempDir);

            await AnsiConsole.Status()
                .StartAsync("ZIP dosyası açılıyor...", async ctx =>
                {
                    await Task.Run(() => ZipFile.ExtractToDirectory(backupPath, tempDir, true));
                });

            sqlFilePath = Directory.GetFiles(tempDir, "*.sql").FirstOrDefault()
                ?? throw new FileNotFoundException("ZIP içinde .sql dosyası bulunamadı!");

            var settingsFile = Path.Combine(tempDir, "dbsettings.json");
            if (File.Exists(settingsFile))
            {
                var json = await File.ReadAllTextAsync(settingsFile);
                dbSettings = JsonSerializer.Deserialize<DbSettings>(json);
                AnsiConsole.MarkupLine($"[green]✓[/] dbsettings.json bulundu: [cyan]{dbSettings?.DatabaseName}[/]");
            }
        }

        // Bağlantı bilgileri al
        dbSettings ??= await GetConnectionDetailsAsync();

        // psql yolunu bul
        var psqlPath = FindPostgresTool("psql");
        if (psqlPath == null)
        {
            AnsiConsole.MarkupLine("[red]HATA: psql bulunamadı! PostgreSQL kurulu olduğundan emin olun.[/]");
            return 1;
        }

        // Onay al
        var table = new Table().Border(TableBorder.Rounded);
        table.AddColumn("[yellow]Parametre[/]");
        table.AddColumn("[cyan]Değer[/]");
        table.AddRow("Host", dbSettings.Host ?? "localhost");
        table.AddRow("Port", dbSettings.Port.ToString());
        table.AddRow("Database", dbSettings.DatabaseName ?? "-");
        table.AddRow("User", dbSettings.Username ?? "postgres");
        table.AddRow("SQL Dosyası", Path.GetFileName(sqlFilePath));
        table.AddRow("Dosya Boyutu", new FileInfo(sqlFilePath).Length.ToString("N0") + " bytes");
        AnsiConsole.Write(table);

        if (!AnsiConsole.Confirm("\n[yellow]Bu ayarlarla geri yükleme yapılsın mı?[/]"))
        {
            AnsiConsole.MarkupLine("[dim]İptal edildi.[/]");
            return 0;
        }

        // Veritabanını yeniden oluştur seçeneği
        var dropAndCreate = AnsiConsole.Confirm("[yellow]Mevcut veritabanı silinip yeniden oluşturulsun mu?[/]", false);

        // Geri yükleme işlemi
        return await AnsiConsole.Progress()
            .StartAsync(async ctx =>
            {
                var task = ctx.AddTask("[green]Geri yükleniyor...[/]", maxValue: 100);

                Environment.SetEnvironmentVariable("PGPASSWORD", dbSettings.Password);
                try
                {
                    if (dropAndCreate)
                    {
                        task.Description = "[yellow]Veritabanı siliniyor...[/]";
                        await RunPsqlCommandAsync(psqlPath, dbSettings, $"DROP DATABASE IF EXISTS \"{dbSettings.DatabaseName}\";", "postgres");
                        task.Increment(20);

                        task.Description = "[yellow]Veritabanı oluşturuluyor...[/]";
                        await RunPsqlCommandAsync(psqlPath, dbSettings, $"CREATE DATABASE \"{dbSettings.DatabaseName}\" ENCODING 'UTF8';", "postgres");
                        task.Increment(20);
                    }
                    else
                    {
                        task.Increment(40);
                    }

                    task.Description = "[green]SQL dosyası yükleniyor...[/]";

                    var psi = new ProcessStartInfo
                    {
                        FileName = psqlPath,
                        Arguments = $"-h {dbSettings.Host} -p {dbSettings.Port} -U {dbSettings.Username} -d {dbSettings.DatabaseName} -f \"{sqlFilePath}\" -q",
                        UseShellExecute = false,
                        RedirectStandardOutput = true,
                        RedirectStandardError = true,
                        CreateNoWindow = true
                    };

                    using var process = Process.Start(psi);
                    if (process == null) throw new Exception("psql başlatılamadı!");

                    await process.WaitForExitAsync();
                    task.Increment(40);

                    if (process.ExitCode != 0)
                    {
                        var error = await process.StandardError.ReadToEndAsync();
                        AnsiConsole.MarkupLine($"[red]HATA: {error}[/]");
                        return 1;
                    }

                    task.Description = "[green]Tamamlandı![/]";
                    task.Value = 100;

                    AnsiConsole.MarkupLine("\n[bold green]✓ Yedek başarıyla geri yüklendi![/]");
                    return 0;
                }
                finally
                {
                    Environment.SetEnvironmentVariable("PGPASSWORD", null);
                    if (tempDir != null && Directory.Exists(tempDir))
                    {
                        Directory.Delete(tempDir, true);
                    }
                }
            });
    }

    /// <summary>
    /// Yeni yedek alma işlemi
    /// </summary>
    static async Task<int> CreateBackupAsync()
    {
        AnsiConsole.MarkupLine("\n[bold green]== Yeni Yedek Al ==[/]\n");

        var dbSettings = await GetConnectionDetailsAsync();

        var pgDumpPath = FindPostgresTool("pg_dump");
        if (pgDumpPath == null)
        {
            AnsiConsole.MarkupLine("[red]HATA: pg_dump bulunamadı![/]");
            return 1;
        }

        var timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
        var defaultPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop),
            $"KOAFiloServis_Backup_{timestamp}");

        var outputPath = AnsiConsole.Ask("[yellow]Yedek klasör yolu:[/]", defaultPath);
        Directory.CreateDirectory(outputPath);

        var sqlFile = Path.Combine(outputPath, "database.sql");

        return await AnsiConsole.Status()
            .StartAsync("Yedek alınıyor...", async ctx =>
            {
                Environment.SetEnvironmentVariable("PGPASSWORD", dbSettings.Password);
                try
                {
                    ctx.Status("pg_dump çalıştırılıyor...");

                    var psi = new ProcessStartInfo
                    {
                        FileName = pgDumpPath,
                        Arguments = $"-h {dbSettings.Host} -p {dbSettings.Port} -U {dbSettings.Username} -d {dbSettings.DatabaseName} -F p -f \"{sqlFile}\" --no-password",
                        UseShellExecute = false,
                        RedirectStandardError = true,
                        CreateNoWindow = true
                    };

                    using var process = Process.Start(psi);
                    if (process == null) throw new Exception("pg_dump başlatılamadı!");

                    await process.WaitForExitAsync();

                    if (process.ExitCode != 0)
                    {
                        var error = await process.StandardError.ReadToEndAsync();
                        AnsiConsole.MarkupLine($"[red]HATA: {error}[/]");
                        return 1;
                    }

                    // dbsettings.json kaydet
                    ctx.Status("dbsettings.json kaydediliyor...");
                    var settingsJson = JsonSerializer.Serialize(dbSettings, new JsonSerializerOptions { WriteIndented = true });
                    await File.WriteAllTextAsync(Path.Combine(outputPath, "dbsettings.json"), settingsJson);

                    // ZIP oluştur
                    ctx.Status("ZIP dosyası oluşturuluyor...");
                    var zipPath = $"{outputPath}.zip";
                    if (File.Exists(zipPath)) File.Delete(zipPath);
                    ZipFile.CreateFromDirectory(outputPath, zipPath);

                    AnsiConsole.MarkupLine($"\n[bold green]✓ Yedek başarıyla oluşturuldu![/]");
                    AnsiConsole.MarkupLine($"[cyan]Klasör:[/] {outputPath}");
                    AnsiConsole.MarkupLine($"[cyan]ZIP:[/] {zipPath}");
                    AnsiConsole.MarkupLine($"[cyan]Boyut:[/] {new FileInfo(zipPath).Length:N0} bytes");

                    return 0;
                }
                finally
                {
                    Environment.SetEnvironmentVariable("PGPASSWORD", null);
                }
            });
    }

    /// <summary>
    /// Yedek dosyasını kontrol et
    /// </summary>
    static async Task<int> InspectBackupAsync()
    {
        AnsiConsole.MarkupLine("\n[bold green]== Yedek Dosyası Kontrolü ==[/]\n");

        var backupPath = AnsiConsole.Ask<string>("[yellow]Yedek dosyası yolu (.sql veya .zip):[/]");

        if (!File.Exists(backupPath))
        {
            AnsiConsole.MarkupLine("[red]HATA: Dosya bulunamadı![/]");
            return 1;
        }

        var fileInfo = new FileInfo(backupPath);
        var table = new Table().Border(TableBorder.Rounded);
        table.AddColumn("[yellow]Bilgi[/]");
        table.AddColumn("[cyan]Değer[/]");
        table.AddRow("Dosya Adı", fileInfo.Name);
        table.AddRow("Boyut", $"{fileInfo.Length:N0} bytes ({fileInfo.Length / 1024.0 / 1024.0:F2} MB)");
        table.AddRow("Oluşturulma", fileInfo.CreationTime.ToString("dd.MM.yyyy HH:mm:ss"));
        table.AddRow("Değiştirilme", fileInfo.LastWriteTime.ToString("dd.MM.yyyy HH:mm:ss"));

        if (backupPath.EndsWith(".zip", StringComparison.OrdinalIgnoreCase))
        {
            using var archive = ZipFile.OpenRead(backupPath);
            table.AddRow("ZIP İçeriği", string.Join(", ", archive.Entries.Select(e => e.Name)));

            var sqlEntry = archive.Entries.FirstOrDefault(e => e.Name.EndsWith(".sql"));
            if (sqlEntry != null)
            {
                table.AddRow("SQL Boyutu", $"{sqlEntry.Length:N0} bytes");
            }

            var settingsEntry = archive.Entries.FirstOrDefault(e => e.Name == "dbsettings.json");
            if (settingsEntry != null)
            {
                using var stream = settingsEntry.Open();
                using var reader = new StreamReader(stream);
                var json = await reader.ReadToEndAsync();
                var settings = JsonSerializer.Deserialize<DbSettings>(json);
                table.AddRow("Veritabanı", settings?.DatabaseName ?? "-");
                table.AddRow("Host", settings?.Host ?? "-");
            }
        }
        else
        {
            // SQL dosyası analizi
            var lines = await File.ReadAllLinesAsync(backupPath);
            table.AddRow("Satır Sayısı", lines.Length.ToString("N0"));

            var tableCount = lines.Count(l => l.StartsWith("CREATE TABLE", StringComparison.OrdinalIgnoreCase));
            table.AddRow("Tablo Sayısı", tableCount.ToString());
        }

        AnsiConsole.Write(table);
        AnsiConsole.MarkupLine("\n[green]✓ Yedek dosyası geçerli görünüyor.[/]");
        return 0;
    }

    /// <summary>
    /// PostgreSQL bağlantı testi
    /// </summary>
    static async Task<int> TestConnectionAsync()
    {
        AnsiConsole.MarkupLine("\n[bold green]== PostgreSQL Bağlantı Testi ==[/]\n");

        var dbSettings = await GetConnectionDetailsAsync();

        var psqlPath = FindPostgresTool("psql");
        if (psqlPath == null)
        {
            AnsiConsole.MarkupLine("[red]HATA: psql bulunamadı![/]");
            return 1;
        }

        return await AnsiConsole.Status()
            .StartAsync("Bağlantı test ediliyor...", async ctx =>
            {
                Environment.SetEnvironmentVariable("PGPASSWORD", dbSettings.Password);
                try
                {
                    var psi = new ProcessStartInfo
                    {
                        FileName = psqlPath,
                        Arguments = $"-h {dbSettings.Host} -p {dbSettings.Port} -U {dbSettings.Username} -d {dbSettings.DatabaseName} -c \"SELECT version();\"",
                        UseShellExecute = false,
                        RedirectStandardOutput = true,
                        RedirectStandardError = true,
                        CreateNoWindow = true
                    };

                    using var process = Process.Start(psi);
                    if (process == null) throw new Exception("psql başlatılamadı!");

                    var output = await process.StandardOutput.ReadToEndAsync();
                    await process.WaitForExitAsync();

                    if (process.ExitCode == 0)
                    {
                        AnsiConsole.MarkupLine("[bold green]✓ Bağlantı başarılı![/]");
                        AnsiConsole.MarkupLine($"[dim]{output.Trim()}[/]");
                        return 0;
                    }
                    else
                    {
                        var error = await process.StandardError.ReadToEndAsync();
                        AnsiConsole.MarkupLine($"[red]HATA: {error}[/]");
                        return 1;
                    }
                }
                finally
                {
                    Environment.SetEnvironmentVariable("PGPASSWORD", null);
                }
            });
    }

    /// <summary>
    /// Kullanıcıdan bağlantı bilgilerini al
    /// </summary>
    static Task<DbSettings> GetConnectionDetailsAsync()
    {
        var settings = new DbSettings
        {
            Host = AnsiConsole.Ask("[yellow]Host:[/]", "localhost"),
            Port = AnsiConsole.Ask("[yellow]Port:[/]", 5432),
            DatabaseName = AnsiConsole.Ask<string>("[yellow]Veritabanı adı:[/]"),
            Username = AnsiConsole.Ask("[yellow]Kullanıcı adı:[/]", "postgres"),
            Password = AnsiConsole.Prompt(new TextPrompt<string>("[yellow]Şifre:[/]").Secret())
        };

        return Task.FromResult(settings);
    }

    /// <summary>
    /// PostgreSQL aracını bul
    /// </summary>
    static string? FindPostgresTool(string toolName)
    {
        // PATH'te ara
        var command = Environment.GetEnvironmentVariable("PATH")?
            .Split(Path.PathSeparator)
            .Select(p => Path.Combine(p, $"{toolName}.exe"))
            .FirstOrDefault(File.Exists);

        if (command != null) return command;

        // Bilinen konumlarda ara
        var versions = new[] { "17", "16", "15", "14", "13" };
        foreach (var version in versions)
        {
            var path = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles),
                "PostgreSQL", version, "bin", $"{toolName}.exe");
            if (File.Exists(path)) return path;
        }

        return null;
    }

    /// <summary>
    /// psql komutu çalıştır
    /// </summary>
    static async Task RunPsqlCommandAsync(string psqlPath, DbSettings settings, string command, string? database = null)
    {
        var psi = new ProcessStartInfo
        {
            FileName = psqlPath,
            Arguments = $"-h {settings.Host} -p {settings.Port} -U {settings.Username} -d {database ?? settings.DatabaseName} -c \"{command}\"",
            UseShellExecute = false,
            RedirectStandardError = true,
            CreateNoWindow = true
        };

        using var process = Process.Start(psi);
        if (process == null) throw new Exception("psql başlatılamadı!");
        await process.WaitForExitAsync();
    }
}

/// <summary>
/// Veritabanı ayarları
/// </summary>
class DbSettings
{
    public int Id { get; set; }
    public int Provider { get; set; } = 2; // PostgreSQL
    public string? Host { get; set; } = "localhost";
    public int Port { get; set; } = 5432;
    public string? DatabaseName { get; set; }
    public string? Username { get; set; } = "postgres";
    public string? Password { get; set; }
    public bool UseIntegratedSecurity { get; set; }
    public string? AdditionalOptions { get; set; }
    public DateTime? LastUpdated { get; set; }
}
