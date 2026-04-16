using Microsoft.EntityFrameworkCore;
using KOAFiloServis.Web.Data;

namespace KOAFiloServis.Web.Data.Migrations;

/// <summary>
/// BudgetOdemeler tablosuna KalanSonrakiDonemeAktarilsin kolonunu ekler
/// </summary>
public static class BudgetOdemeKalanMigrationHelper
{
    public static async Task EnsureBudgetOdemeKalanColumnAsync(ApplicationDbContext context)
    {
        if (context.Database.IsNpgsql())
        {
            var sql = @"
                DO $$ 
                BEGIN 
                    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                                   WHERE table_name = 'BudgetOdemeler' 
                                   AND column_name = 'KalanSonrakiDonemeAktarilsin') THEN
                        ALTER TABLE ""BudgetOdemeler"" ADD COLUMN ""KalanSonrakiDonemeAktarilsin"" BOOLEAN NOT NULL DEFAULT FALSE;
                    END IF;
                END $$;
            ";
            await context.Database.ExecuteSqlRawAsync(sql);
            return;
        }

        if (context.Database.IsSqlite())
        {
            // SQLite için kolon kontrolü
            var conn = context.Database.GetDbConnection();
            if (conn.State != System.Data.ConnectionState.Open)
                await conn.OpenAsync();

            using var cmd = conn.CreateCommand();
            cmd.CommandText = "PRAGMA table_info('BudgetOdemeler')";
            var columns = new List<string>();
            using (var reader = await cmd.ExecuteReaderAsync())
            {
                while (await reader.ReadAsync())
                {
                    columns.Add(reader.GetString(1));
                }
            }

            if (!columns.Contains("KalanSonrakiDonemeAktarilsin"))
            {
                using var alterCmd = conn.CreateCommand();
                alterCmd.CommandText = "ALTER TABLE BudgetOdemeler ADD COLUMN KalanSonrakiDonemeAktarilsin INTEGER NOT NULL DEFAULT 0";
                await alterCmd.ExecuteNonQueryAsync();
            }
        }
    }
}
