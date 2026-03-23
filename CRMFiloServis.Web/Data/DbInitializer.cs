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

        // Eðer veri varsa çýk
        if (await context.Cariler.AnyAsync())
            return;

        // Örnek veriler ekle
        await SeedCarilerAsync(context);
        await SeedSoforlerAsync(context);
        await SeedAraclarAsync(context);
        await SeedMasrafKalemleriAsync(context);
        await SeedGuzergahlarAsync(context);
        await SeedBankaHesaplariAsync(context);
        
        await context.SaveChangesAsync();
    }

    private static async Task SeedCarilerAsync(ApplicationDbContext context)
    {
        var cariler = new List<Cari>
        {
            new()
            {
                CariKodu = "C001",
                Unvan = "ABC Lojistik Ltd. Þti.",
                CariTipi = CariTipi.Musteri,
                VergiDairesi = "Kadýköy",
                VergiNo = "1234567890",
                Telefon = "0216 555 1234",
                Email = "info@abclojistik.com",
                Adres = "Kadýköy, Ýstanbul"
            },
            new()
            {
                CariKodu = "C002",
                Unvan = "XYZ Taþýmacýlýk A.Þ.",
                CariTipi = CariTipi.Musteri,
                VergiDairesi = "Beþiktaþ",
                VergiNo = "9876543210",
                Telefon = "0212 555 5678",
                Email = "info@xyztasima.com",
                Adres = "Beþiktaþ, Ýstanbul"
            },
            new()
            {
                CariKodu = "C003",
                Unvan = "Mega Okul Servisi",
                CariTipi = CariTipi.Musteri,
                VergiDairesi = "Ümraniye",
                VergiNo = "5555555555",
                Telefon = "0216 333 4444",
                Email = "info@megaokul.com",
                Adres = "Ümraniye, Ýstanbul"
            },
            new()
            {
                CariKodu = "T001",
                Unvan = "Oto Yedek Parça San. Tic.",
                CariTipi = CariTipi.Tedarikci,
                VergiDairesi = "Sultanbeyli",
                VergiNo = "1112223334",
                Telefon = "0216 777 8888",
                Email = "satis@otoyedek.com",
                Adres = "Sultanbeyli, Ýstanbul"
            },
            new()
            {
                CariKodu = "T002",
                Unvan = "Akaryakýt Daðýtým A.Þ.",
                CariTipi = CariTipi.Tedarikci,
                VergiDairesi = "Kartal",
                VergiNo = "4443332221",
                Telefon = "0216 999 0000",
                Email = "siparis@akaryakit.com",
                Adres = "Kartal, Ýstanbul"
            }
        };

        await context.Cariler.AddRangeAsync(cariler);
        await context.SaveChangesAsync();
    }

    private static async Task SeedSoforlerAsync(ApplicationDbContext context)
    {
        var soforler = new List<Sofor>
        {
            new()
            {
                SoforKodu = "S001",
                Ad = "Ahmet",
                Soyad = "Yýlmaz",
                TcKimlikNo = "12345678901",
                Telefon = "0532 111 2233",
                Email = "ahmet.yilmaz@email.com",
                EhliyetNo = "B-123456",
                EhliyetGecerlilikTarihi = DateTime.Today.AddYears(3),
                IseBaslamaTarihi = DateTime.Today.AddYears(-2),
                Aktif = true
            },
            new()
            {
                SoforKodu = "S002",
                Ad = "Mehmet",
                Soyad = "Demir",
                TcKimlikNo = "98765432109",
                Telefon = "0533 444 5566",
                Email = "mehmet.demir@email.com",
                EhliyetNo = "B-654321",
                EhliyetGecerlilikTarihi = DateTime.Today.AddYears(2),
                IseBaslamaTarihi = DateTime.Today.AddYears(-1),
                Aktif = true
            },
            new()
            {
                SoforKodu = "S003",
                Ad = "Ali",
                Soyad = "Kaya",
                TcKimlikNo = "11122233344",
                Telefon = "0535 777 8899",
                Email = "ali.kaya@email.com",
                EhliyetNo = "B-111222",
                EhliyetGecerlilikTarihi = DateTime.Today.AddYears(4),
                IseBaslamaTarihi = DateTime.Today.AddMonths(-6),
                Aktif = true
            },
            new()
            {
                SoforKodu = "S004",
                Ad = "Veli",
                Soyad = "Öztürk",
                TcKimlikNo = "55566677788",
                Telefon = "0536 000 1122",
                Email = "veli.ozturk@email.com",
                EhliyetNo = "B-333444",
                EhliyetGecerlilikTarihi = DateTime.Today.AddYears(1),
                IseBaslamaTarihi = DateTime.Today.AddYears(-3),
                Aktif = true
            }
        };

        await context.Soforler.AddRangeAsync(soforler);
        await context.SaveChangesAsync();
    }

    private static async Task SeedAraclarAsync(ApplicationDbContext context)
    {
        var araclar = new List<Arac>
        {
            new()
            {
                Plaka = "34 ABC 123",
                Marka = "Ford",
                Model = "Transit",
                ModelYili = 2022,
                AracTipi = AracTipi.Minibus,
                KoltukSayisi = 16,
                TrafikSigortaBitisTarihi = DateTime.Today.AddMonths(6),
                KaskoBitisTarihi = DateTime.Today.AddMonths(8),
                MuayeneBitisTarihi = DateTime.Today.AddMonths(10),
                KmDurumu = 45000,
                Aktif = true
            },
            new()
            {
                Plaka = "34 XYZ 456",
                Marka = "Mercedes",
                Model = "Sprinter",
                ModelYili = 2021,
                AracTipi = AracTipi.Minibus,
                KoltukSayisi = 20,
                TrafikSigortaBitisTarihi = DateTime.Today.AddMonths(4),
                KaskoBitisTarihi = DateTime.Today.AddMonths(5),
                MuayeneBitisTarihi = DateTime.Today.AddMonths(7),
                KmDurumu = 62000,
                Aktif = true
            },
            new()
            {
                Plaka = "34 DEF 789",
                Marka = "Volkswagen",
                Model = "Crafter",
                ModelYili = 2023,
                AracTipi = AracTipi.Minibus,
                KoltukSayisi = 18,
                TrafikSigortaBitisTarihi = DateTime.Today.AddMonths(11),
                KaskoBitisTarihi = DateTime.Today.AddYears(1),
                MuayeneBitisTarihi = DateTime.Today.AddYears(1).AddMonths(2),
                KmDurumu = 15000,
                Aktif = true
            },
            new()
            {
                Plaka = "34 GHI 012",
                Marka = "Fiat",
                Model = "Ducato",
                ModelYili = 2020,
                AracTipi = AracTipi.Minibus,
                KoltukSayisi = 14,
                TrafikSigortaBitisTarihi = DateTime.Today.AddMonths(2),
                KaskoBitisTarihi = DateTime.Today.AddMonths(3),
                MuayeneBitisTarihi = DateTime.Today.AddMonths(1),
                KmDurumu = 89000,
                Aktif = true
            }
        };

        await context.Araclar.AddRangeAsync(araclar);
        await context.SaveChangesAsync();
    }

    private static async Task SeedMasrafKalemleriAsync(ApplicationDbContext context)
    {
        var masrafKalemleri = new List<MasrafKalemi>
        {
            new() { MasrafKodu = "M001", MasrafAdi = "Yakýt", Kategori = MasrafKategori.Yakit, Aktif = true },
            new() { MasrafKodu = "M002", MasrafAdi = "Bakým", Kategori = MasrafKategori.Bakim, Aktif = true },
            new() { MasrafKodu = "M003", MasrafAdi = "Lastik", Kategori = MasrafKategori.Lastik, Aktif = true },
            new() { MasrafKodu = "M004", MasrafAdi = "Sigorta", Kategori = MasrafKategori.Sigorta, Aktif = true },
            new() { MasrafKodu = "M005", MasrafAdi = "Kasko", Kategori = MasrafKategori.Sigorta, Aktif = true },
            new() { MasrafKodu = "M006", MasrafAdi = "Muayene", Kategori = MasrafKategori.Vergi, Aktif = true },
            new() { MasrafKodu = "M007", MasrafAdi = "Yedek Parça", Kategori = MasrafKategori.YedekParca, Aktif = true },
            new() { MasrafKodu = "M008", MasrafAdi = "Tamir", Kategori = MasrafKategori.Tamir, Aktif = true },
            new() { MasrafKodu = "M009", MasrafAdi = "Yýkama", Kategori = MasrafKategori.Diger, Aktif = true },
            new() { MasrafKodu = "M010", MasrafAdi = "Otopark/HGS", Kategori = MasrafKategori.Diger, Aktif = true }
        };

        await context.MasrafKalemleri.AddRangeAsync(masrafKalemleri);
        await context.SaveChangesAsync();
    }

    private static async Task SeedGuzergahlarAsync(ApplicationDbContext context)
    {
        var cariler = await context.Cariler.Where(c => c.CariTipi == CariTipi.Musteri).ToListAsync();
        
        var guzergahlar = new List<Guzergah>
        {
            new()
            {
                GuzergahKodu = "G001",
                GuzergahAdi = "Kadýköy - Ataþehir Sabah",
                BaslangicNoktasi = "Kadýköy Meydaný",
                BitisNoktasi = "Ataþehir Finans Merkezi",
                Mesafe = 12.5m,
                BirimFiyat = 850,
                CariId = cariler[0].Id,
                Aktif = true
            },
            new()
            {
                GuzergahKodu = "G002",
                GuzergahAdi = "Kadýköy - Ataþehir Akþam",
                BaslangicNoktasi = "Ataþehir Finans Merkezi",
                BitisNoktasi = "Kadýköy Meydaný",
                Mesafe = 12.5m,
                BirimFiyat = 850,
                CariId = cariler[0].Id,
                Aktif = true
            },
            new()
            {
                GuzergahKodu = "G003",
                GuzergahAdi = "Beþiktaþ - Maslak",
                BaslangicNoktasi = "Beþiktaþ Ýskele",
                BitisNoktasi = "Maslak 1453",
                Mesafe = 8.0m,
                BirimFiyat = 650,
                CariId = cariler[1].Id,
                Aktif = true
            },
            new()
            {
                GuzergahKodu = "G004",
                GuzergahAdi = "Ümraniye Okul Servisi",
                BaslangicNoktasi = "Ümraniye Merkez",
                BitisNoktasi = "Çekmeköy Okul Bölgesi",
                Mesafe = 15.0m,
                BirimFiyat = 950,
                CariId = cariler[2].Id,
                Aktif = true
            }
        };

        await context.Guzergahlar.AddRangeAsync(guzergahlar);
        await context.SaveChangesAsync();
    }

    private static async Task SeedBankaHesaplariAsync(ApplicationDbContext context)
    {
        var hesaplar = new List<BankaHesap>
        {
            new()
            {
                HesapKodu = "K001",
                HesapAdi = "Ana Kasa",
                HesapTipi = HesapTipi.Kasa,
                ParaBirimi = "TRY",
                AcilisBakiye = 10000,
                Aktif = true,
                Notlar = "Günlük iþlemler için ana kasa"
            },
            new()
            {
                HesapKodu = "B001",
                HesapAdi = "Garanti TL Hesabý",
                HesapTipi = HesapTipi.VadesizHesap,
                BankaAdi = "Garanti BBVA",
                SubeAdi = "Kadýköy Þubesi",
                SubeKodu = "123",
                HesapNo = "6543210",
                Iban = "TR12 0006 2000 0000 0006 5432 10",
                ParaBirimi = "TRY",
                AcilisBakiye = 50000,
                Aktif = true
            },
            new()
            {
                HesapKodu = "B002",
                HesapAdi = "Ýþ Bankasý TL Hesabý",
                HesapTipi = HesapTipi.VadesizHesap,
                BankaAdi = "Türkiye Ýþ Bankasý",
                SubeAdi = "Ataþehir Þubesi",
                SubeKodu = "456",
                HesapNo = "1234567",
                Iban = "TR98 0006 4000 0011 2345 6700 01",
                ParaBirimi = "TRY",
                AcilisBakiye = 25000,
                Aktif = true
            }
        };

        await context.BankaHesaplari.AddRangeAsync(hesaplar);
        await context.SaveChangesAsync();
    }

    public static async Task SeedBudgetMasrafKalemleriAsync(ApplicationDbContext context)
    {
        if (await context.BudgetMasrafKalemleri.AnyAsync())
            return;

        var kalemler = new List<BudgetMasrafKalemi>
        {
            new() { KalemAdi = "Kira", Kategori = "Sabit Gider", Renk = "#dc3545", Icon = "bi-house", SiraNo = 1 },
            new() { KalemAdi = "Elektrik", Kategori = "Fatura", Renk = "#ffc107", Icon = "bi-lightning", SiraNo = 2 },
            new() { KalemAdi = "Su", Kategori = "Fatura", Renk = "#0dcaf0", Icon = "bi-droplet", SiraNo = 3 },
            new() { KalemAdi = "Doðalgaz", Kategori = "Fatura", Renk = "#fd7e14", Icon = "bi-fire", SiraNo = 4 },
            new() { KalemAdi = "Ýnternet", Kategori = "Fatura", Renk = "#6610f2", Icon = "bi-wifi", SiraNo = 5 },
            new() { KalemAdi = "Telefon", Kategori = "Fatura", Renk = "#20c997", Icon = "bi-phone", SiraNo = 6 },
            new() { KalemAdi = "Personel Maaþ", Kategori = "Personel", Renk = "#0d6efd", Icon = "bi-people", SiraNo = 7 },
            new() { KalemAdi = "SGK Primi", Kategori = "Personel", Renk = "#198754", Icon = "bi-shield-check", SiraNo = 8 },
            new() { KalemAdi = "Vergi", Kategori = "Resmi", Renk = "#6c757d", Icon = "bi-bank", SiraNo = 9 },
            new() { KalemAdi = "Sigorta", Kategori = "Sabit Gider", Renk = "#d63384", Icon = "bi-shield", SiraNo = 10 },
            new() { KalemAdi = "Yakýt", Kategori = "Araç", Renk = "#212529", Icon = "bi-fuel-pump", SiraNo = 11 },
            new() { KalemAdi = "Araç Bakým", Kategori = "Araç", Renk = "#495057", Icon = "bi-tools", SiraNo = 12 },
            new() { KalemAdi = "Kredi Taksiti", Kategori = "Kredi", Renk = "#e74c3c", Icon = "bi-credit-card", SiraNo = 13 },
            new() { KalemAdi = "Araç Kredisi", Kategori = "Kredi", Renk = "#c0392b", Icon = "bi-truck", SiraNo = 14 },
            new() { KalemAdi = "Ofis Giderleri", Kategori = "Genel", Renk = "#9b59b6", Icon = "bi-building", SiraNo = 15 },
            new() { KalemAdi = "Reklam/Pazarlama", Kategori = "Genel", Renk = "#3498db", Icon = "bi-megaphone", SiraNo = 16 },
            new() { KalemAdi = "Diðer", Kategori = "Genel", Renk = "#95a5a6", Icon = "bi-three-dots", SiraNo = 99 }
        };

        await context.BudgetMasrafKalemleri.AddRangeAsync(kalemler);
        await context.SaveChangesAsync();
    }
}
