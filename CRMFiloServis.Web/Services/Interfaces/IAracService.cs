using CRMFiloServis.Shared.Entities;
using Microsoft.AspNetCore.Components.Forms;

namespace CRMFiloServis.Web.Services;

public interface IAracService
{
    // Araç CRUD Ýþlemleri
    Task<List<Arac>> GetAllAsync();
    Task<List<Arac>> GetActiveAsync();
    Task<int> GetActiveCountAsync();
    Task<Arac?> GetByIdAsync(int id);
    Task<Arac?> GetByPlakaAsync(string plaka);
    Task<Arac?> GetBySaseNoAsync(string saseNo);
    Task<bool> SaseNoMevcutMu(string saseNo, int? haricAracId = null);
    Task<bool> PlakaMevcutMu(string plaka, int? haricAracPlakaId = null);
    Task<Arac> CreateAsync(Arac arac, string plaka, PlakaIslemTipi islemTipi = PlakaIslemTipi.Alis,
        decimal? islemTutari = null, int? cariId = null, string? aciklama = null);
    Task<Arac> UpdateAsync(Arac arac);
    Task DeleteAsync(int id);

    // Plaka Ýþlemleri
    Task<List<AracPlaka>> GetPlakaGecmisiAsync(int aracId);
    Task<AracPlaka> PlakaEkle(int aracId, string yeniPlaka, PlakaIslemTipi islemTipi,
        decimal? islemTutari = null, int? cariId = null, string? aciklama = null);
    Task PlakaCikis(int aracPlakaId, PlakaIslemTipi cikisIslemTipi,
        decimal? islemTutari = null, int? cariId = null, string? aciklama = null);

    // Satýþa Açýk Araçlar
    Task<List<Arac>> GetSatisaAcikAraclarAsync();
    Task AracSatisaAc(int aracId, decimal satisFiyati, string? aciklama = null);
    Task AracSatisKapat(int aracId);

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
