using System.Data;
using Microsoft.EntityFrameworkCore;

namespace CRMFiloServis.Web.Data.Migrations;

public static class PersonelTableMigrationHelper
{
    public static async Task ApplyPersonelTableMigrationAsync(ApplicationDbContext context)
    {
        try
        {
            if (context.Database.IsNpgsql())
            {
                var sql = @"
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'Soforler')
       AND NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'Personeller') THEN
        ALTER TABLE ""Soforler"" RENAME TO ""Personeller"";
    END IF;
END $$;";

                await context.Database.ExecuteSqlRawAsync(sql);
                return;
            }

            if (context.Database.IsSqlite())
            {
                var connection = context.Database.GetDbConnection();
                var shouldClose = connection.State != ConnectionState.Open;

                if (shouldClose)
                {
                    await connection.OpenAsync();
                }

                try
                {
                    var hasSoforler = await TableExistsAsync(connection, "Soforler");
                    var hasPersoneller = await TableExistsAsync(connection, "Personeller");

                    if (hasSoforler && !hasPersoneller)
                    {
                        await using var command = connection.CreateCommand();
                        command.CommandText = "ALTER TABLE \"Soforler\" RENAME TO \"Personeller\"";
                        await command.ExecuteNonQueryAsync();
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
            Console.WriteLine($"Personel tablo migration hatası: {ex.Message}");
        }
    }

    private static async Task<bool> TableExistsAsync(System.Data.Common.DbConnection connection, string tableName)
    {
        await using var command = connection.CreateCommand();
        command.CommandText = "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = $tableName LIMIT 1";

        var parameter = command.CreateParameter();
        parameter.ParameterName = "$tableName";
        parameter.Value = tableName;
        command.Parameters.Add(parameter);

        return await command.ExecuteScalarAsync() is not null;
    }
}
