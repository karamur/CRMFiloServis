using Microsoft.EntityFrameworkCore;

namespace KOAFiloServis.Web.Data.Migrations;

/// <summary>
/// PersonelPuantajlar ve GunlukPuantajlar tablolarini olusturan migration helper
/// </summary>
public static class PersonelPuantajTableMigrationHelper
{
    public static async Task EnsurePersonelPuantajTablesAsync(ApplicationDbContext context)
    {
        try
        {
            if (context.Database.IsNpgsql())
            {
                await EnsurePostgresTablesAsync(context);
            }
            else if (context.Database.IsSqlite())
            {
                await EnsureSqliteTablesAsync(context);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"PersonelPuantaj tablo olusturma hatasi: {ex.Message}");
        }
    }

    private static async Task EnsurePostgresTablesAsync(ApplicationDbContext context)
    {
        // PersonelPuantajlar tablosu
        var createPersonelPuantajSql = @"
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'PersonelPuantajlar') THEN
        CREATE TABLE ""PersonelPuantajlar"" (
            ""Id"" SERIAL PRIMARY KEY,
            ""SirketId"" integer NOT NULL DEFAULT 1,
            ""FirmaId"" integer NOT NULL,
            ""PersonelId"" integer NOT NULL,
            ""Yil"" integer NOT NULL,
            ""Ay"" integer NOT NULL,
            ""CalisilanGun"" integer NOT NULL DEFAULT 0,
            ""FazlaMesaiSaat"" numeric(18,2) NOT NULL DEFAULT 0,
            ""IzinGunu"" integer NOT NULL DEFAULT 0,
            ""MazeretGunu"" integer NOT NULL DEFAULT 0,
            ""BrutMaas"" numeric(18,2) NOT NULL DEFAULT 0,
            ""YemekUcreti"" numeric(18,2) NOT NULL DEFAULT 0,
            ""YolUcreti"" numeric(18,2) NOT NULL DEFAULT 0,
            ""Prim"" numeric(18,2) NOT NULL DEFAULT 0,
            ""DigerOdeme"" numeric(18,2) NOT NULL DEFAULT 0,
            ""SgkKesinti"" numeric(18,2) NOT NULL DEFAULT 0,
            ""GelirVergisi"" numeric(18,2) NOT NULL DEFAULT 0,
            ""DamgaVergisi"" numeric(18,2) NOT NULL DEFAULT 0,
            ""DigerKesinti"" numeric(18,2) NOT NULL DEFAULT 0,
            ""NetOdeme"" numeric(18,2) NOT NULL DEFAULT 0,
            ""Aciklama"" text NULL,
            ""OnayDurumu"" integer NOT NULL DEFAULT 0,
            ""OnaylayanKullanici"" text NULL,
            ""OnayTarihi"" timestamp without time zone NULL,
            ""OnayNotu"" text NULL,
            ""IsDeleted"" boolean NOT NULL DEFAULT FALSE,
            ""CreatedAt"" timestamp without time zone NOT NULL DEFAULT NOW(),
            ""UpdatedAt"" timestamp without time zone NULL,
            ""CreatedBy"" text NULL,
            ""UpdatedBy"" text NULL,
            CONSTRAINT ""FK_PersonelPuantajlar_Firmalar"" FOREIGN KEY (""FirmaId"") REFERENCES ""Firmalar"" (""Id"") ON DELETE CASCADE,
            CONSTRAINT ""FK_PersonelPuantajlar_Personeller"" FOREIGN KEY (""PersonelId"") REFERENCES ""Personeller"" (""Id"") ON DELETE CASCADE
        );

        CREATE INDEX ""IX_PersonelPuantajlar_FirmaId"" ON ""PersonelPuantajlar"" (""FirmaId"");
        CREATE INDEX ""IX_PersonelPuantajlar_PersonelId"" ON ""PersonelPuantajlar"" (""PersonelId"");
        CREATE INDEX ""IX_PersonelPuantajlar_Yil_Ay"" ON ""PersonelPuantajlar"" (""Yil"", ""Ay"");
        CREATE INDEX ""IX_PersonelPuantajlar_SirketId"" ON ""PersonelPuantajlar"" (""SirketId"");
    END IF;
END $$;";

        await context.Database.ExecuteSqlRawAsync(createPersonelPuantajSql);

        // GunlukPuantajlar tablosu
        var createGunlukPuantajSql = @"
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'GunlukPuantajlar') THEN
        CREATE TABLE ""GunlukPuantajlar"" (
            ""Id"" SERIAL PRIMARY KEY,
            ""SirketId"" integer NOT NULL DEFAULT 1,
            ""PersonelPuantajId"" integer NOT NULL,
            ""Gun"" integer NOT NULL,
            ""Tarih"" date NOT NULL,
            ""Durum"" integer NOT NULL DEFAULT 0,
            ""FazlaMesaiSaat"" numeric(18,2) NOT NULL DEFAULT 0,
            ""Notlar"" text NULL,
            ""IsDeleted"" boolean NOT NULL DEFAULT FALSE,
            ""CreatedAt"" timestamp without time zone NOT NULL DEFAULT NOW(),
            ""UpdatedAt"" timestamp without time zone NULL,
            ""CreatedBy"" text NULL,
            ""UpdatedBy"" text NULL,
            CONSTRAINT ""FK_GunlukPuantajlar_PersonelPuantajlar"" FOREIGN KEY (""PersonelPuantajId"") REFERENCES ""PersonelPuantajlar"" (""Id"") ON DELETE CASCADE
        );

        CREATE INDEX ""IX_GunlukPuantajlar_PersonelPuantajId"" ON ""GunlukPuantajlar"" (""PersonelPuantajId"");
        CREATE INDEX ""IX_GunlukPuantajlar_Tarih"" ON ""GunlukPuantajlar"" (""Tarih"");
        CREATE INDEX ""IX_GunlukPuantajlar_SirketId"" ON ""GunlukPuantajlar"" (""SirketId"");
    END IF;
END $$;";

        await context.Database.ExecuteSqlRawAsync(createGunlukPuantajSql);
    }

    private static async Task EnsureSqliteTablesAsync(ApplicationDbContext context)
    {
        // PersonelPuantajlar tablosu (SQLite)
        var createPersonelPuantajSql = @"
CREATE TABLE IF NOT EXISTS ""PersonelPuantajlar"" (
    ""Id"" INTEGER PRIMARY KEY AUTOINCREMENT,
    ""SirketId"" INTEGER NOT NULL DEFAULT 1,
    ""FirmaId"" INTEGER NOT NULL,
    ""PersonelId"" INTEGER NOT NULL,
    ""Yil"" INTEGER NOT NULL,
    ""Ay"" INTEGER NOT NULL,
    ""CalisilanGun"" INTEGER NOT NULL DEFAULT 0,
    ""FazlaMesaiSaat"" REAL NOT NULL DEFAULT 0,
    ""IzinGunu"" INTEGER NOT NULL DEFAULT 0,
    ""MazeretGunu"" INTEGER NOT NULL DEFAULT 0,
    ""BrutMaas"" REAL NOT NULL DEFAULT 0,
    ""YemekUcreti"" REAL NOT NULL DEFAULT 0,
    ""YolUcreti"" REAL NOT NULL DEFAULT 0,
    ""Prim"" REAL NOT NULL DEFAULT 0,
    ""DigerOdeme"" REAL NOT NULL DEFAULT 0,
    ""SgkKesinti"" REAL NOT NULL DEFAULT 0,
    ""GelirVergisi"" REAL NOT NULL DEFAULT 0,
    ""DamgaVergisi"" REAL NOT NULL DEFAULT 0,
    ""DigerKesinti"" REAL NOT NULL DEFAULT 0,
    ""NetOdeme"" REAL NOT NULL DEFAULT 0,
    ""Aciklama"" TEXT NULL,
    ""OnayDurumu"" INTEGER NOT NULL DEFAULT 0,
    ""OnaylayanKullanici"" TEXT NULL,
    ""OnayTarihi"" TEXT NULL,
    ""OnayNotu"" TEXT NULL,
    ""IsDeleted"" INTEGER NOT NULL DEFAULT 0,
    ""CreatedAt"" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ""UpdatedAt"" TEXT NULL,
    ""CreatedBy"" TEXT NULL,
    ""UpdatedBy"" TEXT NULL,
    FOREIGN KEY (""FirmaId"") REFERENCES ""Firmalar"" (""Id"") ON DELETE CASCADE,
    FOREIGN KEY (""PersonelId"") REFERENCES ""Personeller"" (""Id"") ON DELETE CASCADE
);";

        await context.Database.ExecuteSqlRawAsync(createPersonelPuantajSql);

        // Index'ler (SQLite)
        await context.Database.ExecuteSqlRawAsync(@"CREATE INDEX IF NOT EXISTS ""IX_PersonelPuantajlar_FirmaId"" ON ""PersonelPuantajlar"" (""FirmaId"");");
        await context.Database.ExecuteSqlRawAsync(@"CREATE INDEX IF NOT EXISTS ""IX_PersonelPuantajlar_PersonelId"" ON ""PersonelPuantajlar"" (""PersonelId"");");
        await context.Database.ExecuteSqlRawAsync(@"CREATE INDEX IF NOT EXISTS ""IX_PersonelPuantajlar_Yil_Ay"" ON ""PersonelPuantajlar"" (""Yil"", ""Ay"");");

        // GunlukPuantajlar tablosu (SQLite)
        var createGunlukPuantajSql = @"
CREATE TABLE IF NOT EXISTS ""GunlukPuantajlar"" (
    ""Id"" INTEGER PRIMARY KEY AUTOINCREMENT,
    ""SirketId"" INTEGER NOT NULL DEFAULT 1,
    ""PersonelPuantajId"" INTEGER NOT NULL,
    ""Gun"" INTEGER NOT NULL,
    ""Tarih"" TEXT NOT NULL,
    ""Durum"" INTEGER NOT NULL DEFAULT 0,
    ""FazlaMesaiSaat"" REAL NOT NULL DEFAULT 0,
    ""Notlar"" TEXT NULL,
    ""IsDeleted"" INTEGER NOT NULL DEFAULT 0,
    ""CreatedAt"" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ""UpdatedAt"" TEXT NULL,
    ""CreatedBy"" TEXT NULL,
    ""UpdatedBy"" TEXT NULL,
    FOREIGN KEY (""PersonelPuantajId"") REFERENCES ""PersonelPuantajlar"" (""Id"") ON DELETE CASCADE
);";

        await context.Database.ExecuteSqlRawAsync(createGunlukPuantajSql);

        // Index'ler (SQLite)
        await context.Database.ExecuteSqlRawAsync(@"CREATE INDEX IF NOT EXISTS ""IX_GunlukPuantajlar_PersonelPuantajId"" ON ""GunlukPuantajlar"" (""PersonelPuantajId"");");
        await context.Database.ExecuteSqlRawAsync(@"CREATE INDEX IF NOT EXISTS ""IX_GunlukPuantajlar_Tarih"" ON ""GunlukPuantajlar"" (""Tarih"");");
    }
}
