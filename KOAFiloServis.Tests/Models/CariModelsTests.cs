using KOAFiloServis.Web.Models;

namespace KOAFiloServis.Tests.Models;

public class CariHareketTakipRaporTests
{
    [Fact]
    public void NetBakiye_BorcEksiAlacak()
    {
        var rapor = new CariHareketTakipRapor { ToplamBorc = 5000m, ToplamAlacak = 3000m };

        Assert.Equal(2000m, rapor.NetBakiye);
    }

    [Theory]
    [InlineData(5000, 3000, "Borçlu")]
    [InlineData(3000, 5000, "Alacaklı")]
    [InlineData(3000, 3000, "Dengeli")]
    public void BakiyeDurumu_DogruMetinDonmeli(decimal borc, decimal alacak, string beklenen)
    {
        var rapor = new CariHareketTakipRapor { ToplamBorc = borc, ToplamAlacak = alacak };

        Assert.Equal(beklenen, rapor.BakiyeDurumu);
    }

    [Theory]
    [InlineData(5000, 3000, "danger")]
    [InlineData(3000, 5000, "success")]
    [InlineData(3000, 3000, "secondary")]
    public void BakiyeRengi_DogruRenkDonmeli(decimal borc, decimal alacak, string beklenen)
    {
        var rapor = new CariHareketTakipRapor { ToplamBorc = borc, ToplamAlacak = alacak };

        Assert.Equal(beklenen, rapor.BakiyeRengi);
    }

    [Theory]
    [InlineData(80, "Çok Yüksek")]
    [InlineData(95, "Çok Yüksek")]
    [InlineData(60, "Yüksek")]
    [InlineData(79, "Yüksek")]
    [InlineData(40, "Orta")]
    [InlineData(59, "Orta")]
    [InlineData(20, "Düşük")]
    [InlineData(39, "Düşük")]
    [InlineData(0, "Çok Düşük")]
    [InlineData(19, "Çok Düşük")]
    public void RiskSeviyesi_DogruMetinDonmeli(int skor, string beklenen)
    {
        var rapor = new CariHareketTakipRapor { RiskSkoru = skor };

        Assert.Equal(beklenen, rapor.RiskSeviyesi);
    }

    [Theory]
    [InlineData(80, "danger")]
    [InlineData(60, "warning")]
    [InlineData(40, "info")]
    [InlineData(19, "success")]
    public void RiskRengi_DogruRenkDonmeli(int skor, string beklenen)
    {
        var rapor = new CariHareketTakipRapor { RiskSkoru = skor };

        Assert.Equal(beklenen, rapor.RiskRengi);
    }
}

public class CariYaslandirmaOzetTests
{
    [Fact]
    public void VadesiGecmisBakiye_30_60_90_PlusToplamiOlmali()
    {
        var ozet = new CariYaslandirmaOzet
        {
            Vadesi30_60 = 1000m,
            Vadesi60_90 = 2000m,
            Vadesi90Plus = 3000m
        };

        Assert.Equal(6000m, ozet.VadesiGecmisBakiye);
    }

    [Fact]
    public void VadesiGecmisOran_DogruYuzdeHesaplanmali()
    {
        var ozet = new CariYaslandirmaOzet
        {
            ToplamBakiye = 10000m,
            Vadesi30_60 = 1000m,
            Vadesi60_90 = 1000m,
            Vadesi90Plus = 3000m
        };

        // VadesiGecmisBakiye=5000, oran=|5000/10000|*100=50
        Assert.Equal(50m, ozet.VadesiGecmisOran);
    }

    [Fact]
    public void VadesiGecmisOran_BakiyeSifirOluncaSifir()
    {
        var ozet = new CariYaslandirmaOzet { ToplamBakiye = 0m, Vadesi90Plus = 500m };

        Assert.Equal(0m, ozet.VadesiGecmisOran);
    }

    [Theory]
    [InlineData(50, "Yüksek")]
    [InlineData(100, "Yüksek")]
    [InlineData(25, "Orta")]
    [InlineData(49, "Orta")]
    [InlineData(10, "Düşük")]
    [InlineData(0, "Normal")]
    public void RiskSeviyesi_OranaBagliDogruDonmeli(decimal oran, string beklenen)
    {
        // VadesiGecmisOran = |VadesiGecmisBakiye / ToplamBakiye| * 100
        // Bakiyeyi oran/100 oranında vadesi geçmiş ayarlıyoruz
        var ozet = new CariYaslandirmaOzet
        {
            ToplamBakiye = oran > 0 ? 100m : 0m,
            Vadesi90Plus = oran > 0 ? oran : 0m
        };

        Assert.Equal(beklenen, ozet.RiskSeviyesi);
    }
}
