using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace KOAFiloServis.Web.Data.Migrations;

/// <summary>
/// BankaKasaHareket ve AracMasraf tablolarına PersonelCebinden kolonlarını ekleyen migration helper
/// </summary>
public static class BankaHareketPersonelCebindenMigrationHelper
{
    public static async Task EnsurePersonelCebindenColumnsAsync(ApplicationDbContext context, ILogger logger)
    {
        try
        {
            var connection = context.Database.GetDbConnection();
            await connection.OpenAsync();

            var isPostgres = context.Database.ProviderName?.Contains("Npgsql") == true;

            // BankaKasaHareketleri tablosu
            await EnsureBankaHareketColumnsAsync(connection, isPostgres, logger);

            // AracMasraflari tablosu
            await EnsureAracMasrafColumnsAsync(connection, isPostgres, logger);
        }
        catch (Exception ex)
        {
            logger.LogWarning(ex, "PersonelCebinden kolonları eklenirken hata oluştu: {Message}", ex.Message);
        }
    }

    private static async Task EnsureBankaHareketColumnsAsync(System.Data.Common.DbConnection connection, bool isPostgres, ILogger logger)
    {
        var tableName = isPostgres ? "\"BankaKasaHareketleri\"" : "BankaKasaHareketleri";

        var checkColumnSql = isPostgres
            ? "SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'BankaKasaHareketleri' AND column_name = 'PersonelCebindenId'"
            : "SELECT COUNT(*) FROM pragma_table_info('BankaKasaHareketleri') WHERE name = 'PersonelCebindenId'";

        using var checkCmd = connection.CreateCommand();
        checkCmd.CommandText = checkColumnSql;
        var columnExists = Convert.ToInt32(await checkCmd.ExecuteScalarAsync()) > 0;

        if (!columnExists)
        {
            logger.LogInformation("BankaKasaHareketleri tablosuna PersonelCebinden kolonları ekleniyor...");

            var alterSql = isPostgres
                ? $@"
                    ALTER TABLE {tableName} ADD COLUMN IF NOT EXISTS ""PersonelCebindenId"" INTEGER NULL;
                    ALTER TABLE {tableName} ADD COLUMN IF NOT EXISTS ""PersoneleOdendi"" BOOLEAN NOT NULL DEFAULT FALSE;
                    ALTER TABLE {tableName} ADD COLUMN IF NOT EXISTS ""PersonelOdemeTarihi"" TIMESTAMP NULL;
                    ALTER TABLE {tableName} ADD COLUMN IF NOT EXISTS ""PersonelOdemeHesapId"" INTEGER NULL;

                    DO $$ 
                    BEGIN 
                        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'FK_BankaKasaHareketleri_Soforler_PersonelCebindenId') THEN
                            ALTER TABLE {tableName} 
                            ADD CONSTRAINT ""FK_BankaKasaHareketleri_Soforler_PersonelCebindenId"" 
                            FOREIGN KEY (""PersonelCebindenId"") REFERENCES ""Soforler""(""Id"") ON DELETE SET NULL;
                        END IF;
                    END $$;

                    CREATE INDEX IF NOT EXISTS ""IX_BankaKasaHareketleri_PersonelCebindenId_PersoneleOdendi"" 
                    ON {tableName} (""PersonelCebindenId"", ""PersoneleOdendi"");
                  "
                : $@"
                    ALTER TABLE {tableName} ADD COLUMN PersonelCebindenId INTEGER NULL;
                    ALTER TABLE {tableName} ADD COLUMN PersoneleOdendi INTEGER NOT NULL DEFAULT 0;
                    ALTER TABLE {tableName} ADD COLUMN PersonelOdemeTarihi TEXT NULL;
                    ALTER TABLE {tableName} ADD COLUMN PersonelOdemeHesapId INTEGER NULL;
                  ";

            using var alterCmd = connection.CreateCommand();
            alterCmd.CommandText = alterSql;
            await alterCmd.ExecuteNonQueryAsync();

            logger.LogInformation("BankaKasaHareketleri tablosuna PersonelCebinden kolonları eklendi.");
        }
    }

    private static async Task EnsureAracMasrafColumnsAsync(System.Data.Common.DbConnection connection, bool isPostgres, ILogger logger)
    {
        var tableName = isPostgres ? "\"AracMasraflari\"" : "AracMasraflari";

        var checkColumnSql = isPostgres
            ? "SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'AracMasraflari' AND column_name = 'OdemeKaynak'"
            : "SELECT COUNT(*) FROM pragma_table_info('AracMasraflari') WHERE name = 'OdemeKaynak'";

        using var checkCmd = connection.CreateCommand();
        checkCmd.CommandText = checkColumnSql;
        var columnExists = Convert.ToInt32(await checkCmd.ExecuteScalarAsync()) > 0;

        if (!columnExists)
        {
            logger.LogInformation("AracMasraflari tablosuna PersonelCebinden kolonları ekleniyor...");

            var alterSql = isPostgres
                ? $@"
                    ALTER TABLE {tableName} ADD COLUMN IF NOT EXISTS ""OdemeKaynak"" INTEGER NOT NULL DEFAULT 1;
                    ALTER TABLE {tableName} ADD COLUMN IF NOT EXISTS ""PersonelCebindenId"" INTEGER NULL;
                    ALTER TABLE {tableName} ADD COLUMN IF NOT EXISTS ""PersoneleOdendi"" BOOLEAN NOT NULL DEFAULT FALSE;
                    ALTER TABLE {tableName} ADD COLUMN IF NOT EXISTS ""PersonelOdemeTarihi"" TIMESTAMP NULL;
                    ALTER TABLE {tableName} ADD COLUMN IF NOT EXISTS ""BankaHesapId"" INTEGER NULL;

                    DO $$ 
                    BEGIN 
                        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'FK_AracMasraflari_Soforler_PersonelCebindenId') THEN
                            ALTER TABLE {tableName} 
                            ADD CONSTRAINT ""FK_AracMasraflari_Soforler_PersonelCebindenId"" 
                            FOREIGN KEY (""PersonelCebindenId"") REFERENCES ""Soforler""(""Id"") ON DELETE SET NULL;
                        END IF;
                        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'FK_AracMasraflari_BankaHesaplari_BankaHesapId') THEN
                            ALTER TABLE {tableName} 
                            ADD CONSTRAINT ""FK_AracMasraflari_BankaHesaplari_BankaHesapId"" 
                            FOREIGN KEY (""BankaHesapId"") REFERENCES ""BankaHesaplari""(""Id"") ON DELETE SET NULL;
                        END IF;
                    END $$;

                    CREATE INDEX IF NOT EXISTS ""IX_AracMasraflari_PersonelCebindenId_PersoneleOdendi"" 
                    ON {tableName} (""PersonelCebindenId"", ""PersoneleOdendi"");
                  "
                : $@"
                    ALTER TABLE {tableName} ADD COLUMN OdemeKaynak INTEGER NOT NULL DEFAULT 1;
                    ALTER TABLE {tableName} ADD COLUMN PersonelCebindenId INTEGER NULL;
                    ALTER TABLE {tableName} ADD COLUMN PersoneleOdendi INTEGER NOT NULL DEFAULT 0;
                    ALTER TABLE {tableName} ADD COLUMN PersonelOdemeTarihi TEXT NULL;
                    ALTER TABLE {tableName} ADD COLUMN BankaHesapId INTEGER NULL;
                  ";

            using var alterCmd = connection.CreateCommand();
            alterCmd.CommandText = alterSql;
            await alterCmd.ExecuteNonQueryAsync();

            logger.LogInformation("AracMasraflari tablosuna PersonelCebinden kolonları eklendi.");
        }
    }
}
