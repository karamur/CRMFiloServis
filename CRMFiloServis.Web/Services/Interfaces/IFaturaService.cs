using CRMFiloServis.Shared.Entities;

namespace CRMFiloServis.Web.Services;

public interface IFaturaService
{
    Task<List<Fatura>> GetAllAsync();
    Task<List<Fatura>> GetByCariIdAsync(int cariId);
    Task<List<Fatura>> GetByTipAsync(FaturaTipi tip);
    Task<List<Fatura>> GetByDurumAsync(FaturaDurum durum);
    Task<List<Fatura>> GetOdenmemisFaturalarAsync();
    Task<List<Fatura>> GetOdenmisFaturalarAsync();
    Task<List<Fatura>> GetByDateRangeAsync(DateTime startDate, DateTime endDate);
    Task<Fatura?> GetByIdAsync(int id);
    Task<Fatura?> GetByIdWithKalemlerAsync(int id);
    Task<Fatura> CreateAsync(Fatura fatura);
    Task<Fatura> UpdateAsync(Fatura fatura);
    Task DeleteAsync(int id);
    Task<string> GenerateNextFaturaNoAsync(FaturaTipi tip);
    Task UpdateOdenenTutarAsync(int faturaId);
    
    // Dashboard optimized methods
    Task<DashboardFaturaStats> GetDashboardStatsAsync();
}

public class DashboardFaturaStats
{
    public int BekleyenFaturaSayisi { get; set; }
    public decimal BuAyGelir { get; set; }
    public decimal BuAyGider { get; set; }
    public List<Fatura> VadeGecmisFaturalar { get; set; } = [];
    public List<Fatura> VadeYaklasanFaturalar { get; set; } = [];
}
