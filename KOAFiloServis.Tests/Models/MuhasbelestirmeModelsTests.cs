using KOAFiloServis.Web.Models;

namespace KOAFiloServis.Tests.Models;

public class MuhasbelestirmeKontrolTests
{
    [Fact]
    public void UyariSayisi_DogruFiltrelenmeli()
    {
        var kontrol = new MuhasbelestirmeKontrol
        {
            Maddeler = new()
            {
                new() { Seviye = KontrolSeviye.Uyari },
                new() { Seviye = KontrolSeviye.Uyari },
                new() { Seviye = KontrolSeviye.Hata },
                new() { Seviye = KontrolSeviye.Bilgi }
            }
        };

        Assert.Equal(2, kontrol.UyariSayisi);
    }

    [Fact]
    public void HataSayisi_DogruFiltrelenmeli()
    {
        var kontrol = new MuhasbelestirmeKontrol
        {
            Maddeler = new()
            {
                new() { Seviye = KontrolSeviye.Hata },
                new() { Seviye = KontrolSeviye.Uyari },
                new() { Seviye = KontrolSeviye.Bilgi }
            }
        };

        Assert.Equal(1, kontrol.HataSayisi);
    }

    [Fact]
    public void BilgiSayisi_DogruFiltrelenmeli()
    {
        var kontrol = new MuhasbelestirmeKontrol
        {
            Maddeler = new()
            {
                new() { Seviye = KontrolSeviye.Bilgi },
                new() { Seviye = KontrolSeviye.Bilgi },
                new() { Seviye = KontrolSeviye.Bilgi }
            }
        };

        Assert.Equal(3, kontrol.BilgiSayisi);
    }

    [Fact]
    public void BosMaddeler_HepsiSifir()
    {
        var kontrol = new MuhasbelestirmeKontrol();

        Assert.Equal(0, kontrol.UyariSayisi);
        Assert.Equal(0, kontrol.HataSayisi);
        Assert.Equal(0, kontrol.BilgiSayisi);
    }
}
