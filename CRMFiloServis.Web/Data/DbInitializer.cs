using CRMFiloServis.Shared.Entities;
using Microsoft.EntityFrameworkCore;

namespace CRMFiloServis.Web.Data;

public static class DbInitializer
{
    public static async Task InitializeAsync(ApplicationDbContext context)
    {
        // Veritabanýný oluþtur
        await context.Database.MigrateAsync();

        // Budget masraf kalemleri her zaman kontrol et
        await SeedBudgetMasrafKalemleriAsync(context);
    }

    private static async Task SeedBudgetMasrafKalemleriAsync(ApplicationDbContext context)
    {
        // Kritik masraf kalemleri - Her zaman kontrol et
        var gerekliKalemler = new[] { "Yakýt", "Araç Bakým/Onarým", "Þoför Maaþlarý", "Sigorta" };

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
}
