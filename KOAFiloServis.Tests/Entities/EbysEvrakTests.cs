using KOAFiloServis.Shared.Entities;

namespace KOAFiloServis.Tests.Entities;

public class EbysEvrakTests
{
    [Fact]
    public void Default_Values_AreCorrect()
    {
        var evrak = new EbysEvrak();

        Assert.Equal(string.Empty, evrak.EvrakNo);
        Assert.Equal(EvrakYonu.Gelen, evrak.Yon);
        Assert.Equal(DateTime.Today, evrak.EvrakTarihi);
        Assert.NotNull(evrak.KayitTarihi);
        Assert.Equal(string.Empty, evrak.Konu);
        Assert.Equal(GonderimYontemi.Elden, evrak.GonderimYontemi);
        Assert.Equal(EvrakOncelik.Normal, evrak.Oncelik);
        Assert.Equal(EvrakGizlilik.Normal, evrak.Gizlilik);
        Assert.Equal(EbysEvrakDurum.Beklemede, evrak.Durum);
        Assert.False(evrak.CevapGerekli);
        Assert.False(evrak.IsDeleted);
    }

    [Fact]
    public void Collections_AreInitialized_NotNull()
    {
        var evrak = new EbysEvrak();

        Assert.NotNull(evrak.AltEvraklar);
        Assert.NotNull(evrak.Dosyalar);
        Assert.NotNull(evrak.Atamalar);
        Assert.NotNull(evrak.Hareketler);
        Assert.Empty(evrak.AltEvraklar);
        Assert.Empty(evrak.Dosyalar);
        Assert.Empty(evrak.Atamalar);
        Assert.Empty(evrak.Hareketler);
    }

    [Fact]
    public void CanAdd_Dosya_ToDosyalarCollection()
    {
        var evrak = new EbysEvrak { EvrakNo = "2026/001" };
        var dosya = new EbysEvrakDosya { DosyaAdi = "rapor.pdf", DosyaYolu = "/files/rapor.pdf" };

        evrak.Dosyalar.Add(dosya);

        Assert.Single(evrak.Dosyalar);
        Assert.Equal("rapor.pdf", evrak.Dosyalar.First().DosyaAdi);
    }

    [Fact]
    public void CanAdd_Atama_ToAtamalarCollection()
    {
        var evrak = new EbysEvrak { EvrakNo = "2026/002" };
        var atama = new EbysEvrakAtama { AtayanKullaniciId = 1, Talimat = "İnceleyin" };

        evrak.Atamalar.Add(atama);

        Assert.Single(evrak.Atamalar);
        Assert.Equal("İnceleyin", evrak.Atamalar.First().Talimat);
    }

    [Fact]
    public void CanAdd_Hareket_ToHareketlerCollection()
    {
        var evrak = new EbysEvrak { EvrakNo = "2026/003" };
        var hareket = new EbysEvrakHareket
        {
            HareketTipi = EbysHareketTipi.Olusturuldu,
            Aciklama = "Evrak oluşturuldu"
        };

        evrak.Hareketler.Add(hareket);

        Assert.Single(evrak.Hareketler);
        Assert.Equal(EbysHareketTipi.Olusturuldu, evrak.Hareketler.First().HareketTipi);
    }

    [Theory]
    [InlineData(EvrakYonu.Gelen)]
    [InlineData(EvrakYonu.Giden)]
    public void Yon_CanBeSet(EvrakYonu yon)
    {
        var evrak = new EbysEvrak { Yon = yon };
        Assert.Equal(yon, evrak.Yon);
    }

    [Theory]
    [InlineData(EvrakOncelik.Dusuk)]
    [InlineData(EvrakOncelik.Normal)]
    [InlineData(EvrakOncelik.Yuksek)]
    [InlineData(EvrakOncelik.Acil)]
    public void Oncelik_CanBeSet(EvrakOncelik oncelik)
    {
        var evrak = new EbysEvrak { Oncelik = oncelik };
        Assert.Equal(oncelik, evrak.Oncelik);
    }

    [Theory]
    [InlineData(EvrakGizlilik.Normal)]
    [InlineData(EvrakGizlilik.Gizli)]
    [InlineData(EvrakGizlilik.CokGizli)]
    public void Gizlilik_CanBeSet(EvrakGizlilik gizlilik)
    {
        var evrak = new EbysEvrak { Gizlilik = gizlilik };
        Assert.Equal(gizlilik, evrak.Gizlilik);
    }

    [Theory]
    [InlineData(EbysEvrakDurum.Taslak)]
    [InlineData(EbysEvrakDurum.Beklemede)]
    [InlineData(EbysEvrakDurum.Isleniyor)]
    [InlineData(EbysEvrakDurum.AtamaBekliyor)]
    [InlineData(EbysEvrakDurum.CevapBekliyor)]
    [InlineData(EbysEvrakDurum.Cevaplandi)]
    [InlineData(EbysEvrakDurum.Tamamlandi)]
    [InlineData(EbysEvrakDurum.Arsivlendi)]
    [InlineData(EbysEvrakDurum.IptalEdildi)]
    public void Durum_CanBeSet(EbysEvrakDurum durum)
    {
        var evrak = new EbysEvrak { Durum = durum };
        Assert.Equal(durum, evrak.Durum);
    }
}

public class EbysEvrakKategoriTests
{
    [Fact]
    public void Default_Values_AreCorrect()
    {
        var kategori = new EbysEvrakKategori();

        Assert.Equal(string.Empty, kategori.KategoriAdi);
        Assert.Equal(0, kategori.SiraNo);
        Assert.True(kategori.Aktif);
        Assert.Equal("#6c757d", kategori.Renk);
        Assert.Equal("bi-folder", kategori.Ikon);
        Assert.NotNull(kategori.Evraklar);
        Assert.Empty(kategori.Evraklar);
    }

    [Fact]
    public void Properties_CanBeSet()
    {
        var kategori = new EbysEvrakKategori
        {
            KategoriAdi = "Resmi Yazışmalar",
            Aciklama = "Kurumlar arası resmi yazışmalar",
            SiraNo = 10,
            Aktif = false,
            Renk = "#1976d2",
            Ikon = "bi-envelope-paper"
        };

        Assert.Equal("Resmi Yazışmalar", kategori.KategoriAdi);
        Assert.Equal("Kurumlar arası resmi yazışmalar", kategori.Aciklama);
        Assert.Equal(10, kategori.SiraNo);
        Assert.False(kategori.Aktif);
        Assert.Equal("#1976d2", kategori.Renk);
        Assert.Equal("bi-envelope-paper", kategori.Ikon);
    }

    [Fact]
    public void CanAdd_Evraklar_ToCollection()
    {
        var kategori = new EbysEvrakKategori { KategoriAdi = "Faturalar" };
        kategori.Evraklar.Add(new EbysEvrak { EvrakNo = "F/001", Konu = "Fatura 1" });
        kategori.Evraklar.Add(new EbysEvrak { EvrakNo = "F/002", Konu = "Fatura 2" });

        Assert.Equal(2, kategori.Evraklar.Count);
    }
}

public class EbysEvrakDosyaTests
{
    [Fact]
    public void Default_Values_AreCorrect()
    {
        var dosya = new EbysEvrakDosya();

        Assert.Equal(0, dosya.EvrakId);
        Assert.Equal(string.Empty, dosya.DosyaAdi);
        Assert.Equal(string.Empty, dosya.DosyaYolu);
        Assert.Equal(0, dosya.DosyaBoyutu);
        Assert.False(dosya.AsilNusha);
        Assert.Equal(1, dosya.VersiyonNo);
        Assert.NotNull(dosya.Versiyonlar);
        Assert.Empty(dosya.Versiyonlar);
    }

    [Fact]
    public void VersiyonNo_StartsAtOne()
    {
        var dosya = new EbysEvrakDosya();
        Assert.Equal(1, dosya.VersiyonNo);
    }

    [Fact]
    public void Properties_CanBeSet()
    {
        var dosya = new EbysEvrakDosya
        {
            EvrakId = 42,
            DosyaAdi = "sozlesme.pdf",
            DosyaYolu = "/uploads/ebys/sozlesme.pdf",
            DosyaTipi = "pdf",
            DosyaBoyutu = 1024 * 1024,
            Aciklama = "İmzalı sözleşme",
            AsilNusha = true,
            VersiyonNo = 3,
            SonDegisiklikNotu = "3. revizyon"
        };

        Assert.Equal(42, dosya.EvrakId);
        Assert.Equal("sozlesme.pdf", dosya.DosyaAdi);
        Assert.Equal("pdf", dosya.DosyaTipi);
        Assert.Equal(1024 * 1024, dosya.DosyaBoyutu);
        Assert.True(dosya.AsilNusha);
        Assert.Equal(3, dosya.VersiyonNo);
        Assert.Equal("3. revizyon", dosya.SonDegisiklikNotu);
    }
}

public class EbysEvrakAtamaTests
{
    [Fact]
    public void Default_Values_AreCorrect()
    {
        var atama = new EbysEvrakAtama();

        Assert.Equal(0, atama.EvrakId);
        Assert.Equal(0, atama.AtayanKullaniciId);
        Assert.Null(atama.AtananKullaniciId);
        Assert.Null(atama.AtananDepartmanId);
        Assert.Equal(AtamaDurum.Beklemede, atama.Durum);
        Assert.True((DateTime.Now - atama.AtamaTarihi).TotalSeconds < 5);
    }

    [Theory]
    [InlineData(AtamaDurum.Beklemede)]
    [InlineData(AtamaDurum.Isleniyor)]
    [InlineData(AtamaDurum.Tamamlandi)]
    [InlineData(AtamaDurum.Reddedildi)]
    [InlineData(AtamaDurum.Devredildi)]
    public void Durum_CanBeSet(AtamaDurum durum)
    {
        var atama = new EbysEvrakAtama { Durum = durum };
        Assert.Equal(durum, atama.Durum);
    }

    [Fact]
    public void Properties_CanBeSet()
    {
        var teslimTarihi = DateTime.Today.AddDays(7);
        var atama = new EbysEvrakAtama
        {
            EvrakId = 10,
            AtananKullaniciId = 5,
            AtananDepartmanId = 2,
            AtayanKullaniciId = 1,
            Talimat = "Lütfen inceleyin ve cevap verin",
            TeslimTarihi = teslimTarihi,
            Durum = AtamaDurum.Isleniyor,
            Sonuc = "İnceleme devam ediyor"
        };

        Assert.Equal(10, atama.EvrakId);
        Assert.Equal(5, atama.AtananKullaniciId);
        Assert.Equal(2, atama.AtananDepartmanId);
        Assert.Equal(1, atama.AtayanKullaniciId);
        Assert.Equal("Lütfen inceleyin ve cevap verin", atama.Talimat);
        Assert.Equal(teslimTarihi, atama.TeslimTarihi);
        Assert.Equal(AtamaDurum.Isleniyor, atama.Durum);
        Assert.Equal("İnceleme devam ediyor", atama.Sonuc);
    }
}

public class EbysEvrakHareketTests
{
    [Fact]
    public void Default_Values_AreCorrect()
    {
        var hareket = new EbysEvrakHareket();

        Assert.Equal(0, hareket.EvrakId);
        Assert.Equal(0, hareket.KullaniciId);
        Assert.Equal(string.Empty, hareket.Aciklama);
        Assert.True((DateTime.Now - hareket.IslemTarihi).TotalSeconds < 5);
    }

    [Theory]
    [InlineData(EbysHareketTipi.Olusturuldu)]
    [InlineData(EbysHareketTipi.Guncellendi)]
    [InlineData(EbysHareketTipi.AtamaYapildi)]
    [InlineData(EbysHareketTipi.DurumDegisti)]
    [InlineData(EbysHareketTipi.DosyaEklendi)]
    [InlineData(EbysHareketTipi.DosyaSilindi)]
    [InlineData(EbysHareketTipi.CevapYazildi)]
    [InlineData(EbysHareketTipi.Arsivlendi)]
    [InlineData(EbysHareketTipi.IptalEdildi)]
    [InlineData(EbysHareketTipi.NotEklendi)]
    [InlineData(EbysHareketTipi.Devredildi)]
    public void HareketTipi_CanBeSet(EbysHareketTipi tip)
    {
        var hareket = new EbysEvrakHareket { HareketTipi = tip };
        Assert.Equal(tip, hareket.HareketTipi);
    }

    [Fact]
    public void EskiDeger_YeniDeger_TracksStateChange()
    {
        var hareket = new EbysEvrakHareket
        {
            HareketTipi = EbysHareketTipi.DurumDegisti,
            EskiDeger = EbysEvrakDurum.Beklemede.ToString(),
            YeniDeger = EbysEvrakDurum.Isleniyor.ToString(),
            Aciklama = "Durum değişikliği"
        };

        Assert.Equal("Beklemede", hareket.EskiDeger);
        Assert.Equal("Isleniyor", hareket.YeniDeger);
    }
}

public class EbysEnumValuesTests
{
    [Fact]
    public void EvrakYonu_HasExpectedValues()
    {
        Assert.Equal(1, (int)EvrakYonu.Gelen);
        Assert.Equal(2, (int)EvrakYonu.Giden);
    }

    [Fact]
    public void EvrakOncelik_HasExpectedValues()
    {
        Assert.Equal(1, (int)EvrakOncelik.Dusuk);
        Assert.Equal(2, (int)EvrakOncelik.Normal);
        Assert.Equal(3, (int)EvrakOncelik.Yuksek);
        Assert.Equal(4, (int)EvrakOncelik.Acil);
    }

    [Fact]
    public void EvrakGizlilik_HasExpectedValues()
    {
        Assert.Equal(1, (int)EvrakGizlilik.Normal);
        Assert.Equal(2, (int)EvrakGizlilik.Gizli);
        Assert.Equal(3, (int)EvrakGizlilik.CokGizli);
    }

    [Fact]
    public void GonderimYontemi_HasExpectedValues()
    {
        Assert.Equal(1, (int)GonderimYontemi.Elden);
        Assert.Equal(2, (int)GonderimYontemi.Posta);
        Assert.Equal(3, (int)GonderimYontemi.Kargo);
        Assert.Equal(4, (int)GonderimYontemi.Email);
        Assert.Equal(5, (int)GonderimYontemi.Faks);
        Assert.Equal(6, (int)GonderimYontemi.KEP);
    }

    [Fact]
    public void EbysEvrakDurum_TaslakIsZero()
    {
        // Durum 0 default olduğu için Taslak özel bir anlam taşır
        Assert.Equal(0, (int)EbysEvrakDurum.Taslak);
    }

    [Fact]
    public void AtamaDurum_HasExpectedValues()
    {
        Assert.Equal(1, (int)AtamaDurum.Beklemede);
        Assert.Equal(2, (int)AtamaDurum.Isleniyor);
        Assert.Equal(3, (int)AtamaDurum.Tamamlandi);
        Assert.Equal(4, (int)AtamaDurum.Reddedildi);
        Assert.Equal(5, (int)AtamaDurum.Devredildi);
    }
}
