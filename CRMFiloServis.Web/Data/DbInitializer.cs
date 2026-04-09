using CRMFiloServis.Shared.Entities;
using Microsoft.EntityFrameworkCore;
using Npgsql;
using System.Data;

namespace CRMFiloServis.Web.Data;

public static class DbInitializer
{
    public static async Task InitializeAsync(ApplicationDbContext context, IConfiguration configuration)
    {
        var dbProvider = context.Database.IsNpgsql()
            ? "PostgreSQL"
            : context.Database.IsSqlite()
                ? "SQLite"
                : configuration.GetValue<string>("DatabaseProvider") ?? "SQLite";
        
        try
        {
            // Veritabani baglantisini kontrol et
            if (!await context.Database.CanConnectAsync())
            {
                throw new Exception("Veritabani baglantisi kurulamadi!");
            }

            // Bekleyen migration'lari uygula (yeni tablolar icin)
            var pendingMigrations = (await context.Database.GetPendingMigrationsAsync()).ToList();
            if (context.Database.IsSqlite() && pendingMigrations.Any())
            {
                await EnsureSqliteMigrationHistoryAsync(context, pendingMigrations);
                pendingMigrations = (await context.Database.GetPendingMigrationsAsync()).ToList();
            }

            if (pendingMigrations.Any())
            {
                Console.WriteLine($"Bekleyen migration sayisi: {pendingMigrations.Count()}");
                await context.Database.MigrateAsync();
                Console.WriteLine("Migration'lar basariyla uygulandi.");
            }
        }
        catch (Exception ex)
        {
            if (context.Database.IsSqlite())
            {
                try
                {
                    var pendingMigrations = (await context.Database.GetPendingMigrationsAsync()).ToList();
                    if (pendingMigrations.Any())
                    {
                        await EnsureSqliteMigrationHistoryAsync(context, pendingMigrations);
                        pendingMigrations = (await context.Database.GetPendingMigrationsAsync()).ToList();
                        if (!pendingMigrations.Any())
                        {
                            Console.WriteLine("SQLite migration gecmisi mevcut tablo yapisina gore duzeltildi.");
                            return;
                        }
                    }
                }
                catch (Exception sqliteFixEx)
                {
                    Console.WriteLine($"SQLite migration duzeltme hatasi: {sqliteFixEx.Message}");
                }
            }

            // Migration hatasi durumunda EnsureCreated dene
            Console.WriteLine($"Migration hatasi: {ex.Message}. EnsureCreated deneniyor...");
            
            try
            {
                await context.Database.EnsureCreatedAsync();
            }
            catch (Exception createEx)
            {
                Console.WriteLine($"EnsureCreated hatasi: {createEx.Message}");
                // Tablolar zaten var, devam et
            }
        }

        // PostgreSQL için eksik kolonları ekle
        if (dbProvider == "PostgreSQL")
        {
            await EnsurePostgreSqlMissingColumnsAsync(context, configuration);
        }

        // PiyasaKaynaklar tablosunu oluştur
        await EnsurePiyasaKaynaklarTableAsync(context, dbProvider, configuration);

        // TekrarlayanOdemeler tablosunu oluştur
        await EnsureTekrarlayanOdemelerTableAsync(context, dbProvider, configuration);

        // Roller tablosuna Renk kolonu ekle (yoksa)
        await EnsureRollerRenkColumnAsync(context, dbProvider, configuration);

        // PuantajKayitlar tablosuna yeni kolonları ekle
        await EnsurePuantajKayitlarColumnsAsync(context, dbProvider, configuration);

        // Destek modulu tablolarini kontrol et / olustur
        await EnsureDestekModuluTablesAsync(context, dbProvider, configuration);

        // Destek modulu eksik kolonlarini tamamla
        await EnsureDestekModuluColumnsAsync(context, dbProvider, configuration);

        // Budget masraf kalemleri her zaman kontrol et
        await SeedBudgetMasrafKalemleriAsync(context);

        // Destek Talebi seed verilerini ekle
        await SeedDestekTalebiVerileriAsync(context);
    }

    private static string GetDefaultConnectionString(ApplicationDbContext context, IConfiguration configuration)
    {
        return context.Database.GetConnectionString()
            ?? configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("DefaultConnection bulunamadi.");
    }

    private static async Task EnsurePiyasaKaynaklarTableAsync(ApplicationDbContext context, string dbProvider, IConfiguration configuration)
    {
        try
        {
            if (dbProvider == "PostgreSQL")
            {
                var connectionString = GetDefaultConnectionString(context, configuration);
                using var conn = new NpgsqlConnection(connectionString);
                await conn.OpenAsync();
                
                // Tablo var mı kontrol et
                using var checkCmd = new NpgsqlCommand(
                    "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'PiyasaKaynaklar')", conn);
                var exists = (bool)(await checkCmd.ExecuteScalarAsync() ?? false);
                
                if (!exists)
                {
                    using var createCmd = new NpgsqlCommand(@"
                        CREATE TABLE ""PiyasaKaynaklar"" (
                            ""Id"" SERIAL PRIMARY KEY,
                            ""Ad"" VARCHAR(100) NOT NULL,
                            ""Kod"" VARCHAR(50) NOT NULL,
                            ""BaseUrl"" VARCHAR(500) NOT NULL,
                            ""AramaUrl"" VARCHAR(500),
                            ""AramaParametreleri"" VARCHAR(1000),
                            ""Selectors"" VARCHAR(2000),
                            ""DesteklenenMarkalar"" VARCHAR(500),
                            ""KaynakTipi"" VARCHAR(50) DEFAULT 'Genel',
                            ""Sira"" INTEGER DEFAULT 99,
                            ""Aktif"" BOOLEAN DEFAULT TRUE,
                            ""OlusturmaTarihi"" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            ""GuncellemeTarihi"" TIMESTAMP,
                            ""IsDeleted"" BOOLEAN DEFAULT FALSE
                        )", conn);
                    await createCmd.ExecuteNonQueryAsync();
                    Console.WriteLine("PiyasaKaynaklar tablosu PostgreSQL'de oluşturuldu.");
                }
                else
                {
                    Console.WriteLine("PiyasaKaynaklar tablosu zaten mevcut.");
                }
            }
            else
            {
                // SQLite için
                await context.Database.ExecuteSqlRawAsync(@"
                    CREATE TABLE IF NOT EXISTS ""PiyasaKaynaklar"" (
                        ""Id"" INTEGER PRIMARY KEY AUTOINCREMENT,
                        ""Ad"" TEXT NOT NULL,
                        ""Kod"" TEXT NOT NULL,
                        ""BaseUrl"" TEXT NOT NULL,
                        ""AramaUrl"" TEXT,
                        ""AramaParametreleri"" TEXT,
                        ""Selectors"" TEXT,
                        ""DesteklenenMarkalar"" TEXT,
                        ""KaynakTipi"" TEXT DEFAULT 'Genel',
                        ""Sira"" INTEGER DEFAULT 99,
                        ""Aktif"" INTEGER DEFAULT 1,
                        ""OlusturmaTarihi"" TEXT DEFAULT CURRENT_TIMESTAMP,
                        ""GuncellemeTarihi"" TEXT,
                        ""IsDeleted"" INTEGER DEFAULT 0
                    )");
                Console.WriteLine("PiyasaKaynaklar tablosu SQLite'da kontrol edildi.");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"PiyasaKaynaklar tablo oluşturma hatası: {ex.Message}");
        }
    }

    private static async Task EnsureTekrarlayanOdemelerTableAsync(ApplicationDbContext context, string dbProvider, IConfiguration configuration)
    {
        try
        {
            if (dbProvider == "PostgreSQL")
            {
                var connectionString = GetDefaultConnectionString(context, configuration);
                using var conn = new NpgsqlConnection(connectionString);
                await conn.OpenAsync();

                using var checkCmd = new NpgsqlCommand(
                    "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'TekrarlayanOdemeler')", conn);
                var exists = (bool)(await checkCmd.ExecuteScalarAsync() ?? false);

                if (!exists)
                {
                    using var createCmd = new NpgsqlCommand(@"
                        CREATE TABLE ""TekrarlayanOdemeler"" (
                            ""Id"" SERIAL PRIMARY KEY,
                            ""OdemeAdi"" VARCHAR(200) NOT NULL,
                            ""MasrafKalemi"" VARCHAR(200) NOT NULL,
                            ""Aciklama"" VARCHAR(500),
                            ""Tutar"" NUMERIC(18,2) NOT NULL,
                            ""Periyod"" INTEGER NOT NULL DEFAULT 1,
                            ""OdemeGunu"" INTEGER NOT NULL DEFAULT 1,
                            ""BaslangicTarihi"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                            ""BitisTarihi"" TIMESTAMP,
                            ""HatirlatmaGunSayisi"" INTEGER NOT NULL DEFAULT 3,
                            ""FirmaId"" INTEGER REFERENCES ""Firmalar""(""Id"") ON DELETE SET NULL,
                            ""Aktif"" BOOLEAN NOT NULL DEFAULT TRUE,
                            ""Renk"" VARCHAR(20) DEFAULT '#dc3545',
                            ""Icon"" VARCHAR(50) DEFAULT 'bi-arrow-repeat',
                            ""Notlar"" VARCHAR(1000),
                            ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                            ""UpdatedAt"" TIMESTAMP,
                            ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE
                        );
                        CREATE INDEX ""IX_TekrarlayanOdemeler_FirmaId"" ON ""TekrarlayanOdemeler"" (""FirmaId"");
                        CREATE INDEX ""IX_TekrarlayanOdemeler_MasrafKalemi"" ON ""TekrarlayanOdemeler"" (""MasrafKalemi"");
                    ", conn);
                    await createCmd.ExecuteNonQueryAsync();
                    Console.WriteLine("TekrarlayanOdemeler tablosu PostgreSQL'de oluşturuldu.");
                }
                else
                {
                    Console.WriteLine("TekrarlayanOdemeler tablosu zaten mevcut.");
                }
            }
            else
            {
                // SQLite icin
                await context.Database.ExecuteSqlRawAsync(@"
                    CREATE TABLE IF NOT EXISTS ""TekrarlayanOdemeler"" (
                        ""Id"" INTEGER PRIMARY KEY AUTOINCREMENT,
                        ""OdemeAdi"" TEXT NOT NULL,
                        ""MasrafKalemi"" TEXT NOT NULL,
                        ""Aciklama"" TEXT,
                        ""Tutar"" REAL NOT NULL,
                        ""Periyod"" INTEGER NOT NULL DEFAULT 1,
                        ""OdemeGunu"" INTEGER NOT NULL DEFAULT 1,
                        ""BaslangicTarihi"" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""BitisTarihi"" TEXT,
                        ""HatirlatmaGunSayisi"" INTEGER NOT NULL DEFAULT 3,
                        ""FirmaId"" INTEGER,
                        ""Aktif"" INTEGER NOT NULL DEFAULT 1,
                        ""Renk"" TEXT DEFAULT '#dc3545',
                        ""Icon"" TEXT DEFAULT 'bi-arrow-repeat',
                        ""Notlar"" TEXT,
                        ""CreatedAt"" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""UpdatedAt"" TEXT,
                        ""IsDeleted"" INTEGER NOT NULL DEFAULT 0
                    )");
                Console.WriteLine("TekrarlayanOdemeler tablosu SQLite'da kontrol edildi.");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"TekrarlayanOdemeler tablo oluşturma hatası: {ex.Message}");
        }
    }

    private static async Task EnsureRollerRenkColumnAsync(ApplicationDbContext context, string dbProvider, IConfiguration configuration)
    {
        try
        {
            if (dbProvider == "PostgreSQL")
            {
                var connectionString = GetDefaultConnectionString(context, configuration);
                using var conn = new NpgsqlConnection(connectionString);
                await conn.OpenAsync();

                // Kolon var mı kontrol et
                using var checkCmd = new NpgsqlCommand(
                    "SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'Roller' AND column_name = 'Renk')", conn);
                var exists = (bool)(await checkCmd.ExecuteScalarAsync() ?? false);

                if (!exists)
                {
                    using var addColumnCmd = new NpgsqlCommand(
                        "ALTER TABLE \"Roller\" ADD COLUMN \"Renk\" VARCHAR(20) DEFAULT '#dc3545'", conn);
                    await addColumnCmd.ExecuteNonQueryAsync();
                    Console.WriteLine("Roller tablosuna Renk kolonu eklendi.");
                }
                else
                {
                    Console.WriteLine("Roller tablosunda Renk kolonu zaten mevcut.");
                }
            }
            else
            {
                // SQLite için
                var connection = context.Database.GetDbConnection();
                var shouldClose = connection.State != System.Data.ConnectionState.Open;

                if (shouldClose)
                {
                    await connection.OpenAsync();
                }

                try
                {
                    await using var checkCommand = connection.CreateCommand();
                    checkCommand.CommandText = "SELECT 1 FROM pragma_table_info('Roller') WHERE name = $columnName LIMIT 1";
                    var parameter = checkCommand.CreateParameter();
                    parameter.ParameterName = "$columnName";
                    parameter.Value = "Renk";
                    checkCommand.Parameters.Add(parameter);

                    var exists = await checkCommand.ExecuteScalarAsync() is not null;
                    if (!exists)
                    {
                        await using var alterCommand = connection.CreateCommand();
                        alterCommand.CommandText = "ALTER TABLE \"Roller\" ADD COLUMN \"Renk\" TEXT DEFAULT '#dc3545'";
                        await alterCommand.ExecuteNonQueryAsync();
                        Console.WriteLine("Roller tablosuna Renk kolonu eklendi.");
                    }
                    else
                    {
                        Console.WriteLine("Roller tablosunda Renk kolonu zaten mevcut.");
                    }
                }
                finally
                {
                    if (shouldClose)
                    {
                        await connection.CloseAsync();
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Roller Renk kolonu ekleme hatası: {ex.Message}");
        }
    }

    private static async Task EnsurePuantajKayitlarColumnsAsync(ApplicationDbContext context, string dbProvider, IConfiguration configuration)
    {
        try
        {
            if (dbProvider != "PostgreSQL") return;

            var connectionString = GetDefaultConnectionString(context, configuration);
            using var conn = new NpgsqlConnection(connectionString);
            await conn.OpenAsync();

            // Eklenecek kolonlar: Bolge, SiraNo, AitFirmaAdi, Gun01-Gun31
            var kolonlar = new List<(string kolon, string tip, string varsayilan)>
            {
                ("Bolge", "VARCHAR(100)", "NULL"),
                ("SiraNo", "INTEGER", "0"),
                ("AitFirmaAdi", "VARCHAR(200)", "NULL"),
            };

            // Gun01 - Gun31
            for (int g = 1; g <= 31; g++)
                kolonlar.Add(($"Gun{g:D2}", "INTEGER", "0"));

            foreach (var (kolon, tip, varsayilan) in kolonlar)
            {
                using var checkCmd = new NpgsqlCommand(
                    $"SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'PuantajKayitlar' AND column_name = '{kolon}')", conn);
                var exists = (bool)(await checkCmd.ExecuteScalarAsync() ?? false);

                if (!exists)
                {
                    var defaultClause = varsayilan == "NULL" ? "" : $" DEFAULT {varsayilan}";
                    var nullClause = varsayilan == "NULL" ? "" : " NOT NULL";
                    using var addCmd = new NpgsqlCommand(
                        $"ALTER TABLE \"PuantajKayitlar\" ADD COLUMN \"{kolon}\" {tip}{nullClause}{defaultClause}", conn);
                    await addCmd.ExecuteNonQueryAsync();
                    Console.WriteLine($"PuantajKayitlar tablosuna {kolon} kolonu eklendi.");
                }
            }

            Console.WriteLine("PuantajKayitlar tablo kolon kontrolü tamamlandı.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"PuantajKayitlar kolon ekleme hatası: {ex.Message}");
        }
    }

    private static async Task EnsureSqliteMigrationHistoryAsync(ApplicationDbContext context, List<string> pendingMigrations)
    {
        var connection = context.Database.GetDbConnection();
        var shouldClose = connection.State != ConnectionState.Open;

        if (shouldClose)
        {
            await connection.OpenAsync();
        }

        try
        {
            await using var tableCheck = connection.CreateCommand();
            tableCheck.CommandText = "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name <> '__EFMigrationsHistory' AND name NOT LIKE 'sqlite_%' LIMIT 1";
            var hasUserTables = await tableCheck.ExecuteScalarAsync() is not null;
            if (!hasUserTables)
            {
                return;
            }

            await using var historyCreate = connection.CreateCommand();
            historyCreate.CommandText = @"
                CREATE TABLE IF NOT EXISTS ""__EFMigrationsHistory"" (
                    ""MigrationId"" TEXT NOT NULL CONSTRAINT ""PK___EFMigrationsHistory"" PRIMARY KEY,
                    ""ProductVersion"" TEXT NOT NULL
                );";
            await historyCreate.ExecuteNonQueryAsync();

            var existingMigrationIds = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            await using (var historyReader = connection.CreateCommand())
            {
                historyReader.CommandText = "SELECT \"MigrationId\" FROM \"__EFMigrationsHistory\"";
                await using var reader = await historyReader.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    existingMigrationIds.Add(reader.GetString(0));
                }
            }

            var allMigrations = context.Database.GetMigrations().ToList();
            var migrationsToBaseline = allMigrations
                .Where(pendingMigrations.Contains)
                .Where(migrationId => !existingMigrationIds.Contains(migrationId))
                .ToList();

            if (migrationsToBaseline.Count == 0)
            {
                return;
            }

            await using var insertHistory = connection.CreateCommand();
            insertHistory.CommandText = "INSERT INTO \"__EFMigrationsHistory\" (\"MigrationId\", \"ProductVersion\") VALUES ($id, $version)";

            var idParameter = insertHistory.CreateParameter();
            idParameter.ParameterName = "$id";
            idParameter.Value = string.Empty;
            insertHistory.Parameters.Add(idParameter);

            var versionParameter = insertHistory.CreateParameter();
            versionParameter.ParameterName = "$version";
            versionParameter.Value = "10.0.5";
            insertHistory.Parameters.Add(versionParameter);

            foreach (var migrationId in migrationsToBaseline)
            {
                idParameter.Value = migrationId;
                await insertHistory.ExecuteNonQueryAsync();
            }

            Console.WriteLine($"SQLite migration history baselined: {migrationsToBaseline.Count} migration");
        }
        finally
        {
            if (shouldClose)
            {
                await connection.CloseAsync();
            }
        }
    }

    // Eski metod - geriye donuk uyumluluk icin
    public static async Task InitializeAsync(ApplicationDbContext context)
    {
        try
        {
            await context.Database.MigrateAsync();
        }
        catch
        {
            // Hata olursa EnsureCreated dene
            try
            {
                await context.Database.EnsureCreatedAsync();
            }
            catch
            {
                // Tablolar zaten var, devam et
            }
        }

        var dbProvider = context.Database.IsNpgsql() ? "PostgreSQL" : context.Database.IsSqlite() ? "SQLite" : "SQLite";
        await EnsureDestekModuluTablesAsync(context, dbProvider, null);
        await EnsureDestekModuluColumnsAsync(context, dbProvider, null);

        await SeedBudgetMasrafKalemleriAsync(context);

        // Destek Talebi seed verilerini ekle
        await SeedDestekTalebiVerileriAsync(context);
    }

    private static async Task EnsureDestekModuluTablesAsync(ApplicationDbContext context, string dbProvider, IConfiguration? configuration)
    {
        try
        {
            if (dbProvider == "PostgreSQL")
            {
                var connectionString = GetDefaultConnectionString(context, configuration ?? new ConfigurationBuilder().Build());
                using var conn = new NpgsqlConnection(connectionString);
                await conn.OpenAsync();

                using var createCmd = new NpgsqlCommand(@"
                    CREATE TABLE IF NOT EXISTS ""DestekDepartmanlari"" (
                        ""Id"" SERIAL PRIMARY KEY,
                        ""Ad"" VARCHAR(200) NOT NULL,
                        ""Aciklama"" TEXT,
                        ""Email"" VARCHAR(200),
                        ""OtomatikAtama"" BOOLEAN NOT NULL DEFAULT FALSE,
                        ""VarsayilanSlaSuresi"" INTEGER,
                        ""SiraNo"" INTEGER NOT NULL DEFAULT 0,
                        ""Aktif"" BOOLEAN NOT NULL DEFAULT TRUE,
                        ""UstDepartmanId"" INTEGER NULL REFERENCES ""DestekDepartmanlari""(""Id"") ON DELETE SET NULL,
                        ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""UpdatedAt"" TIMESTAMP NULL,
                        ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE
                    );

                    CREATE TABLE IF NOT EXISTS ""DestekKategorileri"" (
                        ""Id"" SERIAL PRIMARY KEY,
                        ""Ad"" VARCHAR(200) NOT NULL,
                        ""Aciklama"" TEXT,
                        ""Renk"" VARCHAR(50),
                        ""Simge"" VARCHAR(100),
                        ""SiraNo"" INTEGER NOT NULL DEFAULT 0,
                        ""Aktif"" BOOLEAN NOT NULL DEFAULT TRUE,
                        ""DepartmanId"" INTEGER NULL REFERENCES ""DestekDepartmanlari""(""Id"") ON DELETE SET NULL,
                        ""UstKategoriId"" INTEGER NULL REFERENCES ""DestekKategorileri""(""Id"") ON DELETE SET NULL,
                        ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""UpdatedAt"" TIMESTAMP NULL,
                        ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE
                    );

                    CREATE TABLE IF NOT EXISTS ""DestekSlaListesi"" (
                        ""Id"" SERIAL PRIMARY KEY,
                        ""Ad"" VARCHAR(200) NOT NULL,
                        ""Aciklama"" TEXT,
                        ""IlkYanitSuresi"" INTEGER NOT NULL,
                        ""CozumSuresi"" INTEGER NOT NULL,
                        ""Oncelik"" INTEGER NOT NULL,
                        ""Aktif"" BOOLEAN NOT NULL DEFAULT TRUE,
                        ""SadeceMesaiSaatleri"" BOOLEAN NOT NULL DEFAULT TRUE,
                        ""SadeceHaftaIci"" BOOLEAN NOT NULL DEFAULT TRUE,
                        ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""UpdatedAt"" TIMESTAMP NULL,
                        ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE
                    );

                    CREATE TABLE IF NOT EXISTS ""DestekHazirYanitlari"" (
                        ""Id"" SERIAL PRIMARY KEY,
                        ""Ad"" VARCHAR(200) NOT NULL,
                        ""Icerik"" TEXT NOT NULL,
                        ""KonuSablonu"" VARCHAR(500),
                        ""Aciklama"" TEXT,
                        ""Aktif"" BOOLEAN NOT NULL DEFAULT TRUE,
                        ""SiraNo"" INTEGER NOT NULL DEFAULT 0,
                        ""DepartmanId"" INTEGER NULL REFERENCES ""DestekDepartmanlari""(""Id"") ON DELETE SET NULL,
                        ""KategoriId"" INTEGER NULL REFERENCES ""DestekKategorileri""(""Id"") ON DELETE SET NULL,
                        ""KullanimSayisi"" INTEGER NOT NULL DEFAULT 0,
                        ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""UpdatedAt"" TIMESTAMP NULL,
                        ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE
                    );

                    CREATE TABLE IF NOT EXISTS ""DestekAyarlari"" (
                        ""Id"" SERIAL PRIMARY KEY,
                        ""Anahtar"" VARCHAR(200) NOT NULL,
                        ""Deger"" TEXT NOT NULL,
                        ""Aciklama"" TEXT,
                        ""Grup"" VARCHAR(100),
                        ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""UpdatedAt"" TIMESTAMP NULL,
                        ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE
                    );

                    CREATE TABLE IF NOT EXISTS ""DestekTalepleri"" (
                        ""Id"" SERIAL PRIMARY KEY,
                        ""TalepNo"" VARCHAR(50) NOT NULL,
                        ""Konu"" VARCHAR(500) NOT NULL,
                        ""Aciklama"" TEXT NOT NULL,
                        ""Durum"" INTEGER NOT NULL DEFAULT 1,
                        ""Oncelik"" INTEGER NOT NULL DEFAULT 2,
                        ""Kaynak"" INTEGER NOT NULL DEFAULT 1,
                        ""SlaSuresi"" INTEGER NULL,
                        ""SlaBitisTarihi"" TIMESTAMP NULL,
                        ""SlaAsildi"" BOOLEAN NOT NULL DEFAULT FALSE,
                        ""SonAktiviteTarihi"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""KapatilmaTarihi"" TIMESTAMP NULL,
                        ""CozumSuresiDakika"" INTEGER NULL,
                        ""IlkYanitSuresiDakika"" INTEGER NULL,
                        ""MemnuniyetPuani"" INTEGER NULL,
                        ""MemnuniyetYorumu"" TEXT,
                        ""DahiliNotlar"" TEXT,
                        ""Etiketler"" TEXT,
                        ""DepartmanId"" INTEGER NOT NULL REFERENCES ""DestekDepartmanlari""(""Id"") ON DELETE RESTRICT,
                        ""KategoriId"" INTEGER NULL REFERENCES ""DestekKategorileri""(""Id"") ON DELETE SET NULL,
                        ""AtananKullaniciId"" INTEGER NULL REFERENCES ""Kullanicilar""(""Id"") ON DELETE SET NULL,
                        ""OlusturanKullaniciId"" INTEGER NULL REFERENCES ""Kullanicilar""(""Id"") ON DELETE SET NULL,
                        ""CariId"" INTEGER NULL REFERENCES ""Cariler""(""Id"") ON DELETE SET NULL,
                        ""MusteriAdi"" VARCHAR(200) NOT NULL DEFAULT '',
                        ""MusteriEmail"" VARCHAR(200) NOT NULL DEFAULT '',
                        ""MusteriTelefon"" VARCHAR(50),
                        ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""UpdatedAt"" TIMESTAMP NULL,
                        ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE
                    );

                    CREATE TABLE IF NOT EXISTS ""DestekDepartmanUyeleri"" (
                        ""Id"" SERIAL PRIMARY KEY,
                        ""DepartmanId"" INTEGER NOT NULL REFERENCES ""DestekDepartmanlari""(""Id"") ON DELETE CASCADE,
                        ""KullaniciId"" INTEGER NOT NULL REFERENCES ""Kullanicilar""(""Id"") ON DELETE CASCADE,
                        ""Yonetici"" BOOLEAN NOT NULL DEFAULT FALSE,
                        ""OtomatikAtamaUygun"" BOOLEAN NOT NULL DEFAULT TRUE,
                        ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""UpdatedAt"" TIMESTAMP NULL,
                        ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE
                    );

                    CREATE TABLE IF NOT EXISTS ""DestekTalebiIliskileri"" (
                        ""Id"" SERIAL PRIMARY KEY,
                        ""AnaTalepId"" INTEGER NOT NULL REFERENCES ""DestekTalepleri""(""Id"") ON DELETE CASCADE,
                        ""IliskiliTalepId"" INTEGER NOT NULL REFERENCES ""DestekTalepleri""(""Id"") ON DELETE CASCADE,
                        ""IliskiTuru"" INTEGER NOT NULL,
                        ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""UpdatedAt"" TIMESTAMP NULL,
                        ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE
                    );

                    CREATE TABLE IF NOT EXISTS ""DestekTalebiYanitlari"" (
                        ""Id"" SERIAL PRIMARY KEY,
                        ""DestekTalebiId"" INTEGER NOT NULL REFERENCES ""DestekTalepleri""(""Id"") ON DELETE CASCADE,
                        ""Icerik"" TEXT NOT NULL,
                        ""DahiliNot"" BOOLEAN NOT NULL DEFAULT FALSE,
                        ""YanitTuru"" INTEGER NOT NULL DEFAULT 1,
                        ""KullaniciId"" INTEGER NULL REFERENCES ""Kullanicilar""(""Id"") ON DELETE SET NULL,
                        ""MusteriYaniti"" BOOLEAN NOT NULL DEFAULT FALSE,
                        ""MusteriAdi"" VARCHAR(200),
                        ""HazirYanitId"" INTEGER NULL REFERENCES ""DestekHazirYanitlari""(""Id"") ON DELETE SET NULL,
                        ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""UpdatedAt"" TIMESTAMP NULL,
                        ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE
                    );

                    CREATE TABLE IF NOT EXISTS ""DestekTalebiEkleri"" (
                        ""Id"" SERIAL PRIMARY KEY,
                        ""DestekTalebiId"" INTEGER NULL REFERENCES ""DestekTalepleri""(""Id"") ON DELETE CASCADE,
                        ""YanitId"" INTEGER NULL REFERENCES ""DestekTalebiYanitlari""(""Id"") ON DELETE CASCADE,
                        ""DosyaAdi"" VARCHAR(500) NOT NULL,
                        ""OrijinalDosyaAdi"" VARCHAR(500) NOT NULL,
                        ""DosyaYolu"" TEXT NOT NULL,
                        ""DosyaBoyutu"" BIGINT NOT NULL DEFAULT 0,
                        ""MimeTipi"" VARCHAR(200) NOT NULL DEFAULT '',
                        ""YukleyenKullaniciId"" INTEGER NULL REFERENCES ""Kullanicilar""(""Id"") ON DELETE SET NULL,
                        ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""UpdatedAt"" TIMESTAMP NULL,
                        ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE
                    );

                    CREATE TABLE IF NOT EXISTS ""DestekTalebiAktiviteleri"" (
                        ""Id"" SERIAL PRIMARY KEY,
                        ""DestekTalebiId"" INTEGER NOT NULL REFERENCES ""DestekTalepleri""(""Id"") ON DELETE CASCADE,
                        ""AktiviteTuru"" INTEGER NOT NULL,
                        ""Aciklama"" TEXT NOT NULL,
                        ""EskiDeger"" TEXT,
                        ""YeniDeger"" TEXT,
                        ""KullaniciId"" INTEGER NULL REFERENCES ""Kullanicilar""(""Id"") ON DELETE SET NULL,
                        ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""UpdatedAt"" TIMESTAMP NULL,
                        ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE
                    );

                    CREATE TABLE IF NOT EXISTS ""DestekBilgiBankasiMakaleleri"" (
                        ""Id"" SERIAL PRIMARY KEY,
                        ""Baslik"" VARCHAR(500) NOT NULL,
                        ""Icerik"" TEXT NOT NULL,
                        ""Ozet"" TEXT,
                        ""Etiketler"" TEXT,
                        ""SeoBaslik"" VARCHAR(500),
                        ""SeoAciklama"" TEXT,
                        ""Slug"" VARCHAR(500),
                        ""GoruntulemeSayisi"" INTEGER NOT NULL DEFAULT 0,
                        ""YararliBulmaSayisi"" INTEGER NOT NULL DEFAULT 0,
                        ""YararsizBulmaSayisi"" INTEGER NOT NULL DEFAULT 0,
                        ""Durum"" INTEGER NOT NULL DEFAULT 1,
                        ""YayinlanmaTarihi"" TIMESTAMP NULL,
                        ""KategoriId"" INTEGER NULL REFERENCES ""DestekKategorileri""(""Id"") ON DELETE SET NULL,
                        ""YazarKullaniciId"" INTEGER NULL REFERENCES ""Kullanicilar""(""Id"") ON DELETE SET NULL,
                        ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        ""UpdatedAt"" TIMESTAMP NULL,
                        ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE
                    );

                    CREATE UNIQUE INDEX IF NOT EXISTS ""IX_DestekTalepleri_TalepNo"" ON ""DestekTalepleri"" (""TalepNo"");
                    CREATE UNIQUE INDEX IF NOT EXISTS ""IX_DestekAyarlari_Anahtar"" ON ""DestekAyarlari"" (""Anahtar"");
                ", conn);

                await createCmd.ExecuteNonQueryAsync();
                Console.WriteLine("Destek modulu tablolari PostgreSQL'de kontrol edildi.");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Destek modulu tablo kontrol hatasi: {ex.Message}");
        }
    }

    private static async Task EnsureDestekModuluColumnsAsync(ApplicationDbContext context, string dbProvider, IConfiguration? configuration)
    {
        try
        {
            if (dbProvider != "PostgreSQL")
                return;

            var connectionString = GetDefaultConnectionString(context, configuration ?? new ConfigurationBuilder().Build());
            using var conn = new NpgsqlConnection(connectionString);
            await conn.OpenAsync();

            using var cmd = new NpgsqlCommand(@"
                ALTER TABLE ""DestekDepartmanlari""
                    ADD COLUMN IF NOT EXISTS ""Email"" VARCHAR(200),
                    ADD COLUMN IF NOT EXISTS ""OtomatikAtama"" BOOLEAN NOT NULL DEFAULT FALSE,
                    ADD COLUMN IF NOT EXISTS ""VarsayilanSlaSuresi"" INTEGER,
                    ADD COLUMN IF NOT EXISTS ""SiraNo"" INTEGER NOT NULL DEFAULT 0,
                    ADD COLUMN IF NOT EXISTS ""Aktif"" BOOLEAN NOT NULL DEFAULT TRUE,
                    ADD COLUMN IF NOT EXISTS ""UstDepartmanId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    ADD COLUMN IF NOT EXISTS ""UpdatedAt"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE;

                ALTER TABLE ""DestekKategorileri""
                    ADD COLUMN IF NOT EXISTS ""Aciklama"" TEXT,
                    ADD COLUMN IF NOT EXISTS ""Renk"" VARCHAR(50),
                    ADD COLUMN IF NOT EXISTS ""Simge"" VARCHAR(100),
                    ADD COLUMN IF NOT EXISTS ""SiraNo"" INTEGER NOT NULL DEFAULT 0,
                    ADD COLUMN IF NOT EXISTS ""Aktif"" BOOLEAN NOT NULL DEFAULT TRUE,
                    ADD COLUMN IF NOT EXISTS ""DepartmanId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""UstKategoriId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    ADD COLUMN IF NOT EXISTS ""UpdatedAt"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE;

                ALTER TABLE ""DestekSlaListesi""
                    ADD COLUMN IF NOT EXISTS ""Aciklama"" TEXT,
                    ADD COLUMN IF NOT EXISTS ""Aktif"" BOOLEAN NOT NULL DEFAULT TRUE,
                    ADD COLUMN IF NOT EXISTS ""SadeceMesaiSaatleri"" BOOLEAN NOT NULL DEFAULT TRUE,
                    ADD COLUMN IF NOT EXISTS ""SadeceHaftaIci"" BOOLEAN NOT NULL DEFAULT TRUE,
                    ADD COLUMN IF NOT EXISTS ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    ADD COLUMN IF NOT EXISTS ""UpdatedAt"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE;

                ALTER TABLE ""DestekHazirYanitlari""
                    ADD COLUMN IF NOT EXISTS ""KonuSablonu"" VARCHAR(500),
                    ADD COLUMN IF NOT EXISTS ""Aciklama"" TEXT,
                    ADD COLUMN IF NOT EXISTS ""Aktif"" BOOLEAN NOT NULL DEFAULT TRUE,
                    ADD COLUMN IF NOT EXISTS ""SiraNo"" INTEGER NOT NULL DEFAULT 0,
                    ADD COLUMN IF NOT EXISTS ""DepartmanId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""KategoriId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""KullanimSayisi"" INTEGER NOT NULL DEFAULT 0,
                    ADD COLUMN IF NOT EXISTS ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    ADD COLUMN IF NOT EXISTS ""UpdatedAt"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE;

                ALTER TABLE ""DestekAyarlari""
                    ADD COLUMN IF NOT EXISTS ""Aciklama"" TEXT,
                    ADD COLUMN IF NOT EXISTS ""Grup"" VARCHAR(100),
                    ADD COLUMN IF NOT EXISTS ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    ADD COLUMN IF NOT EXISTS ""UpdatedAt"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE;

                ALTER TABLE ""DestekTalepleri""
                    ADD COLUMN IF NOT EXISTS ""SlaSuresi"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""SlaBitisTarihi"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""SlaAsildi"" BOOLEAN NOT NULL DEFAULT FALSE,
                    ADD COLUMN IF NOT EXISTS ""SonAktiviteTarihi"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    ADD COLUMN IF NOT EXISTS ""KapatilmaTarihi"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""CozumSuresiDakika"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""IlkYanitSuresiDakika"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""MemnuniyetPuani"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""MemnuniyetYorumu"" TEXT,
                    ADD COLUMN IF NOT EXISTS ""DahiliNotlar"" TEXT,
                    ADD COLUMN IF NOT EXISTS ""Etiketler"" TEXT,
                    ADD COLUMN IF NOT EXISTS ""KategoriId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""AtananKullaniciId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""OlusturanKullaniciId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""CariId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""MusteriAdi"" VARCHAR(200) NOT NULL DEFAULT '',
                    ADD COLUMN IF NOT EXISTS ""MusteriEmail"" VARCHAR(200) NOT NULL DEFAULT '',
                    ADD COLUMN IF NOT EXISTS ""MusteriTelefon"" VARCHAR(50),
                    ADD COLUMN IF NOT EXISTS ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    ADD COLUMN IF NOT EXISTS ""UpdatedAt"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE;

                ALTER TABLE ""DestekDepartmanUyeleri""
                    ADD COLUMN IF NOT EXISTS ""Yonetici"" BOOLEAN NOT NULL DEFAULT FALSE,
                    ADD COLUMN IF NOT EXISTS ""OtomatikAtamaUygun"" BOOLEAN NOT NULL DEFAULT TRUE,
                    ADD COLUMN IF NOT EXISTS ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    ADD COLUMN IF NOT EXISTS ""UpdatedAt"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE;

                ALTER TABLE ""DestekTalebiIliskileri""
                    ADD COLUMN IF NOT EXISTS ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    ADD COLUMN IF NOT EXISTS ""UpdatedAt"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE;

                ALTER TABLE ""DestekTalebiYanitlari""
                    ADD COLUMN IF NOT EXISTS ""DahiliNot"" BOOLEAN NOT NULL DEFAULT FALSE,
                    ADD COLUMN IF NOT EXISTS ""YanitTuru"" INTEGER NOT NULL DEFAULT 1,
                    ADD COLUMN IF NOT EXISTS ""KullaniciId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""MusteriYaniti"" BOOLEAN NOT NULL DEFAULT FALSE,
                    ADD COLUMN IF NOT EXISTS ""MusteriAdi"" VARCHAR(200),
                    ADD COLUMN IF NOT EXISTS ""HazirYanitId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    ADD COLUMN IF NOT EXISTS ""UpdatedAt"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE;

                ALTER TABLE ""DestekTalebiEkleri""
                    ADD COLUMN IF NOT EXISTS ""DosyaBoyutu"" BIGINT NOT NULL DEFAULT 0,
                    ADD COLUMN IF NOT EXISTS ""MimeTipi"" VARCHAR(200) NOT NULL DEFAULT '',
                    ADD COLUMN IF NOT EXISTS ""YukleyenKullaniciId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    ADD COLUMN IF NOT EXISTS ""UpdatedAt"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE;

                ALTER TABLE ""DestekTalebiAktiviteleri""
                    ADD COLUMN IF NOT EXISTS ""EskiDeger"" TEXT,
                    ADD COLUMN IF NOT EXISTS ""YeniDeger"" TEXT,
                    ADD COLUMN IF NOT EXISTS ""KullaniciId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    ADD COLUMN IF NOT EXISTS ""UpdatedAt"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE;

                ALTER TABLE ""DestekBilgiBankasiMakaleleri""
                    ADD COLUMN IF NOT EXISTS ""Ozet"" TEXT,
                    ADD COLUMN IF NOT EXISTS ""Etiketler"" TEXT,
                    ADD COLUMN IF NOT EXISTS ""SeoBaslik"" VARCHAR(500),
                    ADD COLUMN IF NOT EXISTS ""SeoAciklama"" TEXT,
                    ADD COLUMN IF NOT EXISTS ""Slug"" VARCHAR(500),
                    ADD COLUMN IF NOT EXISTS ""GoruntulemeSayisi"" INTEGER NOT NULL DEFAULT 0,
                    ADD COLUMN IF NOT EXISTS ""YararliBulmaSayisi"" INTEGER NOT NULL DEFAULT 0,
                    ADD COLUMN IF NOT EXISTS ""YararsizBulmaSayisi"" INTEGER NOT NULL DEFAULT 0,
                    ADD COLUMN IF NOT EXISTS ""Durum"" INTEGER NOT NULL DEFAULT 1,
                    ADD COLUMN IF NOT EXISTS ""YayinlanmaTarihi"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""KategoriId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""YazarKullaniciId"" INTEGER NULL,
                    ADD COLUMN IF NOT EXISTS ""CreatedAt"" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    ADD COLUMN IF NOT EXISTS ""UpdatedAt"" TIMESTAMP NULL,
                    ADD COLUMN IF NOT EXISTS ""IsDeleted"" BOOLEAN NOT NULL DEFAULT FALSE;

                CREATE UNIQUE INDEX IF NOT EXISTS ""IX_DestekTalepleri_TalepNo"" ON ""DestekTalepleri"" (""TalepNo"");
                CREATE UNIQUE INDEX IF NOT EXISTS ""IX_DestekAyarlari_Anahtar"" ON ""DestekAyarlari"" (""Anahtar"");
            ", conn);

            await cmd.ExecuteNonQueryAsync();
            Console.WriteLine("Destek modulu kolonlari PostgreSQL'de kontrol edildi.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Destek modulu kolon kontrol hatasi: {ex.Message}");
        }
    }

    private static async Task SeedDestekTalebiVerileriAsync(ApplicationDbContext context)
    {
        try
        {
            // Varsayılan Departmanlar
            if (!await context.DestekDepartmanlari.AnyAsync())
            {
                var departmanlar = new List<DestekDepartman>
                {
                    new() { Ad = "Teknik Destek", Aciklama = "Teknik sorunlar ve sistem hataları", Email = "teknik@firma.com", SiraNo = 1, Aktif = true, VarsayilanSlaSuresi = 24, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Satış", Aciklama = "Satış ve fiyatlandırma soruları", Email = "satis@firma.com", SiraNo = 2, Aktif = true, VarsayilanSlaSuresi = 8, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Muhasebe", Aciklama = "Fatura ve ödeme sorunları", Email = "muhasebe@firma.com", SiraNo = 3, Aktif = true, VarsayilanSlaSuresi = 48, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Genel", Aciklama = "Genel sorular ve öneriler", Email = "destek@firma.com", SiraNo = 4, Aktif = true, VarsayilanSlaSuresi = 72, CreatedAt = DateTime.UtcNow }
                };
                context.DestekDepartmanlari.AddRange(departmanlar);
                await context.SaveChangesAsync();
                Console.WriteLine("Destek departmanları eklendi.");
            }

            // Varsayılan Kategoriler
            if (!await context.DestekKategorileri.AnyAsync())
            {
                var teknikDept = await context.DestekDepartmanlari.FirstOrDefaultAsync(d => d.Ad == "Teknik Destek");
                var satisDept = await context.DestekDepartmanlari.FirstOrDefaultAsync(d => d.Ad == "Satış");
                var muhasebeDept = await context.DestekDepartmanlari.FirstOrDefaultAsync(d => d.Ad == "Muhasebe");

                var kategoriler = new List<DestekKategori>
                {
                    // Teknik Destek kategorileri
                    new() { Ad = "Sistem Hatası", DepartmanId = teknikDept?.Id, Renk = "#dc3545", Simge = "bi-bug", SiraNo = 1, Aktif = true, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Performans Sorunu", DepartmanId = teknikDept?.Id, Renk = "#ffc107", Simge = "bi-speedometer", SiraNo = 2, Aktif = true, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Özellik İsteği", DepartmanId = teknikDept?.Id, Renk = "#17a2b8", Simge = "bi-lightbulb", SiraNo = 3, Aktif = true, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Kullanım Yardımı", DepartmanId = teknikDept?.Id, Renk = "#28a745", Simge = "bi-question-circle", SiraNo = 4, Aktif = true, CreatedAt = DateTime.UtcNow },

                    // Satış kategorileri
                    new() { Ad = "Fiyat Teklifi", DepartmanId = satisDept?.Id, Renk = "#007bff", Simge = "bi-currency-dollar", SiraNo = 1, Aktif = true, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Lisans/Abonelik", DepartmanId = satisDept?.Id, Renk = "#6f42c1", Simge = "bi-key", SiraNo = 2, Aktif = true, CreatedAt = DateTime.UtcNow },

                    // Muhasebe kategorileri
                    new() { Ad = "Fatura Sorunu", DepartmanId = muhasebeDept?.Id, Renk = "#fd7e14", Simge = "bi-receipt", SiraNo = 1, Aktif = true, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Ödeme Sorunu", DepartmanId = muhasebeDept?.Id, Renk = "#e83e8c", Simge = "bi-credit-card", SiraNo = 2, Aktif = true, CreatedAt = DateTime.UtcNow }
                };
                context.DestekKategorileri.AddRange(kategoriler);
                await context.SaveChangesAsync();
                Console.WriteLine("Destek kategorileri eklendi.");
            }

            // Varsayılan SLA Tanımları
            if (!await context.DestekSlaListesi.AnyAsync())
            {
                var slaListesi = new List<DestekSla>
                {
                    new() { Ad = "Kritik SLA", Oncelik = DestekOncelik.Kritik, IlkYanitSuresi = 1, CozumSuresi = 4, Aktif = true, SadeceMesaiSaatleri = false, SadeceHaftaIci = false, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Acil SLA", Oncelik = DestekOncelik.Acil, IlkYanitSuresi = 2, CozumSuresi = 8, Aktif = true, SadeceMesaiSaatleri = false, SadeceHaftaIci = false, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Yüksek SLA", Oncelik = DestekOncelik.Yuksek, IlkYanitSuresi = 4, CozumSuresi = 24, Aktif = true, SadeceMesaiSaatleri = true, SadeceHaftaIci = true, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Normal SLA", Oncelik = DestekOncelik.Normal, IlkYanitSuresi = 8, CozumSuresi = 48, Aktif = true, SadeceMesaiSaatleri = true, SadeceHaftaIci = true, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Düşük SLA", Oncelik = DestekOncelik.Dusuk, IlkYanitSuresi = 24, CozumSuresi = 72, Aktif = true, SadeceMesaiSaatleri = true, SadeceHaftaIci = true, CreatedAt = DateTime.UtcNow }
                };
                context.DestekSlaListesi.AddRange(slaListesi);
                await context.SaveChangesAsync();
                Console.WriteLine("SLA tanımları eklendi.");
            }

            // Varsayılan Hazır Yanıtlar
            if (!await context.DestekHazirYanitlari.AnyAsync())
            {
                var hazirYanitlar = new List<DestekHazirYanit>
                {
                    new() { Ad = "Hoş Geldiniz", KonuSablonu = "Talebiniz Alındı", Icerik = "<p>Merhaba,</p><p>Destek talebiniz başarıyla alınmıştır. En kısa sürede size geri dönüş yapacağız.</p><p>Saygılarımızla,<br/>Destek Ekibi</p>", SiraNo = 1, Aktif = true, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Ek Bilgi İsteği", Icerik = "<p>Merhaba,</p><p>Talebinizi daha iyi değerlendirebilmemiz için aşağıdaki bilgileri paylaşmanızı rica ederiz:</p><ul><li>Sorunun detaylı açıklaması</li><li>Hangi adımlarda sorun yaşıyorsunuz?</li><li>Varsa ekran görüntüsü</li></ul><p>Teşekkürler.</p>", SiraNo = 2, Aktif = true, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Çözüm Bildirimi", KonuSablonu = "Talebiniz Çözüldü", Icerik = "<p>Merhaba,</p><p>Talebiniz incelenmiş ve gerekli işlemler yapılmıştır. Sorununuzun çözüldüğünü düşünüyoruz.</p><p>Başka bir sorunuz olursa bizimle iletişime geçmekten çekinmeyin.</p><p>İyi çalışmalar dileriz.</p>", SiraNo = 3, Aktif = true, CreatedAt = DateTime.UtcNow },
                    new() { Ad = "Teşekkür", Icerik = "<p>Merhaba,</p><p>Geri bildiriminiz için teşekkür ederiz. Önerileriniz bizim için değerlidir.</p><p>Saygılarımızla.</p>", SiraNo = 4, Aktif = true, CreatedAt = DateTime.UtcNow }
                };
                context.DestekHazirYanitlari.AddRange(hazirYanitlar);
                await context.SaveChangesAsync();
                Console.WriteLine("Hazır yanıtlar eklendi.");
            }

            // Varsayılan Sistem Ayarları
            if (!await context.DestekAyarlari.AnyAsync())
            {
                var ayarlar = new List<DestekAyar>
                {
                    new() { Anahtar = "SirketAdi", Deger = "Koa Filo Servis", Grup = "Genel", Aciklama = "Şirket adı", CreatedAt = DateTime.UtcNow },
                    new() { Anahtar = "DestekEmail", Deger = "destek@koafiloservis.com", Grup = "Genel", Aciklama = "Destek e-posta adresi", CreatedAt = DateTime.UtcNow },
                    new() { Anahtar = "OtomatikAtama", Deger = "false", Grup = "Atama", Aciklama = "Yeni talepleri otomatik ata", CreatedAt = DateTime.UtcNow },
                    new() { Anahtar = "MusteriPortaliAktif", Deger = "false", Grup = "Portal", Aciklama = "Müşteri self-servis portalı aktif mi", CreatedAt = DateTime.UtcNow },
                    new() { Anahtar = "MemnuniyetAnketiAktif", Deger = "true", Grup = "Anket", Aciklama = "Talep kapatıldığında memnuniyet anketi gönder", CreatedAt = DateTime.UtcNow },
                    new() { Anahtar = "MaksimumDosyaBoyutuMB", Deger = "10", Grup = "Dosya", Aciklama = "Maksimum dosya yükleme boyutu (MB)", CreatedAt = DateTime.UtcNow },
                    new() { Anahtar = "IzinliDosyaTipleri", Deger = ".jpg,.jpeg,.png,.gif,.pdf,.doc,.docx,.xls,.xlsx,.txt,.zip", Grup = "Dosya", Aciklama = "İzin verilen dosya uzantıları", CreatedAt = DateTime.UtcNow }
                };
                context.DestekAyarlari.AddRange(ayarlar);
                await context.SaveChangesAsync();
                Console.WriteLine("Destek ayarları eklendi.");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Destek talebi seed hatası: {ex.Message}");
        }
    }

    private static async Task SeedBudgetMasrafKalemleriAsync(ApplicationDbContext context)
    {
        try
        {
            // Kritik masraf kalemleri - Her zaman kontrol et
            var gerekliKalemler = new[] { "Yakıt", "Araç Bakım/Onarım", "Şoför Maaşları", "Sigorta" };

            foreach (var kalemAdi in gerekliKalemler)
            {
                if (!await context.BudgetMasrafKalemleri.AnyAsync(k => k.KalemAdi == kalemAdi))
                {
                    context.BudgetMasrafKalemleri.Add(new BudgetMasrafKalemi
                    {
                        KalemAdi = kalemAdi,
                        Aktif = true,
                        CreatedAt = DateTime.UtcNow
                    });
                }
            }

            await context.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Seed hatasi: {ex.Message}");
        }
    }

    /// <summary>
    /// PostgreSQL için eksik kolonları otomatik ekler
    /// </summary>
    private static async Task EnsurePostgreSqlMissingColumnsAsync(ApplicationDbContext context, IConfiguration configuration)
    {
        var connectionString = GetDefaultConnectionString(context, configuration);

        // Eklenecek kolonlar listesi: (Tablo, Kolon, Tip, Default)
        var missingColumns = new List<(string Table, string Column, string Type, string? Default)>
        {
            // Fatura tablosu - EslesenFatura ve Mahsup alanları
            ("Faturalar", "EslesenFaturaId", "INTEGER", null),
            ("Faturalar", "MahsupKapatildi", "BOOLEAN", "FALSE"),
            ("Faturalar", "MahsupTarihi", "TIMESTAMP WITHOUT TIME ZONE", null),

            // Fatura tablosu - FirmalarArasi alanları
            ("Faturalar", "FirmalarArasiFatura", "BOOLEAN", "FALSE"),
            ("Faturalar", "KarsiFirmaId", "INTEGER", null),

            // BudgetOdemeler tablosu - Ödeme bilgileri
            ("BudgetOdemeler", "GercekOdemeTarihi", "TIMESTAMP WITHOUT TIME ZONE", null),
            ("BudgetOdemeler", "OdemeYapildigiHesapId", "INTEGER", null),
            ("BudgetOdemeler", "OdenenTutar", "NUMERIC(18,2)", null),
            ("BudgetOdemeler", "OdemeNotu", "VARCHAR(500)", null),
            ("BudgetOdemeler", "BankaKasaHareketId", "INTEGER", null),

            // BudgetOdemeler tablosu - Kesinti bilgileri
            ("BudgetOdemeler", "MasrafKesintisi", "NUMERIC(18,2)", "0"),
            ("BudgetOdemeler", "CezaKesintisi", "NUMERIC(18,2)", "0"),
            ("BudgetOdemeler", "DigerKesinti", "NUMERIC(18,2)", "0"),
            ("BudgetOdemeler", "KesintiAciklamasi", "VARCHAR(500)", null),

            // BudgetOdemeler tablosu - Fatura eşleştirme
            ("BudgetOdemeler", "FaturaId", "INTEGER", null),
            ("BudgetOdemeler", "FaturaIleKapatildi", "BOOLEAN", "FALSE"),

            // Soforlar tablosu - Sıralama
            ("Soforlar", "SiralamaNo", "INTEGER", "0"),

            // BankaKasaHareketleri tablosu - Mahsup alanları
            ("BankaKasaHareketleri", "MahsupHareketId", "INTEGER", null),
            ("BankaKasaHareketleri", "MahsupGrupId", "UUID", null),

            // BankaKasaHareketleri tablosu - Muhasebe alanları
            ("BankaKasaHareketleri", "MuhasebeHesapKodu", "TEXT", null),
            ("BankaKasaHareketleri", "MuhasebeAltHesapKodu", "TEXT", null),
            ("BankaKasaHareketleri", "KostMerkeziKodu", "TEXT", null),
            ("BankaKasaHareketleri", "ProjeKodu", "TEXT", null),
            ("BankaKasaHareketleri", "MuhasebeAciklama", "TEXT", null),
        };

        await using var connection = new NpgsqlConnection(connectionString);
        await connection.OpenAsync();

        foreach (var (table, column, type, defaultValue) in missingColumns)
        {
            try
            {
                // Kolon var mı kontrol et
                var checkSql = $@"
                    SELECT COUNT(*) FROM information_schema.columns 
                    WHERE table_name = '{table}' AND column_name = '{column}'";

                await using var checkCmd = new NpgsqlCommand(checkSql, connection);
                var exists = Convert.ToInt32(await checkCmd.ExecuteScalarAsync()) > 0;

                if (!exists)
                {
                    // Kolonu ekle
                    var alterSql = defaultValue != null
                        ? $@"ALTER TABLE ""{table}"" ADD COLUMN ""{column}"" {type} NOT NULL DEFAULT {defaultValue}"
                        : $@"ALTER TABLE ""{table}"" ADD COLUMN ""{column}"" {type} NULL";

                    await using var alterCmd = new NpgsqlCommand(alterSql, connection);
                    await alterCmd.ExecuteNonQueryAsync();
                    Console.WriteLine($"{table}.{column} kolonu eklendi.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"{table}.{column} eklenirken hata: {ex.Message}");
            }
        }

        await connection.CloseAsync();
    }
}
