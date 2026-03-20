using CRMFiloServis.Shared.Entities;
using CRMFiloServis.Web.Models;

namespace CRMFiloServis.Web.Services;

public interface IFaturaHazirlikService
{
    Task<FaturaHazirlikListesi> GetFaturaHazirlikListesiAsync(DateTime baslangicTarihi, DateTime bitisTarihi);
    Task<FaturaHazirlikListesi> GetFaturaHazirlikListesiAsync(DateTime baslangicTarihi, DateTime bitisTarihi, int? cariId);
}
