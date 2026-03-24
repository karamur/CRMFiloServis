using CRMFiloServis.Shared.Entities;
using Microsoft.AspNetCore.Components.Forms;

namespace CRMFiloServis.Web.Services;

public interface IAracService
{
    Task<List<Arac>> GetAllAsync();
    Task<List<Arac>> GetActiveAsync();
    Task<int> GetActiveCountAsync();
    Task<Arac?> GetByIdAsync(int id);
    Task<Arac?> GetByPlakaAsync(string plaka);
    Task<Arac> CreateAsync(Arac arac);
    Task<Arac> UpdateAsync(Arac arac);
    Task DeleteAsync(int id);

    // Arac Evrak Islemleri
    Task<List<AracEvrak>> GetAracEvraklariAsync(int aracId);
    Task<AracEvrak?> GetAracEvrakByIdAsync(int evrakId);
    Task<AracEvrak> CreateAracEvrakAsync(AracEvrak evrak);
    Task<AracEvrak> UpdateAracEvrakAsync(AracEvrak evrak);
    Task DeleteAracEvrakAsync(int evrakId);

    // Evrak Dosya Islemleri
    Task<AracEvrakDosya> UploadEvrakDosyaAsync(int evrakId, IBrowserFile file);
    Task<byte[]> GetEvrakDosyaAsync(int dosyaId);
    Task DeleteEvrakDosyaAsync(int dosyaId);

    // Evrak Uyarilari
    Task<List<AracEvrak>> GetSuresiDolacakEvraklarAsync(int gunSayisi = 30);
}
