CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL,
    CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId")
);

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "AktiviteLoglar" (
        "Id" INTEGER NOT NULL,
        "IslemZamani" TEXT NOT NULL,
        "IslemTipi" TEXT NOT NULL,
        "Modul" TEXT NOT NULL,
        "EntityTipi" TEXT,
        "EntityId" INTEGER,
        "EntityAdi" TEXT,
        "Aciklama" TEXT,
        "EskiDeger" TEXT,
        "YeniDeger" TEXT,
        "KullaniciAdi" TEXT,
        "IpAdresi" TEXT,
        "Tarayici" TEXT,
        "Seviye" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_AktiviteLoglar" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "AracMarkalari" (
        "Id" INTEGER NOT NULL,
        "MarkaAdi" TEXT NOT NULL,
        "Logo" TEXT,
        "SiraNo" INTEGER NOT NULL,
        "Aktif" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_AracMarkalari" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "BankaHesaplari" (
        "Id" INTEGER NOT NULL,
        "HesapKodu" TEXT NOT NULL,
        "HesapAdi" TEXT NOT NULL,
        "HesapTipi" INTEGER NOT NULL,
        "BankaAdi" TEXT,
        "SubeAdi" TEXT,
        "SubeKodu" TEXT,
        "HesapNo" TEXT,
        "Iban" TEXT,
        "ParaBirimi" TEXT,
        "AcilisBakiye" TEXT NOT NULL,
        "Aktif" INTEGER NOT NULL,
        "Notlar" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_BankaHesaplari" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "BudgetMasrafKalemleri" (
        "Id" INTEGER NOT NULL,
        "KalemAdi" TEXT NOT NULL,
        "Kategori" TEXT,
        "Renk" TEXT,
        "Icon" TEXT,
        "Aktif" INTEGER NOT NULL,
        "SiraNo" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_BudgetMasrafKalemleri" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "Firmalar" (
        "Id" INTEGER NOT NULL,
        "FirmaKodu" TEXT NOT NULL,
        "FirmaAdi" TEXT NOT NULL,
        "UnvanTam" TEXT,
        "VergiNo" TEXT,
        "VergiDairesi" TEXT,
        "Adres" TEXT,
        "Il" TEXT,
        "Ilce" TEXT,
        "Telefon" TEXT,
        "Email" TEXT,
        "WebSite" TEXT,
        "Logo" TEXT,
        "Aktif" INTEGER NOT NULL,
        "VarsayilanFirma" INTEGER NOT NULL,
        "SiraNo" INTEGER NOT NULL,
        "AktifDonemYil" INTEGER NOT NULL,
        "AktifDonemAy" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_Firmalar" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "Lisanslar" (
        "Id" INTEGER NOT NULL,
        "LisansAnahtari" TEXT NOT NULL,
        "Tur" INTEGER NOT NULL,
        "BaslangicTarihi" TEXT NOT NULL,
        "BitisTarihi" TEXT NOT NULL,
        "FirmaAdi" TEXT,
        "YetkiliKisi" TEXT,
        "Email" TEXT,
        "Telefon" TEXT,
        "MakineKodu" TEXT NOT NULL,
        "MaxKullaniciSayisi" INTEGER NOT NULL,
        "ExcelExportIzni" INTEGER NOT NULL,
        "PdfExportIzni" INTEGER NOT NULL,
        "RaporlamaIzni" INTEGER NOT NULL,
        "YedeklemeIzni" INTEGER NOT NULL,
        "MuhasebeIzni" INTEGER NOT NULL,
        "SatisModuluIzni" INTEGER NOT NULL,
        "Imza" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_Lisanslar" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "MasrafKalemleri" (
        "Id" INTEGER NOT NULL,
        "MasrafKodu" TEXT NOT NULL,
        "MasrafAdi" TEXT NOT NULL,
        "Kategori" INTEGER NOT NULL,
        "Aktif" INTEGER NOT NULL,
        "Notlar" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_MasrafKalemleri" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "MuhasebeDonemleri" (
        "Id" INTEGER NOT NULL,
        "Yil" INTEGER NOT NULL,
        "Ay" INTEGER NOT NULL,
        "BaslangicTarihi" TEXT NOT NULL,
        "BitisTarihi" TEXT NOT NULL,
        "Durum" INTEGER NOT NULL,
        "KapanisTarihi" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_MuhasebeDonemleri" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "MuhasebeFisleri" (
        "Id" INTEGER NOT NULL,
        "FisNo" TEXT NOT NULL,
        "FisTarihi" TEXT NOT NULL,
        "FisTipi" INTEGER NOT NULL,
        "Aciklama" TEXT,
        "ToplamBorc" TEXT NOT NULL,
        "ToplamAlacak" TEXT NOT NULL,
        "Durum" INTEGER NOT NULL,
        "Kaynak" INTEGER NOT NULL,
        "KaynakId" INTEGER,
        "KaynakTip" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_MuhasebeFisleri" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "MuhasebeHesaplari" (
        "Id" INTEGER NOT NULL,
        "HesapKodu" TEXT NOT NULL,
        "HesapAdi" TEXT NOT NULL,
        "HesapTuru" INTEGER NOT NULL,
        "HesapGrubu" INTEGER NOT NULL,
        "UstHesapId" INTEGER,
        "AltHesapVar" INTEGER NOT NULL,
        "Aktif" INTEGER NOT NULL,
        "SistemHesabi" INTEGER NOT NULL,
        "Aciklama" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_MuhasebeHesaplari" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MuhasebeHesaplari_MuhasebeHesaplari_UstHesapId" FOREIGN KEY ("UstHesapId") REFERENCES "MuhasebeHesaplari" ("Id") ON DELETE RESTRICT
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "Roller" (
        "Id" INTEGER NOT NULL,
        "RolAdi" TEXT NOT NULL,
        "Aciklama" TEXT,
        "SistemRolu" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_Roller" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "SatisPersonelleri" (
        "Id" INTEGER NOT NULL,
        "PersonelKodu" TEXT NOT NULL,
        "AdSoyad" TEXT NOT NULL,
        "Telefon" TEXT,
        "Email" TEXT,
        "Aktif" INTEGER NOT NULL,
        "KomisyonOrani" TEXT NOT NULL,
        "SabitKomisyon" TEXT NOT NULL,
        "AylikSatisHedefi" TEXT NOT NULL,
        "AylikAracHedefi" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_SatisPersonelleri" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "Soforler" (
        "Id" INTEGER NOT NULL,
        "SoforKodu" TEXT NOT NULL,
        "Ad" TEXT NOT NULL,
        "Soyad" TEXT NOT NULL,
        "TcKimlikNo" TEXT,
        "Telefon" TEXT,
        "Email" TEXT,
        "Adres" TEXT,
        "Gorev" INTEGER NOT NULL,
        "Departman" TEXT,
        "Pozisyon" TEXT,
        "EhliyetNo" TEXT,
        "EhliyetGecerlilikTarihi" TEXT,
        "SrcBelgesiGecerlilikTarihi" TEXT,
        "PsikoteknikGecerlilikTarihi" TEXT,
        "SaglikRaporuGecerlilikTarihi" TEXT,
        "IseBaslamaTarihi" TEXT,
        "IstenAyrilmaTarihi" TEXT,
        "Aktif" INTEGER NOT NULL,
        "Notlar" TEXT,
        "BrutMaas" TEXT NOT NULL,
        "NetMaas" TEXT NOT NULL,
        "BankaAdi" TEXT,
        "IBAN" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_Soforler" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "AracModelleri" (
        "Id" INTEGER NOT NULL,
        "MarkaId" INTEGER NOT NULL,
        "ModelAdi" TEXT NOT NULL,
        "BaslangicYili" INTEGER NOT NULL,
        "BitisYili" INTEGER,
        "VarsayilanKasaTipi" INTEGER NOT NULL,
        "Aktif" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_AracModelleri" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AracModelleri_AracMarkalari_MarkaId" FOREIGN KEY ("MarkaId") REFERENCES "AracMarkalari" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "Cariler" (
        "Id" INTEGER NOT NULL,
        "CariKodu" TEXT NOT NULL,
        "Unvan" TEXT NOT NULL,
        "CariTipi" INTEGER NOT NULL,
        "VergiDairesi" TEXT,
        "VergiNo" TEXT,
        "TcKimlikNo" TEXT,
        "Adres" TEXT,
        "Telefon" TEXT,
        "Email" TEXT,
        "YetkiliKisi" TEXT,
        "Notlar" TEXT,
        "Aktif" INTEGER NOT NULL,
        "Borc" TEXT NOT NULL,
        "Alacak" TEXT NOT NULL,
        "MuhasebeHesapId" INTEGER,
        "FirmaId" INTEGER,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_Cariler" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Cariler_Firmalar_FirmaId" FOREIGN KEY ("FirmaId") REFERENCES "Firmalar" ("Id"),
        CONSTRAINT "FK_Cariler_MuhasebeHesaplari_MuhasebeHesapId" FOREIGN KEY ("MuhasebeHesapId") REFERENCES "MuhasebeHesaplari" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "RolYetkileri" (
        "Id" INTEGER NOT NULL,
        "RolId" INTEGER NOT NULL,
        "YetkiKodu" TEXT NOT NULL,
        "Izin" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_RolYetkileri" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_RolYetkileri_Roller_RolId" FOREIGN KEY ("RolId") REFERENCES "Roller" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "Kullanicilar" (
        "Id" INTEGER NOT NULL,
        "KullaniciAdi" TEXT NOT NULL,
        "SifreHash" TEXT NOT NULL,
        "AdSoyad" TEXT NOT NULL,
        "Email" TEXT,
        "Telefon" TEXT,
        "SoforId" INTEGER,
        "RolId" INTEGER NOT NULL,
        "Aktif" INTEGER NOT NULL,
        "SonGirisTarihi" TEXT,
        "BasarisizGirisSayisi" INTEGER NOT NULL,
        "Kilitli" INTEGER NOT NULL,
        "Tema" TEXT NOT NULL,
        "KompaktMod" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_Kullanicilar" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Kullanicilar_Roller_RolId" FOREIGN KEY ("RolId") REFERENCES "Roller" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_Kullanicilar_Soforler_SoforId" FOREIGN KEY ("SoforId") REFERENCES "Soforler" ("Id") ON DELETE SET NULL
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "PersonelIzinHaklari" (
        "Id" INTEGER NOT NULL,
        "SoforId" INTEGER NOT NULL,
        "Yil" INTEGER NOT NULL,
        "YillikIzinHakki" INTEGER NOT NULL,
        "KullanilanIzin" INTEGER NOT NULL,
        "DevirenIzin" INTEGER NOT NULL,
        "Notlar" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_PersonelIzinHaklari" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_PersonelIzinHaklari_Soforler_SoforId" FOREIGN KEY ("SoforId") REFERENCES "Soforler" ("Id") ON DELETE RESTRICT
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "PersonelIzinleri" (
        "Id" INTEGER NOT NULL,
        "SoforId" INTEGER NOT NULL,
        "IzinTipi" INTEGER NOT NULL,
        "BaslangicTarihi" TEXT NOT NULL,
        "BitisTarihi" TEXT NOT NULL,
        "Durum" INTEGER NOT NULL,
        "OnaylayanKisi" TEXT,
        "OnayTarihi" TEXT,
        "RedNedeni" TEXT,
        "Aciklama" TEXT,
        "Notlar" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_PersonelIzinleri" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_PersonelIzinleri_Soforler_SoforId" FOREIGN KEY ("SoforId") REFERENCES "Soforler" ("Id") ON DELETE RESTRICT
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "PersonelMaaslari" (
        "Id" INTEGER NOT NULL,
        "SoforId" INTEGER NOT NULL,
        "Yil" INTEGER NOT NULL,
        "Ay" INTEGER NOT NULL,
        "BrutMaas" TEXT NOT NULL,
        "NetMaas" TEXT NOT NULL,
        "SGKIsciPayi" TEXT NOT NULL,
        "SGKIsverenPayi" TEXT NOT NULL,
        "GelirVergisi" TEXT NOT NULL,
        "DamgaVergisi" TEXT NOT NULL,
        "IssizlikPrimi" TEXT NOT NULL,
        "Prim" TEXT NOT NULL,
        "Ikramiye" TEXT NOT NULL,
        "Yemek" TEXT NOT NULL,
        "Yol" TEXT NOT NULL,
        "Mesai" TEXT NOT NULL,
        "DigerEklemeler" TEXT NOT NULL,
        "Avans" TEXT NOT NULL,
        "IcraTakibi" TEXT NOT NULL,
        "DigerKesintiler" TEXT NOT NULL,
        "OdemeTarihi" TEXT,
        "OdemeDurum" INTEGER NOT NULL,
        "OdemeAciklama" TEXT,
        "CalismaGunu" INTEGER NOT NULL,
        "IzinliGun" INTEGER NOT NULL,
        "RaporluGun" INTEGER NOT NULL,
        "DevamsizlikGun" INTEGER NOT NULL,
        "Notlar" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_PersonelMaaslari" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_PersonelMaaslari_Soforler_SoforId" FOREIGN KEY ("SoforId") REFERENCES "Soforler" ("Id") ON DELETE RESTRICT
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "PersonelPuantajlar" (
        "Id" INTEGER NOT NULL,
        "FirmaId" INTEGER NOT NULL,
        "PersonelId" INTEGER NOT NULL,
        "Yil" INTEGER NOT NULL,
        "Ay" INTEGER NOT NULL,
        "CalisilanGun" INTEGER NOT NULL,
        "FazlaMesaiSaat" TEXT NOT NULL,
        "IzinGunu" INTEGER NOT NULL,
        "MazeretGunu" INTEGER NOT NULL,
        "BrutMaas" TEXT NOT NULL,
        "YemekUcreti" TEXT NOT NULL,
        "YolUcreti" TEXT NOT NULL,
        "Prim" TEXT NOT NULL,
        "DigerOdeme" TEXT NOT NULL,
        "SgkKesinti" TEXT NOT NULL,
        "GelirVergisi" TEXT NOT NULL,
        "DamgaVergisi" TEXT NOT NULL,
        "DigerKesinti" TEXT NOT NULL,
        "NetOdeme" TEXT NOT NULL,
        "OdemeTarihi" TEXT,
        "Odendi" INTEGER NOT NULL,
        "BankaHesapNo" TEXT,
        "Aciklama" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_PersonelPuantajlar" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_PersonelPuantajlar_Firmalar_FirmaId" FOREIGN KEY ("FirmaId") REFERENCES "Firmalar" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_PersonelPuantajlar_Soforler_PersonelId" FOREIGN KEY ("PersonelId") REFERENCES "Soforler" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "AracIlanlari" (
        "Id" INTEGER NOT NULL,
        "Plaka" TEXT NOT NULL,
        "Marka" TEXT NOT NULL,
        "Model" TEXT NOT NULL,
        "ModelYili" INTEGER NOT NULL,
        "Versiyon" TEXT,
        "Kilometre" INTEGER NOT NULL,
        "YakitTuru" INTEGER NOT NULL,
        "VitesTuru" INTEGER NOT NULL,
        "KasaTipi" INTEGER NOT NULL,
        "Renk" INTEGER NOT NULL,
        "Durum" INTEGER NOT NULL,
        "Boyali" INTEGER NOT NULL,
        "BoyaliParcaSayisi" INTEGER NOT NULL,
        "BoyaliParcalar" TEXT,
        "DegisenVar" INTEGER NOT NULL,
        "DegisenParcaSayisi" INTEGER NOT NULL,
        "DegisenParcalar" TEXT,
        "HasarKaydi" INTEGER NOT NULL,
        "HasarAciklama" TEXT,
        "TramerKaydi" INTEGER NOT NULL,
        "TramerTutari" TEXT NOT NULL,
        "AlisFiyati" TEXT NOT NULL,
        "SatisFiyati" TEXT NOT NULL,
        "KaskoDegeri" TEXT NOT NULL,
        "PiyasaDegeriMin" TEXT NOT NULL,
        "PiyasaDegeriMax" TEXT NOT NULL,
        "PiyasaDegeriOrtalama" TEXT NOT NULL,
        "IlanDurum" INTEGER NOT NULL,
        "IlanTarihi" TEXT NOT NULL,
        "SatisTarihi" TEXT,
        "Aciklama" TEXT,
        "Notlar" TEXT,
        "Fotograflar" TEXT,
        "SahipCariId" INTEGER,
        "SatisPersoneliId" INTEGER,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_AracIlanlari" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AracIlanlari_Cariler_SahipCariId" FOREIGN KEY ("SahipCariId") REFERENCES "Cariler" ("Id") ON DELETE SET NULL,
        CONSTRAINT "FK_AracIlanlari_SatisPersonelleri_SatisPersoneliId" FOREIGN KEY ("SatisPersoneliId") REFERENCES "SatisPersonelleri" ("Id") ON DELETE SET NULL
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "Araclar" (
        "Id" INTEGER NOT NULL,
        "Plaka" TEXT NOT NULL,
        "Marka" TEXT,
        "Model" TEXT,
        "ModelYili" INTEGER,
        "SaseNo" TEXT,
        "MotorNo" TEXT,
        "Renk" TEXT,
        "KoltukSayisi" INTEGER NOT NULL,
        "AracTipi" INTEGER NOT NULL,
        "SahiplikTipi" INTEGER NOT NULL,
        "KiralikCariId" INTEGER,
        "GunlukKiraBedeli" TEXT,
        "AylikKiraBedeli" TEXT,
        "SeferBasinaKiraBedeli" TEXT,
        "KiraHesaplamaTipi" INTEGER,
        "KomisyonVar" INTEGER NOT NULL,
        "KomisyoncuCariId" INTEGER,
        "KomisyonOrani" TEXT,
        "SabitKomisyonTutari" TEXT,
        "KomisyonHesaplamaTipi" INTEGER,
        "TrafikSigortaBitisTarihi" TEXT,
        "KaskoBitisTarihi" TEXT,
        "MuayeneBitisTarihi" TEXT,
        "KmDurumu" INTEGER,
        "Aktif" INTEGER NOT NULL,
        "Notlar" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_Araclar" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Araclar_Cariler_KiralikCariId" FOREIGN KEY ("KiralikCariId") REFERENCES "Cariler" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_Araclar_Cariler_KomisyoncuCariId" FOREIGN KEY ("KomisyoncuCariId") REFERENCES "Cariler" ("Id") ON DELETE RESTRICT
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "AylikOdemePlanlari" (
        "Id" INTEGER NOT NULL,
        "FirmaId" INTEGER NOT NULL,
        "OdemeAdi" TEXT NOT NULL,
        "Turu" INTEGER NOT NULL,
        "AylikTutar" TEXT NOT NULL,
        "OdemeGunu" INTEGER NOT NULL,
        "BaslangicTarihi" TEXT NOT NULL,
        "BitisTarihi" TEXT,
        "OtomatikKayitOlustur" INTEGER NOT NULL,
        "CariId" INTEGER,
        "BankaHesapId" INTEGER,
        "MasrafKalemiId" INTEGER,
        "Aciklama" TEXT,
        "Aktif" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_AylikOdemePlanlari" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AylikOdemePlanlari_BankaHesaplari_BankaHesapId" FOREIGN KEY ("BankaHesapId") REFERENCES "BankaHesaplari" ("Id"),
        CONSTRAINT "FK_AylikOdemePlanlari_Cariler_CariId" FOREIGN KEY ("CariId") REFERENCES "Cariler" ("Id"),
        CONSTRAINT "FK_AylikOdemePlanlari_Firmalar_FirmaId" FOREIGN KEY ("FirmaId") REFERENCES "Firmalar" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_AylikOdemePlanlari_MasrafKalemleri_MasrafKalemiId" FOREIGN KEY ("MasrafKalemiId") REFERENCES "MasrafKalemleri" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "BankaKasaHareketleri" (
        "Id" INTEGER NOT NULL,
        "IslemNo" TEXT NOT NULL,
        "IslemTarihi" TEXT NOT NULL,
        "HareketTipi" INTEGER NOT NULL,
        "Tutar" TEXT NOT NULL,
        "Aciklama" TEXT,
        "BelgeNo" TEXT,
        "IslemKaynak" INTEGER NOT NULL,
        "BankaHesapId" INTEGER NOT NULL,
        "CariId" INTEGER,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_BankaKasaHareketleri" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_BankaKasaHareketleri_BankaHesaplari_BankaHesapId" FOREIGN KEY ("BankaHesapId") REFERENCES "BankaHesaplari" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_BankaKasaHareketleri_Cariler_CariId" FOREIGN KEY ("CariId") REFERENCES "Cariler" ("Id") ON DELETE SET NULL
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "Faturalar" (
        "Id" INTEGER NOT NULL,
        "FaturaNo" TEXT NOT NULL,
        "FaturaTarihi" TEXT NOT NULL,
        "VadeTarihi" TEXT,
        "FaturaTipi" INTEGER NOT NULL,
        "Durum" INTEGER NOT NULL,
        "EFaturaTipi" INTEGER NOT NULL,
        "FaturaYonu" INTEGER NOT NULL,
        "EttnNo" TEXT,
        "GibKodu" TEXT,
        "GibOnayTarihi" TEXT,
        "ImportKaynak" TEXT,
        "FirmaId" INTEGER,
        "AraToplam" TEXT NOT NULL,
        "IskontoTutar" TEXT NOT NULL,
        "KdvOrani" TEXT NOT NULL,
        "KdvTutar" TEXT NOT NULL,
        "GenelToplam" TEXT NOT NULL,
        "OdenenTutar" TEXT NOT NULL,
        "Aciklama" TEXT,
        "Notlar" TEXT,
        "CariId" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_Faturalar" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Faturalar_Cariler_CariId" FOREIGN KEY ("CariId") REFERENCES "Cariler" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_Faturalar_Firmalar_FirmaId" FOREIGN KEY ("FirmaId") REFERENCES "Firmalar" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "Guzergahlar" (
        "Id" INTEGER NOT NULL,
        "GuzergahKodu" TEXT NOT NULL,
        "GuzergahAdi" TEXT NOT NULL,
        "BaslangicNoktasi" TEXT,
        "BitisNoktasi" TEXT,
        "BirimFiyat" TEXT NOT NULL,
        "Mesafe" TEXT,
        "TahminiSure" INTEGER,
        "Aktif" INTEGER NOT NULL,
        "Notlar" TEXT,
        "CariId" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_Guzergahlar" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Guzergahlar_Cariler_CariId" FOREIGN KEY ("CariId") REFERENCES "Cariler" ("Id") ON DELETE RESTRICT
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "KiralamaAraclar" (
        "Id" INTEGER NOT NULL,
        "FirmaId" INTEGER NOT NULL,
        "KiralayıcıCariId" INTEGER NOT NULL,
        "Plaka" TEXT NOT NULL,
        "Marka" TEXT,
        "Model" TEXT,
        "ModelYili" INTEGER,
        "AracTipi" INTEGER NOT NULL,
        "KoltukSayisi" INTEGER,
        "KiralamaBaslangic" TEXT NOT NULL,
        "KiralamaBitis" TEXT,
        "GunlukKiraBedeli" TEXT,
        "SeferBasinaKiraBedeli" TEXT,
        "AylikKiraBedeli" TEXT,
        "KomisyonOrani" TEXT,
        "SabitKomisyonTutari" TEXT,
        "SozlesmeNo" TEXT,
        "Notlar" TEXT,
        "Aktif" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_KiralamaAraclar" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_KiralamaAraclar_Cariler_KiralayıcıCariId" FOREIGN KEY ("KiralayıcıCariId") REFERENCES "Cariler" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_KiralamaAraclar_Firmalar_FirmaId" FOREIGN KEY ("FirmaId") REFERENCES "Firmalar" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "MuhasebeFisKalemleri" (
        "Id" INTEGER NOT NULL,
        "FisId" INTEGER NOT NULL,
        "HesapId" INTEGER NOT NULL,
        "SiraNo" INTEGER NOT NULL,
        "Borc" TEXT NOT NULL,
        "Alacak" TEXT NOT NULL,
        "Aciklama" TEXT,
        "CariId" INTEGER,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_MuhasebeFisKalemleri" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_MuhasebeFisKalemleri_Cariler_CariId" FOREIGN KEY ("CariId") REFERENCES "Cariler" ("Id") ON DELETE SET NULL,
        CONSTRAINT "FK_MuhasebeFisKalemleri_MuhasebeFisleri_FisId" FOREIGN KEY ("FisId") REFERENCES "MuhasebeFisleri" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_MuhasebeFisKalemleri_MuhasebeHesaplari_HesapId" FOREIGN KEY ("HesapId") REFERENCES "MuhasebeHesaplari" ("Id") ON DELETE RESTRICT
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "AracSatislari" (
        "Id" INTEGER NOT NULL,
        "AracIlanId" INTEGER NOT NULL,
        "AliciCariId" INTEGER,
        "SatisPersoneliId" INTEGER,
        "SatisTarihi" TEXT NOT NULL,
        "SatisFiyati" TEXT NOT NULL,
        "KomisyonTutari" TEXT NOT NULL,
        "OdemeSekli" INTEGER NOT NULL,
        "Notlar" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_AracSatislari" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AracSatislari_AracIlanlari_AracIlanId" FOREIGN KEY ("AracIlanId") REFERENCES "AracIlanlari" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_AracSatislari_Cariler_AliciCariId" FOREIGN KEY ("AliciCariId") REFERENCES "Cariler" ("Id") ON DELETE SET NULL,
        CONSTRAINT "FK_AracSatislari_SatisPersonelleri_SatisPersoneliId" FOREIGN KEY ("SatisPersoneliId") REFERENCES "SatisPersonelleri" ("Id") ON DELETE SET NULL
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "PiyasaIlanlari" (
        "Id" INTEGER NOT NULL,
        "AracIlanId" INTEGER NOT NULL,
        "Kaynak" INTEGER NOT NULL,
        "IlanUrl" TEXT,
        "IlanNo" TEXT,
        "Fiyat" TEXT NOT NULL,
        "Sehir" TEXT,
        "Ilce" TEXT,
        "Kilometre" INTEGER NOT NULL,
        "Yil" INTEGER NOT NULL,
        "Durum" TEXT,
        "BoyaliParca" INTEGER NOT NULL,
        "DegisenParca" INTEGER NOT NULL,
        "TramerVar" INTEGER NOT NULL,
        "TramerTutari" TEXT,
        "TaramaTarihi" TEXT NOT NULL,
        "EkBilgiler" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_PiyasaIlanlari" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_PiyasaIlanlari_AracIlanlari_AracIlanId" FOREIGN KEY ("AracIlanId") REFERENCES "AracIlanlari" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "AracEvraklari" (
        "Id" INTEGER NOT NULL,
        "AracId" INTEGER NOT NULL,
        "EvrakKategorisi" TEXT NOT NULL,
        "EvrakAdi" TEXT,
        "Aciklama" TEXT,
        "BaslangicTarihi" TEXT,
        "BitisTarihi" TEXT,
        "HatirlatmaTarihi" TEXT,
        "Tutar" TEXT,
        "SigortaSirketi" TEXT,
        "PoliceNo" TEXT,
        "Durum" INTEGER NOT NULL,
        "HatirlatmaAktif" INTEGER NOT NULL,
        "HatirlatmaGunOnce" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_AracEvraklari" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AracEvraklari_Araclar_AracId" FOREIGN KEY ("AracId") REFERENCES "Araclar" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "AylikOdemeGerceklesenler" (
        "Id" INTEGER NOT NULL,
        "AylikOdemePlaniId" INTEGER NOT NULL,
        "FirmaId" INTEGER NOT NULL,
        "Yil" INTEGER NOT NULL,
        "Ay" INTEGER NOT NULL,
        "PlanlananTutar" TEXT NOT NULL,
        "OdenenTutar" TEXT NOT NULL,
        "OdemeTarihi" TEXT,
        "BankaKasaHareketId" INTEGER,
        "Durum" INTEGER NOT NULL,
        "Aciklama" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_AylikOdemeGerceklesenler" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AylikOdemeGerceklesenler_AylikOdemePlanlari_AylikOdemePlaniId" FOREIGN KEY ("AylikOdemePlaniId") REFERENCES "AylikOdemePlanlari" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_AylikOdemeGerceklesenler_BankaKasaHareketleri_BankaKasaHareketId" FOREIGN KEY ("BankaKasaHareketId") REFERENCES "BankaKasaHareketleri" ("Id"),
        CONSTRAINT "FK_AylikOdemeGerceklesenler_Firmalar_FirmaId" FOREIGN KEY ("FirmaId") REFERENCES "Firmalar" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "BudgetOdemeler" (
        "Id" INTEGER NOT NULL,
        "OdemeTarihi" TEXT NOT NULL,
        "OdemeAy" INTEGER NOT NULL,
        "OdemeYil" INTEGER NOT NULL,
        "MasrafKalemi" TEXT NOT NULL,
        "Aciklama" TEXT,
        "Miktar" TEXT NOT NULL,
        "FirmaId" INTEGER,
        "TaksitliMi" INTEGER NOT NULL,
        "ToplamTaksitSayisi" INTEGER NOT NULL,
        "KacinciTaksit" INTEGER NOT NULL,
        "TaksitGrupId" TEXT,
        "TaksitBaslangicAy" TEXT,
        "TaksitBitisAy" TEXT,
        "Durum" INTEGER NOT NULL,
        "Notlar" TEXT,
        "GercekOdemeTarihi" TEXT,
        "OdemeYapildigiHesapId" INTEGER,
        "OdenenTutar" TEXT,
        "OdemeNotu" TEXT,
        "BankaKasaHareketId" INTEGER,
        "FaturaId" INTEGER,
        "FaturaIleKapatildi" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_BudgetOdemeler" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_BudgetOdemeler_BankaHesaplari_OdemeYapildigiHesapId" FOREIGN KEY ("OdemeYapildigiHesapId") REFERENCES "BankaHesaplari" ("Id"),
        CONSTRAINT "FK_BudgetOdemeler_Faturalar_FaturaId" FOREIGN KEY ("FaturaId") REFERENCES "Faturalar" ("Id"),
        CONSTRAINT "FK_BudgetOdemeler_Firmalar_FirmaId" FOREIGN KEY ("FirmaId") REFERENCES "Firmalar" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "FaturaKalemleri" (
        "Id" INTEGER NOT NULL,
        "SiraNo" INTEGER NOT NULL,
        "Aciklama" TEXT NOT NULL,
        "Miktar" TEXT NOT NULL,
        "Birim" TEXT NOT NULL,
        "BirimFiyat" TEXT NOT NULL,
        "KdvOrani" TEXT NOT NULL,
        "KdvTutar" TEXT NOT NULL,
        "ToplamTutar" TEXT NOT NULL,
        "FaturaId" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_FaturaKalemleri" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_FaturaKalemleri_Faturalar_FaturaId" FOREIGN KEY ("FaturaId") REFERENCES "Faturalar" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "OdemeEslestirmeleri" (
        "Id" INTEGER NOT NULL,
        "EslestirmeTarihi" TEXT NOT NULL,
        "EslestirilenTutar" TEXT NOT NULL,
        "Aciklama" TEXT,
        "FaturaId" INTEGER NOT NULL,
        "BankaKasaHareketId" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_OdemeEslestirmeleri" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_OdemeEslestirmeleri_BankaKasaHareketleri_BankaKasaHareketId" FOREIGN KEY ("BankaKasaHareketId") REFERENCES "BankaKasaHareketleri" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_OdemeEslestirmeleri_Faturalar_FaturaId" FOREIGN KEY ("FaturaId") REFERENCES "Faturalar" ("Id") ON DELETE RESTRICT
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "AylikChecklistler" (
        "Id" INTEGER NOT NULL,
        "Yil" INTEGER NOT NULL,
        "Ay" INTEGER NOT NULL,
        "ChecklistTipi" INTEGER NOT NULL,
        "SoforId" INTEGER,
        "AracId" INTEGER,
        "GuzergahId" INTEGER,
        "KontrolTarihi" TEXT,
        "KontrolEden" TEXT,
        "GenelDurum" INTEGER NOT NULL,
        "Notlar" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_AylikChecklistler" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AylikChecklistler_Araclar_AracId" FOREIGN KEY ("AracId") REFERENCES "Araclar" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_AylikChecklistler_Guzergahlar_GuzergahId" FOREIGN KEY ("GuzergahId") REFERENCES "Guzergahlar" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_AylikChecklistler_Soforler_SoforId" FOREIGN KEY ("SoforId") REFERENCES "Soforler" ("Id") ON DELETE RESTRICT
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "ServisCalismalari" (
        "Id" INTEGER NOT NULL,
        "CalismaTarihi" TEXT NOT NULL,
        "ServisTuru" INTEGER NOT NULL,
        "Fiyat" TEXT,
        "KmBaslangic" INTEGER,
        "KmBitis" INTEGER,
        "BaslangicSaati" TEXT,
        "BitisSaati" TEXT,
        "ArizaOlduMu" INTEGER NOT NULL,
        "ArizaAciklamasi" TEXT,
        "Durum" INTEGER NOT NULL,
        "Notlar" TEXT,
        "AracId" INTEGER NOT NULL,
        "SoforId" INTEGER NOT NULL,
        "GuzergahId" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_ServisCalismalari" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ServisCalismalari_Araclar_AracId" FOREIGN KEY ("AracId") REFERENCES "Araclar" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_ServisCalismalari_Guzergahlar_GuzergahId" FOREIGN KEY ("GuzergahId") REFERENCES "Guzergahlar" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_ServisCalismalari_Soforler_SoforId" FOREIGN KEY ("SoforId") REFERENCES "Soforler" ("Id") ON DELETE RESTRICT
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "ServisCalismaKiralamalar" (
        "Id" INTEGER NOT NULL,
        "FirmaId" INTEGER NOT NULL,
        "CalismaTarihi" TEXT NOT NULL,
        "ServisTuru" INTEGER NOT NULL,
        "AracSahiplikTuru" INTEGER NOT NULL,
        "AracId" INTEGER,
        "KiralamaAracId" INTEGER,
        "SoforId" INTEGER NOT NULL,
        "GuzergahId" INTEGER NOT NULL,
        "MusteriFirmaId" INTEGER,
        "CalismaBedeli" TEXT,
        "AracKiraBedeli" TEXT,
        "KomisyonTutari" TEXT,
        "NetKazanc" TEXT,
        "KmBaslangic" INTEGER,
        "KmBitis" INTEGER,
        "ToplamKm" INTEGER,
        "BaslangicSaati" TEXT,
        "BitisSaati" TEXT,
        "ArizaOlduMu" INTEGER NOT NULL,
        "ArizaAciklamasi" TEXT,
        "Durum" INTEGER NOT NULL,
        "Notlar" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_ServisCalismaKiralamalar" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ServisCalismaKiralamalar_Araclar_AracId" FOREIGN KEY ("AracId") REFERENCES "Araclar" ("Id"),
        CONSTRAINT "FK_ServisCalismaKiralamalar_Firmalar_FirmaId" FOREIGN KEY ("FirmaId") REFERENCES "Firmalar" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_ServisCalismaKiralamalar_Firmalar_MusteriFirmaId" FOREIGN KEY ("MusteriFirmaId") REFERENCES "Firmalar" ("Id"),
        CONSTRAINT "FK_ServisCalismaKiralamalar_Guzergahlar_GuzergahId" FOREIGN KEY ("GuzergahId") REFERENCES "Guzergahlar" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_ServisCalismaKiralamalar_KiralamaAraclar_KiralamaAracId" FOREIGN KEY ("KiralamaAracId") REFERENCES "KiralamaAraclar" ("Id"),
        CONSTRAINT "FK_ServisCalismaKiralamalar_Soforler_SoforId" FOREIGN KEY ("SoforId") REFERENCES "Soforler" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "AracEvrakDosyalari" (
        "Id" INTEGER NOT NULL,
        "AracEvrakId" INTEGER NOT NULL,
        "DosyaAdi" TEXT NOT NULL,
        "DosyaYolu" TEXT NOT NULL,
        "DosyaTipi" TEXT,
        "DosyaBoyutu" INTEGER NOT NULL,
        "Aciklama" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_AracEvrakDosyalari" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AracEvrakDosyalari_AracEvraklari_AracEvrakId" FOREIGN KEY ("AracEvrakId") REFERENCES "AracEvraklari" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "ChecklistKalemleri" (
        "Id" INTEGER NOT NULL,
        "AylikChecklistId" INTEGER NOT NULL,
        "KalemAdi" TEXT NOT NULL,
        "Durum" INTEGER NOT NULL,
        "SonGecerlilikTarihi" TEXT,
        "KontrolTarihi" TEXT,
        "Aciklama" TEXT,
        "SiraNo" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_ChecklistKalemleri" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_ChecklistKalemleri_AylikChecklistler_AylikChecklistId" FOREIGN KEY ("AylikChecklistId") REFERENCES "AylikChecklistler" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "AracMasraflari" (
        "Id" INTEGER NOT NULL,
        "MasrafTarihi" TEXT NOT NULL,
        "Tutar" TEXT NOT NULL,
        "Aciklama" TEXT,
        "BelgeNo" TEXT,
        "ArizaKaynaklimi" INTEGER NOT NULL,
        "AracId" INTEGER NOT NULL,
        "MasrafKalemiId" INTEGER NOT NULL,
        "GuzergahId" INTEGER,
        "ServisCalismaId" INTEGER,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_AracMasraflari" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AracMasraflari_Araclar_AracId" FOREIGN KEY ("AracId") REFERENCES "Araclar" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_AracMasraflari_Guzergahlar_GuzergahId" FOREIGN KEY ("GuzergahId") REFERENCES "Guzergahlar" ("Id") ON DELETE SET NULL,
        CONSTRAINT "FK_AracMasraflari_MasrafKalemleri_MasrafKalemiId" FOREIGN KEY ("MasrafKalemiId") REFERENCES "MasrafKalemleri" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_AracMasraflari_ServisCalismalari_ServisCalismaId" FOREIGN KEY ("ServisCalismaId") REFERENCES "ServisCalismalari" ("Id") ON DELETE SET NULL
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE TABLE "GunlukPuantajlar" (
        "Id" INTEGER NOT NULL,
        "PersonelPuantajId" INTEGER NOT NULL,
        "Tarih" TEXT NOT NULL,
        "Calisti" INTEGER NOT NULL,
        "FazlaMesaiSaat" TEXT,
        "Izinli" INTEGER NOT NULL,
        "Mazeret" INTEGER NOT NULL,
        "ServisCalismaId" INTEGER,
        "Notlar" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_GunlukPuantajlar" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_GunlukPuantajlar_PersonelPuantajlar_PersonelPuantajId" FOREIGN KEY ("PersonelPuantajId") REFERENCES "PersonelPuantajlar" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_GunlukPuantajlar_ServisCalismalari_ServisCalismaId" FOREIGN KEY ("ServisCalismaId") REFERENCES "ServisCalismalari" ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AktiviteLoglar_IslemZamani" ON "AktiviteLoglar" ("IslemZamani");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AktiviteLoglar_Modul_IslemTipi" ON "AktiviteLoglar" ("Modul", "IslemTipi");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AracEvrakDosyalari_AracEvrakId" ON "AracEvrakDosyalari" ("AracEvrakId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AracEvraklari_AracId_EvrakKategorisi" ON "AracEvraklari" ("AracId", "EvrakKategorisi");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AracIlanlari_Plaka" ON "AracIlanlari" ("Plaka");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AracIlanlari_SahipCariId" ON "AracIlanlari" ("SahipCariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AracIlanlari_SatisPersoneliId" ON "AracIlanlari" ("SatisPersoneliId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_Araclar_KiralikCariId" ON "Araclar" ("KiralikCariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_Araclar_KomisyoncuCariId" ON "Araclar" ("KomisyoncuCariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_Araclar_Plaka" ON "Araclar" ("Plaka");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_AracMarkalari_MarkaAdi" ON "AracMarkalari" ("MarkaAdi");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AracMasraflari_AracId" ON "AracMasraflari" ("AracId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AracMasraflari_GuzergahId" ON "AracMasraflari" ("GuzergahId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AracMasraflari_MasrafKalemiId" ON "AracMasraflari" ("MasrafKalemiId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AracMasraflari_ServisCalismaId" ON "AracMasraflari" ("ServisCalismaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AracModelleri_MarkaId" ON "AracModelleri" ("MarkaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AracSatislari_AliciCariId" ON "AracSatislari" ("AliciCariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AracSatislari_AracIlanId" ON "AracSatislari" ("AracIlanId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AracSatislari_SatisPersoneliId" ON "AracSatislari" ("SatisPersoneliId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AylikChecklistler_AracId" ON "AylikChecklistler" ("AracId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AylikChecklistler_GuzergahId" ON "AylikChecklistler" ("GuzergahId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AylikChecklistler_SoforId" ON "AylikChecklistler" ("SoforId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AylikChecklistler_Yil_Ay_ChecklistTipi_SoforId_AracId_GuzergahId" ON "AylikChecklistler" ("Yil", "Ay", "ChecklistTipi", "SoforId", "AracId", "GuzergahId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AylikOdemeGerceklesenler_AylikOdemePlaniId" ON "AylikOdemeGerceklesenler" ("AylikOdemePlaniId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AylikOdemeGerceklesenler_BankaKasaHareketId" ON "AylikOdemeGerceklesenler" ("BankaKasaHareketId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AylikOdemeGerceklesenler_FirmaId" ON "AylikOdemeGerceklesenler" ("FirmaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AylikOdemePlanlari_BankaHesapId" ON "AylikOdemePlanlari" ("BankaHesapId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AylikOdemePlanlari_CariId" ON "AylikOdemePlanlari" ("CariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AylikOdemePlanlari_FirmaId" ON "AylikOdemePlanlari" ("FirmaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_AylikOdemePlanlari_MasrafKalemiId" ON "AylikOdemePlanlari" ("MasrafKalemiId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_BankaHesaplari_HesapKodu" ON "BankaHesaplari" ("HesapKodu");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_BankaKasaHareketleri_BankaHesapId" ON "BankaKasaHareketleri" ("BankaHesapId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_BankaKasaHareketleri_CariId" ON "BankaKasaHareketleri" ("CariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_BankaKasaHareketleri_IslemNo" ON "BankaKasaHareketleri" ("IslemNo");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_BudgetMasrafKalemleri_KalemAdi" ON "BudgetMasrafKalemleri" ("KalemAdi");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_BudgetOdemeler_FaturaId" ON "BudgetOdemeler" ("FaturaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_BudgetOdemeler_FirmaId" ON "BudgetOdemeler" ("FirmaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_BudgetOdemeler_OdemeYapildigiHesapId" ON "BudgetOdemeler" ("OdemeYapildigiHesapId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_BudgetOdemeler_OdemeYil_OdemeAy_MasrafKalemi" ON "BudgetOdemeler" ("OdemeYil", "OdemeAy", "MasrafKalemi");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_BudgetOdemeler_TaksitGrupId" ON "BudgetOdemeler" ("TaksitGrupId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_Cariler_CariKodu" ON "Cariler" ("CariKodu");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_Cariler_FirmaId" ON "Cariler" ("FirmaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_Cariler_MuhasebeHesapId" ON "Cariler" ("MuhasebeHesapId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_ChecklistKalemleri_AylikChecklistId" ON "ChecklistKalemleri" ("AylikChecklistId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_FaturaKalemleri_FaturaId" ON "FaturaKalemleri" ("FaturaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_Faturalar_CariId" ON "Faturalar" ("CariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_Faturalar_FaturaNo" ON "Faturalar" ("FaturaNo");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_Faturalar_FirmaId" ON "Faturalar" ("FirmaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_Firmalar_FirmaKodu" ON "Firmalar" ("FirmaKodu");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_GunlukPuantajlar_PersonelPuantajId" ON "GunlukPuantajlar" ("PersonelPuantajId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_GunlukPuantajlar_ServisCalismaId" ON "GunlukPuantajlar" ("ServisCalismaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_Guzergahlar_CariId" ON "Guzergahlar" ("CariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_Guzergahlar_GuzergahKodu" ON "Guzergahlar" ("GuzergahKodu");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_KiralamaAraclar_FirmaId" ON "KiralamaAraclar" ("FirmaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_KiralamaAraclar_KiralayıcıCariId" ON "KiralamaAraclar" ("KiralayıcıCariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_Kullanicilar_KullaniciAdi" ON "Kullanicilar" ("KullaniciAdi");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_Kullanicilar_RolId" ON "Kullanicilar" ("RolId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_Kullanicilar_SoforId" ON "Kullanicilar" ("SoforId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_Lisanslar_LisansAnahtari" ON "Lisanslar" ("LisansAnahtari");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_MasrafKalemleri_MasrafKodu" ON "MasrafKalemleri" ("MasrafKodu");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_MuhasebeDonemleri_Yil_Ay" ON "MuhasebeDonemleri" ("Yil", "Ay");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_MuhasebeFisKalemleri_CariId" ON "MuhasebeFisKalemleri" ("CariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_MuhasebeFisKalemleri_FisId" ON "MuhasebeFisKalemleri" ("FisId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_MuhasebeFisKalemleri_HesapId" ON "MuhasebeFisKalemleri" ("HesapId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_MuhasebeFisleri_FisNo" ON "MuhasebeFisleri" ("FisNo");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_MuhasebeHesaplari_HesapKodu" ON "MuhasebeHesaplari" ("HesapKodu");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_MuhasebeHesaplari_UstHesapId" ON "MuhasebeHesaplari" ("UstHesapId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_OdemeEslestirmeleri_BankaKasaHareketId" ON "OdemeEslestirmeleri" ("BankaKasaHareketId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_OdemeEslestirmeleri_FaturaId" ON "OdemeEslestirmeleri" ("FaturaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_PersonelIzinHaklari_SoforId_Yil" ON "PersonelIzinHaklari" ("SoforId", "Yil");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_PersonelIzinleri_SoforId" ON "PersonelIzinleri" ("SoforId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_PersonelMaaslari_SoforId_Yil_Ay" ON "PersonelMaaslari" ("SoforId", "Yil", "Ay");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_PersonelPuantajlar_FirmaId" ON "PersonelPuantajlar" ("FirmaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_PersonelPuantajlar_PersonelId" ON "PersonelPuantajlar" ("PersonelId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_PiyasaIlanlari_AracIlanId" ON "PiyasaIlanlari" ("AracIlanId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_Roller_RolAdi" ON "Roller" ("RolAdi");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_RolYetkileri_RolId_YetkiKodu" ON "RolYetkileri" ("RolId", "YetkiKodu");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_SatisPersonelleri_PersonelKodu" ON "SatisPersonelleri" ("PersonelKodu");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_ServisCalismaKiralamalar_AracId" ON "ServisCalismaKiralamalar" ("AracId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_ServisCalismaKiralamalar_FirmaId" ON "ServisCalismaKiralamalar" ("FirmaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_ServisCalismaKiralamalar_GuzergahId" ON "ServisCalismaKiralamalar" ("GuzergahId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_ServisCalismaKiralamalar_KiralamaAracId" ON "ServisCalismaKiralamalar" ("KiralamaAracId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_ServisCalismaKiralamalar_MusteriFirmaId" ON "ServisCalismaKiralamalar" ("MusteriFirmaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_ServisCalismaKiralamalar_SoforId" ON "ServisCalismaKiralamalar" ("SoforId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_ServisCalismalari_AracId" ON "ServisCalismalari" ("AracId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_ServisCalismalari_GuzergahId" ON "ServisCalismalari" ("GuzergahId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE INDEX "IX_ServisCalismalari_SoforId" ON "ServisCalismalari" ("SoforId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    CREATE UNIQUE INDEX "IX_Soforler_SoforKodu" ON "Soforler" ("SoforKodu");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324174737_InitialCreate') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260324174737_InitialCreate', '10.0.5');
    END IF;
END $EF$;
COMMIT;

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324175248_Init') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260324175248_Init', '10.0.5');
    END IF;
END $EF$;
COMMIT;

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324195453_AddPiyasaArastirmaModule') THEN
    CREATE TABLE "AracMarkaModeller" (
        "Id" INTEGER NOT NULL,
        "Marka" TEXT NOT NULL,
        "Model" TEXT,
        "Versiyon" TEXT,
        "BaslangicYili" INTEGER,
        "BitisYili" INTEGER,
        "KasaTipi" TEXT,
        "YakitTipleri" TEXT,
        "VitesTipleri" TEXT,
        "Segment" TEXT,
        "Aktif" INTEGER NOT NULL,
        "Sira" INTEGER NOT NULL,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_AracMarkaModeller" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324195453_AddPiyasaArastirmaModule') THEN
    CREATE TABLE "PiyasaArastirmalar" (
        "Id" INTEGER NOT NULL,
        "Marka" TEXT NOT NULL,
        "Model" TEXT NOT NULL,
        "Versiyon" TEXT,
        "YilBaslangic" INTEGER,
        "YilBitis" INTEGER,
        "YakitTipi" TEXT,
        "VitesTipi" TEXT,
        "MinKilometre" INTEGER,
        "MaxKilometre" INTEGER,
        "MinFiyat" TEXT,
        "MaxFiyat" TEXT,
        "Sehir" TEXT,
        "ToplamIlanSayisi" INTEGER NOT NULL,
        "OrtalamaFiyat" TEXT NOT NULL,
        "EnDusukFiyat" TEXT NOT NULL,
        "EnYuksekFiyat" TEXT NOT NULL,
        "MedianFiyat" TEXT NOT NULL,
        "OrtalamaKilometre" INTEGER NOT NULL,
        "ArastirmaTarihi" TEXT NOT NULL,
        "Durum" INTEGER NOT NULL,
        "HataMesaji" TEXT,
        "AIAnalizi" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_PiyasaArastirmalar" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324195453_AddPiyasaArastirmaModule') THEN
    CREATE TABLE "PiyasaArastirmaIlanlar" (
        "Id" INTEGER NOT NULL,
        "ArastirmaId" INTEGER NOT NULL,
        "Kaynak" TEXT NOT NULL,
        "IlanNo" TEXT,
        "IlanBasligi" TEXT NOT NULL,
        "IlanUrl" TEXT,
        "Marka" TEXT NOT NULL,
        "Model" TEXT NOT NULL,
        "Versiyon" TEXT,
        "ModelYili" INTEGER NOT NULL,
        "Kilometre" INTEGER NOT NULL,
        "Fiyat" TEXT NOT NULL,
        "ParaBirimi" TEXT,
        "YakitTipi" TEXT,
        "VitesTipi" TEXT,
        "KasaTipi" TEXT,
        "MotorHacmi" TEXT,
        "MotorGucu" TEXT,
        "Renk" TEXT,
        "BoyaliParcaSayisi" INTEGER,
        "DegisenParcaSayisi" INTEGER,
        "TramerTutari" TEXT,
        "HasarKayitli" INTEGER NOT NULL,
        "Sehir" TEXT,
        "Ilce" TEXT,
        "SaticiTipi" TEXT,
        "SaticiAdi" TEXT,
        "IlanTarihi" TEXT,
        "ToplanmaTarihi" TEXT NOT NULL,
        "AktifMi" INTEGER NOT NULL,
        "Notlar" TEXT,
        "CreatedAt" TEXT NOT NULL,
        "UpdatedAt" TEXT,
        "IsDeleted" INTEGER NOT NULL,
        CONSTRAINT "PK_PiyasaArastirmaIlanlar" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_PiyasaArastirmaIlanlar_PiyasaArastirmalar_ArastirmaId" FOREIGN KEY ("ArastirmaId") REFERENCES "PiyasaArastirmalar" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324195453_AddPiyasaArastirmaModule') THEN
    CREATE INDEX "IX_PiyasaArastirmaIlanlar_ArastirmaId" ON "PiyasaArastirmaIlanlar" ("ArastirmaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260324195453_AddPiyasaArastirmaModule') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260324195453_AddPiyasaArastirmaModule', '10.0.5');
    END IF;
END $EF$;
COMMIT;

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" DROP CONSTRAINT "FK_AylikOdemeGerceklesenler_AylikOdemePlanlari_AylikOdemePlaniId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" DROP CONSTRAINT "FK_AylikOdemeGerceklesenler_BankaKasaHareketleri_BankaKasaHareketId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    DROP INDEX "IX_Cariler_CariKodu";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER INDEX "IX_AylikChecklistler_Yil_Ay_ChecklistTipi_SoforId_AracId_GuzergahId" RENAME TO "IX_AylikChecklistler_Yil_Ay_ChecklistTipi_SoforId_AracId_Guzer~";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "Telefon" TYPE character varying(20);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "TcKimlikNo" TYPE character varying(11);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "SrcBelgesiGecerlilikTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "Soyad" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "SoforKodu" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "SaglikRaporuGecerlilikTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "PsikoteknikGecerlilikTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "Pozisyon" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "NetMaas" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "IstenAyrilmaTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "IseBaslamaTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "IBAN" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "Gorev" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "Email" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "EhliyetNo" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "EhliyetGecerlilikTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "Departman" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "BrutMaas" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "BankaAdi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "Adres" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "Ad" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Soforler" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "Soforler" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "Soforler" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "SoforId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "ServisTuru" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "KmBitis" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "KmBaslangic" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "GuzergahId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "Fiyat" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "Durum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "CalismaTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "BitisSaati" TYPE interval;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "BaslangicSaati" TYPE interval;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "ArizaOlduMu" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "ArizaAciklamasi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "AracId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "ServisCalismalari" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "ToplamKm" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "SoforId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "ServisTuru" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "NetKazanc" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "MusteriFirmaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "KomisyonTutari" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "KmBitis" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "KmBaslangic" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "KiralamaAracId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "GuzergahId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "FirmaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "Durum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "CalismaTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "CalismaBedeli" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "BitisSaati" TYPE interval;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "BaslangicSaati" TYPE interval;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "ArizaOlduMu" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "ArizaAciklamasi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "AracSahiplikTuru" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "AracKiraBedeli" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "AracId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "ServisCalismaKiralamalar" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "Telefon" TYPE character varying(20);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "SabitKomisyon" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "PersonelKodu" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "KomisyonOrani" TYPE numeric(5,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "Email" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "AylikSatisHedefi" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "AylikAracHedefi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "AdSoyad" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "SatisPersonelleri" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "RolYetkileri" ALTER COLUMN "YetkiKodu" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "RolYetkileri" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "RolYetkileri" ALTER COLUMN "RolId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "RolYetkileri" ALTER COLUMN "Izin" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "RolYetkileri" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "RolYetkileri" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "RolYetkileri" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "RolYetkileri" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "RolYetkileri" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Roller" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Roller" ALTER COLUMN "SistemRolu" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Roller" ALTER COLUMN "RolAdi" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Roller" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Roller" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Roller" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Roller" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "Roller" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "Roller" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "Yil" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "TramerVar" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "TramerTutari" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "TaramaTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "Sehir" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "Kilometre" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "Kaynak" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "Ilce" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "IlanUrl" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "IlanNo" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "Fiyat" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "EkBilgiler" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "Durum" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "DegisenParca" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "BoyaliParca" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "AracIlanId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "PiyasaIlanlari" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "YilBitis" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "YilBaslangic" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "YakitTipi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "VitesTipi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "Versiyon" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "ToplamIlanSayisi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "Sehir" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "OrtalamaKilometre" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "OrtalamaFiyat" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "Model" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "MinKilometre" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "MinFiyat" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "MedianFiyat" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "MaxKilometre" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "MaxFiyat" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "Marka" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "HataMesaji" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "EnYuksekFiyat" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "EnDusukFiyat" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "Durum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "ArastirmaTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "AIAnalizi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "PiyasaArastirmalar" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "YakitTipi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "VitesTipi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "Versiyon" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "TramerTutari" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "ToplanmaTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "Sehir" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "SaticiTipi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "SaticiAdi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "Renk" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "ParaBirimi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "MotorHacmi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "MotorGucu" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "ModelYili" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "Model" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "Marka" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "Kilometre" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "Kaynak" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "KasaTipi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "Ilce" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "IlanUrl" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "IlanTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "IlanNo" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "IlanBasligi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "HasarKayitli" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "Fiyat" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "DegisenParcaSayisi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "BoyaliParcaSayisi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "ArastirmaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "AktifMi" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "PiyasaArastirmaIlanlar" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ADD "Fotograflar" text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ADD "Kapasite" text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ADD "ResimUrl" text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PiyasaArastirmaIlanlar" ADD "TasimaKapasitesi" text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "YolUcreti" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "Yil" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "YemekUcreti" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "SgkKesinti" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "Prim" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "PersonelId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "Odendi" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "OdemeTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "NetOdeme" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "MazeretGunu" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "IzinGunu" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "GelirVergisi" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "FirmaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "FazlaMesaiSaat" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "DigerOdeme" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "DigerKesinti" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "DamgaVergisi" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "CalisilanGun" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "BrutMaas" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "BankaHesapNo" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "Ay" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "PersonelPuantajlar" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "Yol" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "Yil" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "Yemek" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "SoforId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "SGKIsverenPayi" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "SGKIsciPayi" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "RaporluGun" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "Prim" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "OdemeTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "OdemeDurum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "OdemeAciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "NetMaas" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "Mesai" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "IzinliGun" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "IssizlikPrimi" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "Ikramiye" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "IcraTakibi" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "GelirVergisi" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "DigerKesintiler" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "DigerEklemeler" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "DevamsizlikGun" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "DamgaVergisi" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "CalismaGunu" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "BrutMaas" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "Ay" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "Avans" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "PersonelMaaslari" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "SoforId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "RedNedeni" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "OnaylayanKisi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "OnayTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "IzinTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "Durum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "BitisTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "BaslangicTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "PersonelIzinleri" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinHaklari" ALTER COLUMN "YillikIzinHakki" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinHaklari" ALTER COLUMN "Yil" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinHaklari" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinHaklari" ALTER COLUMN "SoforId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinHaklari" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinHaklari" ALTER COLUMN "KullanilanIzin" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinHaklari" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinHaklari" ALTER COLUMN "DevirenIzin" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinHaklari" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "PersonelIzinHaklari" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "PersonelIzinHaklari" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "PersonelIzinHaklari" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "OdemeEslestirmeleri" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "OdemeEslestirmeleri" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "OdemeEslestirmeleri" ALTER COLUMN "FaturaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "OdemeEslestirmeleri" ALTER COLUMN "EslestirmeTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "OdemeEslestirmeleri" ALTER COLUMN "EslestirilenTutar" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "OdemeEslestirmeleri" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "OdemeEslestirmeleri" ALTER COLUMN "BankaKasaHareketId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "OdemeEslestirmeleri" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "OdemeEslestirmeleri" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "OdemeEslestirmeleri" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "OdemeEslestirmeleri" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "UstHesapId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "SistemHesabi" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "HesapTuru" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "HesapKodu" TYPE character varying(10);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "HesapGrubu" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "HesapAdi" TYPE character varying(200);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "AltHesapVar" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "MuhasebeHesaplari" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "ToplamBorc" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "ToplamAlacak" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "KaynakTip" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "KaynakId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "Kaynak" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "FisTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "FisTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "FisNo" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "Durum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "MuhasebeFisleri" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisKalemleri" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisKalemleri" ALTER COLUMN "SiraNo" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisKalemleri" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisKalemleri" ALTER COLUMN "HesapId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisKalemleri" ALTER COLUMN "FisId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisKalemleri" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisKalemleri" ALTER COLUMN "CariId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisKalemleri" ALTER COLUMN "Borc" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisKalemleri" ALTER COLUMN "Alacak" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisKalemleri" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeFisKalemleri" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "MuhasebeFisKalemleri" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "MuhasebeFisKalemleri" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeDonemleri" ALTER COLUMN "Yil" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeDonemleri" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeDonemleri" ALTER COLUMN "KapanisTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeDonemleri" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeDonemleri" ALTER COLUMN "Durum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeDonemleri" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeDonemleri" ALTER COLUMN "BitisTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeDonemleri" ALTER COLUMN "BaslangicTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeDonemleri" ALTER COLUMN "Ay" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MuhasebeDonemleri" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "MuhasebeDonemleri" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "MuhasebeDonemleri" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MasrafKalemleri" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MasrafKalemleri" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MasrafKalemleri" ALTER COLUMN "MasrafKodu" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MasrafKalemleri" ALTER COLUMN "MasrafAdi" TYPE character varying(200);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MasrafKalemleri" ALTER COLUMN "Kategori" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MasrafKalemleri" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MasrafKalemleri" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MasrafKalemleri" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "MasrafKalemleri" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "MasrafKalemleri" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "MasrafKalemleri" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "YetkiliKisi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "YedeklemeIzni" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "Tur" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "Telefon" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "SatisModuluIzni" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "RaporlamaIzni" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "PdfExportIzni" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "MuhasebeIzni" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "MaxKullaniciSayisi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "MakineKodu" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "LisansAnahtari" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "Imza" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "FirmaAdi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "ExcelExportIzni" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "Email" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "BitisTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "BaslangicTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Lisanslar" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "Lisanslar" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "Lisanslar" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "Tema" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "Telefon" TYPE character varying(20);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "SonGirisTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "SoforId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "SifreHash" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "RolId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "KullaniciAdi" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "KompaktMod" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "Kilitli" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "Email" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "BasarisizGirisSayisi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "AdSoyad" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Kullanicilar" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "Kullanicilar" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "Kullanicilar" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "SozlesmeNo" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "SeferBasinaKiraBedeli" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "SabitKomisyonTutari" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "Plaka" TYPE character varying(15);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "ModelYili" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "Model" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "Marka" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "KomisyonOrani" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "KoltukSayisi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "KiralayıcıCariId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "KiralamaBitis" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "KiralamaBaslangic" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "GunlukKiraBedeli" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "FirmaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "AylikKiraBedeli" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "AracTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "KiralamaAraclar" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "TahminiSure" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "Mesafe" TYPE numeric(10,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "GuzergahKodu" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "GuzergahAdi" TYPE character varying(200);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "CariId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "BitisNoktasi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "BirimFiyat" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "BaslangicNoktasi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Guzergahlar" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "Guzergahlar" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "Guzergahlar" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "Tarih" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "ServisCalismaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "PersonelPuantajId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "Mazeret" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "Izinli" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "FazlaMesaiSaat" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "Calisti" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "GunlukPuantajlar" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "WebSite" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "VergiNo" TYPE character varying(11);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "VergiDairesi" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "VarsayilanFirma" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "UnvanTam" TYPE character varying(250);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "Telefon" TYPE character varying(20);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "SiraNo" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "Logo" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "Ilce" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "Il" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "FirmaKodu" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "FirmaAdi" TYPE character varying(250);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "Email" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "AktifDonemYil" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "AktifDonemAy" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "Adres" TYPE character varying(500);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Firmalar" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "Firmalar" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "Firmalar" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "VadeTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "OdenenTutar" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "KdvTutar" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "KdvOrani" TYPE numeric(5,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "IskontoTutar" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "ImportKaynak" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "GibOnayTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "GibKodu" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "GenelToplam" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "FirmaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "FaturaYonu" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "FaturaTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "FaturaTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "FaturaNo" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "EttnNo" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "EFaturaTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "Durum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "CariId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "AraToplam" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Faturalar" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "Faturalar" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "Faturalar" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "ToplamTutar" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "SiraNo" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "Miktar" TYPE numeric(18,4);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "KdvTutar" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "KdvOrani" TYPE numeric(5,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "FaturaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "BirimFiyat" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "Birim" TYPE character varying(20);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "FaturaKalemleri" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ChecklistKalemleri" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ChecklistKalemleri" ALTER COLUMN "SonGecerlilikTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ChecklistKalemleri" ALTER COLUMN "SiraNo" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ChecklistKalemleri" ALTER COLUMN "KontrolTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ChecklistKalemleri" ALTER COLUMN "KalemAdi" TYPE character varying(200);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ChecklistKalemleri" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ChecklistKalemleri" ALTER COLUMN "Durum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ChecklistKalemleri" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ChecklistKalemleri" ALTER COLUMN "AylikChecklistId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ChecklistKalemleri" ALTER COLUMN "Aciklama" TYPE character varying(500);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "ChecklistKalemleri" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "ChecklistKalemleri" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "ChecklistKalemleri" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "YetkiliKisi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "VergiNo" TYPE character varying(20);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "VergiDairesi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "Unvan" TYPE character varying(250);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "Telefon" TYPE character varying(20);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "TcKimlikNo" TYPE character varying(11);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "MuhasebeHesapId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "FirmaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "Email" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "CariTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "CariKodu" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "Borc" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "Alacak" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "Adres" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Cariler" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "Cariler" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "Cariler" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "ToplamTaksitSayisi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "TaksitliMi" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "TaksitGrupId" TYPE uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "TaksitBitisAy" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "TaksitBaslangicAy" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "OdenenTutar" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "OdemeYil" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "OdemeYapildigiHesapId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "OdemeTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "OdemeNotu" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "OdemeAy" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "Notlar" TYPE character varying(1000);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "Miktar" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "MasrafKalemi" TYPE character varying(200);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "KacinciTaksit" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "GercekOdemeTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "FirmaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "FaturaIleKapatildi" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "FaturaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "Durum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "BankaKasaHareketId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "Aciklama" TYPE character varying(500);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "BudgetOdemeler" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetMasrafKalemleri" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetMasrafKalemleri" ALTER COLUMN "SiraNo" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetMasrafKalemleri" ALTER COLUMN "Renk" TYPE character varying(20);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetMasrafKalemleri" ALTER COLUMN "Kategori" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetMasrafKalemleri" ALTER COLUMN "KalemAdi" TYPE character varying(200);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetMasrafKalemleri" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetMasrafKalemleri" ALTER COLUMN "Icon" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetMasrafKalemleri" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetMasrafKalemleri" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BudgetMasrafKalemleri" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "BudgetMasrafKalemleri" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "BudgetMasrafKalemleri" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "Tutar" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "IslemTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "IslemNo" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "IslemKaynak" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "HareketTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "CariId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "BelgeNo" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "BankaHesapId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "BankaKasaHareketleri" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "SubeKodu" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "SubeAdi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "ParaBirimi" TYPE character varying(3);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "Iban" TYPE character varying(34);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "HesapTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "HesapNo" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "HesapKodu" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "HesapAdi" TYPE character varying(200);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "BankaAdi" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "AcilisBakiye" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "BankaHesaplari" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "Turu" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "OtomatikKayitOlustur" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "OdemeGunu" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "OdemeAdi" TYPE character varying(200);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "MasrafKalemiId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "FirmaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "CariId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "BitisTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "BaslangicTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "BankaHesapId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "AylikTutar" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "AylikOdemePlanlari" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "Yil" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "PlanlananTutar" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "OdenenTutar" TYPE numeric;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "OdemeTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "FirmaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "Durum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "BankaKasaHareketId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "AylikOdemePlaniId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "Ay" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "AylikOdemeGerceklesenler" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "Yil" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "SoforId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "KontrolTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "KontrolEden" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "GuzergahId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "GenelDurum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "ChecklistTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "Ay" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "AracId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "AylikChecklistler" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracSatislari" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracSatislari" ALTER COLUMN "SatisTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracSatislari" ALTER COLUMN "SatisPersoneliId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracSatislari" ALTER COLUMN "SatisFiyati" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracSatislari" ALTER COLUMN "OdemeSekli" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracSatislari" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracSatislari" ALTER COLUMN "KomisyonTutari" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracSatislari" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracSatislari" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracSatislari" ALTER COLUMN "AracIlanId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracSatislari" ALTER COLUMN "AliciCariId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracSatislari" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "AracSatislari" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "AracSatislari" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracModelleri" ALTER COLUMN "VarsayilanKasaTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracModelleri" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracModelleri" ALTER COLUMN "ModelAdi" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracModelleri" ALTER COLUMN "MarkaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracModelleri" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracModelleri" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracModelleri" ALTER COLUMN "BitisYili" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracModelleri" ALTER COLUMN "BaslangicYili" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracModelleri" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracModelleri" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "AracModelleri" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "AracModelleri" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMasraflari" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMasraflari" ALTER COLUMN "Tutar" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMasraflari" ALTER COLUMN "ServisCalismaId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMasraflari" ALTER COLUMN "MasrafTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMasraflari" ALTER COLUMN "MasrafKalemiId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMasraflari" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMasraflari" ALTER COLUMN "GuzergahId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMasraflari" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMasraflari" ALTER COLUMN "BelgeNo" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMasraflari" ALTER COLUMN "ArizaKaynaklimi" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMasraflari" ALTER COLUMN "AracId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMasraflari" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMasraflari" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "AracMasraflari" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "AracMasraflari" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "YakitTipleri" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "VitesTipleri" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "Versiyon" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "Sira" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "Segment" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "Model" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "Marka" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "KasaTipi" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "BitisYili" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "BaslangicYili" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "AracMarkaModeller" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkalari" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkalari" ALTER COLUMN "SiraNo" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkalari" ALTER COLUMN "MarkaAdi" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkalari" ALTER COLUMN "Logo" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkalari" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkalari" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkalari" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracMarkalari" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "AracMarkalari" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "AracMarkalari" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "TrafikSigortaBitisTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "SeferBasinaKiraBedeli" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "SaseNo" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "SahiplikTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "SabitKomisyonTutari" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "Renk" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "Plaka" TYPE character varying(15);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "MuayeneBitisTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "MotorNo" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "ModelYili" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "Model" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "Marka" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "KomisyoncuCariId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "KomisyonVar" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "KomisyonOrani" TYPE numeric(5,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "KomisyonHesaplamaTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "KoltukSayisi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "KmDurumu" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "KiralikCariId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "KiraHesaplamaTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "KaskoBitisTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "GunlukKiraBedeli" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "AylikKiraBedeli" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "AracTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "Aktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "Araclar" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "Araclar" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "Araclar" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "YakitTuru" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "VitesTuru" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Versiyon" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "TramerTutari" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "TramerKaydi" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "SatisTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "SatisPersoneliId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "SatisFiyati" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "SahipCariId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Renk" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Plaka" TYPE character varying(15);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "PiyasaDegeriOrtalama" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "PiyasaDegeriMin" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "PiyasaDegeriMax" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Notlar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "ModelYili" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Model" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Marka" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Kilometre" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "KaskoDegeri" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "KasaTipi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "IlanTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "IlanDurum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "HasarKaydi" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "HasarAciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Fotograflar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Durum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "DegisenVar" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "DegisenParcalar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "DegisenParcaSayisi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "BoyaliParcalar" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "BoyaliParcaSayisi" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Boyali" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "AlisFiyati" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Aciklama" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "AracIlanlari" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "Tutar" TYPE numeric(18,2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "SigortaSirketi" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "PoliceNo" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "HatirlatmaTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "HatirlatmaGunOnce" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "HatirlatmaAktif" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "EvrakKategorisi" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "EvrakAdi" TYPE character varying(200);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "Durum" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "BitisTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "BaslangicTarihi" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "AracId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "Aciklama" TYPE character varying(500);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvraklari" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "AracEvraklari" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "AracEvraklari" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvrakDosyalari" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvrakDosyalari" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvrakDosyalari" ALTER COLUMN "DosyaYolu" TYPE character varying(500);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvrakDosyalari" ALTER COLUMN "DosyaTipi" TYPE character varying(20);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvrakDosyalari" ALTER COLUMN "DosyaBoyutu" TYPE bigint;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvrakDosyalari" ALTER COLUMN "DosyaAdi" TYPE character varying(255);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvrakDosyalari" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvrakDosyalari" ALTER COLUMN "AracEvrakId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvrakDosyalari" ALTER COLUMN "Aciklama" TYPE character varying(500);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AracEvrakDosyalari" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "AracEvrakDosyalari" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "AracEvrakDosyalari" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "YeniDeger" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "UpdatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "Tarayici" TYPE character varying(500);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "Seviye" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "Modul" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "KullaniciAdi" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "IslemZamani" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "IslemTipi" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "IsDeleted" TYPE boolean;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "IpAdresi" TYPE character varying(50);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "EskiDeger" TYPE text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "EntityTipi" TYPE character varying(100);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "EntityId" TYPE integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "EntityAdi" TYPE character varying(500);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "CreatedAt" TYPE timestamp without time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "Aciklama" TYPE character varying(1000);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "Id" TYPE integer;
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "Id" DROP DEFAULT;
    ALTER TABLE "AktiviteLoglar" ALTER COLUMN "Id" ADD GENERATED BY DEFAULT AS IDENTITY;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    CREATE TABLE "MusteriKiralamalar" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "FirmaId" integer NOT NULL,
        "MusteriId" integer NOT NULL,
        "AracId" integer NOT NULL,
        "BaslangicTarihi" timestamp without time zone NOT NULL,
        "PlanlananBitisTarihi" timestamp without time zone NOT NULL,
        "GercekBitisTarihi" timestamp without time zone,
        "BaslangicKm" integer,
        "BitisKm" integer,
        "GunlukFiyat" numeric(18,2) NOT NULL,
        "ToplamTutar" numeric(18,2) NOT NULL,
        "Depozito" numeric(18,2),
        "Durum" integer NOT NULL,
        "OdemeDurumu" integer NOT NULL,
        "TeslimAlanPersonelId" integer,
        "TeslimEdenPersonelId" integer,
        "Notlar" character varying(500),
        "SozlesmeNo" character varying(50),
        "CreatedAt" timestamp without time zone NOT NULL,
        "UpdatedAt" timestamp without time zone,
        "IsDeleted" boolean NOT NULL,
        CONSTRAINT "PK_MusteriKiralamalar" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    CREATE TABLE "PiyasaKaynaklar" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "Ad" character varying(100) NOT NULL,
        "Kod" character varying(50) NOT NULL,
        "BaseUrl" character varying(500) NOT NULL,
        "AramaUrl" character varying(500),
        "AramaParametreleri" character varying(1000),
        "Selectors" character varying(2000),
        "DesteklenenMarkalar" character varying(500),
        "KaynakTipi" character varying(50) NOT NULL,
        "Sira" integer NOT NULL,
        "Aktif" boolean NOT NULL,
        "OlusturmaTarihi" timestamp without time zone NOT NULL,
        "GuncellemeTarihi" timestamp without time zone,
        "IsDeleted" boolean NOT NULL,
        CONSTRAINT "PK_PiyasaKaynaklar" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    CREATE UNIQUE INDEX "IX_Cariler_CariKodu" ON "Cariler" ("CariKodu") WHERE "IsDeleted" = false;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ADD CONSTRAINT "FK_AylikOdemeGerceklesenler_AylikOdemePlanlari_AylikOdemePlani~" FOREIGN KEY ("AylikOdemePlaniId") REFERENCES "AylikOdemePlanlari" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    ALTER TABLE "AylikOdemeGerceklesenler" ADD CONSTRAINT "FK_AylikOdemeGerceklesenler_BankaKasaHareketleri_BankaKasaHare~" FOREIGN KEY ("BankaKasaHareketId") REFERENCES "BankaKasaHareketleri" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260325200834_AddResimUrlToPiyasaIlan') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260325200834_AddResimUrlToPiyasaIlan', '10.0.5');
    END IF;
END $EF$;
COMMIT;

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326090740_TekrarlayanOdeme') THEN
    CREATE TABLE "TekrarlayanOdemeler" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "OdemeAdi" character varying(200) NOT NULL,
        "MasrafKalemi" character varying(200) NOT NULL,
        "Aciklama" character varying(500),
        "Tutar" numeric(18,2) NOT NULL,
        "Periyod" integer NOT NULL,
        "OdemeGunu" integer NOT NULL,
        "BaslangicTarihi" timestamp without time zone NOT NULL,
        "BitisTarihi" timestamp without time zone,
        "HatirlatmaGunSayisi" integer NOT NULL,
        "FirmaId" integer,
        "Aktif" boolean NOT NULL,
        "Renk" character varying(20),
        "Icon" character varying(50),
        "Notlar" character varying(1000),
        "CreatedAt" timestamp without time zone NOT NULL,
        "UpdatedAt" timestamp without time zone,
        "IsDeleted" boolean NOT NULL,
        CONSTRAINT "PK_TekrarlayanOdemeler" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_TekrarlayanOdemeler_Firmalar_FirmaId" FOREIGN KEY ("FirmaId") REFERENCES "Firmalar" ("Id") ON DELETE SET NULL
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326090740_TekrarlayanOdeme') THEN
    CREATE INDEX "IX_TekrarlayanOdemeler_FirmaId" ON "TekrarlayanOdemeler" ("FirmaId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326090740_TekrarlayanOdeme') THEN
    CREATE INDEX "IX_TekrarlayanOdemeler_MasrafKalemi" ON "TekrarlayanOdemeler" ("MasrafKalemi");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326090740_TekrarlayanOdeme') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260326090740_TekrarlayanOdeme', '10.0.5');
    END IF;
END $EF$;
COMMIT;

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    ALTER TABLE "Roller" ADD "Renk" text;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE TABLE "Bildirimler" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "KullaniciId" integer NOT NULL,
        "Baslik" character varying(200) NOT NULL,
        "Icerik" character varying(1000),
        "Tip" integer NOT NULL,
        "Oncelik" integer NOT NULL,
        "Okundu" boolean NOT NULL,
        "OkunmaTarihi" timestamp without time zone,
        "IliskiliTablo" character varying(50),
        "IliskiliKayitId" integer,
        "Link" character varying(200),
        "SonGosterimTarihi" timestamp without time zone,
        "Tekrarli" boolean NOT NULL,
        "CreatedAt" timestamp without time zone NOT NULL,
        "UpdatedAt" timestamp without time zone,
        "IsDeleted" boolean NOT NULL,
        CONSTRAINT "PK_Bildirimler" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Bildirimler_Kullanicilar_KullaniciId" FOREIGN KEY ("KullaniciId") REFERENCES "Kullanicilar" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE TABLE "DashboardWidgetlar" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "KullaniciId" integer NOT NULL,
        "WidgetKodu" character varying(50) NOT NULL,
        "Sira" integer NOT NULL,
        "Kolon" integer NOT NULL,
        "Genislik" integer NOT NULL,
        "Gorunur" boolean NOT NULL,
        "Kucultulmus" boolean NOT NULL,
        "Ayarlar" character varying(2000),
        "CreatedAt" timestamp without time zone NOT NULL,
        "UpdatedAt" timestamp without time zone,
        "IsDeleted" boolean NOT NULL,
        CONSTRAINT "PK_DashboardWidgetlar" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_DashboardWidgetlar_Kullanicilar_KullaniciId" FOREIGN KEY ("KullaniciId") REFERENCES "Kullanicilar" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE TABLE "EmailAyarlari" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "KullaniciId" integer,
        "SmtpSunucu" character varying(100) NOT NULL,
        "SmtpPort" integer NOT NULL,
        "SslKullan" boolean NOT NULL,
        "Email" character varying(100) NOT NULL,
        "Sifre" character varying(100),
        "GonderenAdi" character varying(100),
        "Aktif" boolean NOT NULL,
        "CreatedAt" timestamp without time zone NOT NULL,
        "UpdatedAt" timestamp without time zone,
        "IsDeleted" boolean NOT NULL,
        CONSTRAINT "PK_EmailAyarlari" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_EmailAyarlari_Kullanicilar_KullaniciId" FOREIGN KEY ("KullaniciId") REFERENCES "Kullanicilar" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE TABLE "Hatirlaticilar" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "KullaniciId" integer NOT NULL,
        "Baslik" character varying(200) NOT NULL,
        "Aciklama" character varying(1000),
        "Tip" integer NOT NULL,
        "BaslangicTarihi" timestamp without time zone NOT NULL,
        "BitisTarihi" timestamp without time zone,
        "TumGun" boolean NOT NULL,
        "TekrarTipi" integer NOT NULL,
        "TekrarAraligi" integer NOT NULL,
        "TekrarBitisTarihi" timestamp without time zone,
        "BildirimDakikaOnce" integer NOT NULL,
        "EmailBildirim" boolean NOT NULL,
        "PushBildirim" boolean NOT NULL,
        "IliskiliTablo" character varying(50),
        "IliskiliKayitId" integer,
        "Durum" integer NOT NULL,
        "Renk" character varying(20),
        "CariId" integer,
        "CreatedAt" timestamp without time zone NOT NULL,
        "UpdatedAt" timestamp without time zone,
        "IsDeleted" boolean NOT NULL,
        CONSTRAINT "PK_Hatirlaticilar" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Hatirlaticilar_Cariler_CariId" FOREIGN KEY ("CariId") REFERENCES "Cariler" ("Id") ON DELETE SET NULL,
        CONSTRAINT "FK_Hatirlaticilar_Kullanicilar_KullaniciId" FOREIGN KEY ("KullaniciId") REFERENCES "Kullanicilar" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE TABLE "KullaniciCariler" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "KullaniciId" integer NOT NULL,
        "CariId" integer NOT NULL,
        "EkstreGorebilir" boolean NOT NULL,
        "FaturaGorebilir" boolean NOT NULL,
        "OdemeYapabilir" boolean NOT NULL,
        "DuzenlemeYapabilir" boolean NOT NULL,
        "Tip" integer NOT NULL,
        "Not" character varying(500),
        "CreatedAt" timestamp without time zone NOT NULL,
        "UpdatedAt" timestamp without time zone,
        "IsDeleted" boolean NOT NULL,
        CONSTRAINT "PK_KullaniciCariler" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_KullaniciCariler_Cariler_CariId" FOREIGN KEY ("CariId") REFERENCES "Cariler" ("Id") ON DELETE CASCADE,
        CONSTRAINT "FK_KullaniciCariler_Kullanicilar_KullaniciId" FOREIGN KEY ("KullaniciId") REFERENCES "Kullanicilar" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE TABLE "Mesajlar" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "GonderenId" integer NOT NULL,
        "AliciId" integer,
        "Konu" character varying(200) NOT NULL,
        "Icerik" text NOT NULL,
        "Tip" integer NOT NULL,
        "Durum" integer NOT NULL,
        "Okundu" boolean NOT NULL,
        "OkunmaTarihi" timestamp without time zone,
        "DisAlici" character varying(100),
        "DisGonderimId" character varying(100),
        "UstMesajId" integer,
        "CreatedAt" timestamp without time zone NOT NULL,
        "UpdatedAt" timestamp without time zone,
        "IsDeleted" boolean NOT NULL,
        CONSTRAINT "PK_Mesajlar" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_Mesajlar_Kullanicilar_AliciId" FOREIGN KEY ("AliciId") REFERENCES "Kullanicilar" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_Mesajlar_Kullanicilar_GonderenId" FOREIGN KEY ("GonderenId") REFERENCES "Kullanicilar" ("Id") ON DELETE RESTRICT,
        CONSTRAINT "FK_Mesajlar_Mesajlar_UstMesajId" FOREIGN KEY ("UstMesajId") REFERENCES "Mesajlar" ("Id") ON DELETE SET NULL
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE TABLE "WhatsAppAyarlari" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "KullaniciId" integer,
        "Telefon" character varying(20),
        "ApiKey" character varying(500),
        "WebhookUrl" character varying(200),
        "Aktif" boolean NOT NULL,
        "CreatedAt" timestamp without time zone NOT NULL,
        "UpdatedAt" timestamp without time zone,
        "IsDeleted" boolean NOT NULL,
        CONSTRAINT "PK_WhatsAppAyarlari" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_WhatsAppAyarlari_Kullanicilar_KullaniciId" FOREIGN KEY ("KullaniciId") REFERENCES "Kullanicilar" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE INDEX "IX_Bildirimler_KullaniciId_Okundu" ON "Bildirimler" ("KullaniciId", "Okundu");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE UNIQUE INDEX "IX_DashboardWidgetlar_KullaniciId_WidgetKodu" ON "DashboardWidgetlar" ("KullaniciId", "WidgetKodu");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE INDEX "IX_EmailAyarlari_KullaniciId" ON "EmailAyarlari" ("KullaniciId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE INDEX "IX_Hatirlaticilar_CariId" ON "Hatirlaticilar" ("CariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE INDEX "IX_Hatirlaticilar_KullaniciId_BaslangicTarihi" ON "Hatirlaticilar" ("KullaniciId", "BaslangicTarihi");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE INDEX "IX_KullaniciCariler_CariId" ON "KullaniciCariler" ("CariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE UNIQUE INDEX "IX_KullaniciCariler_KullaniciId_CariId" ON "KullaniciCariler" ("KullaniciId", "CariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE INDEX "IX_Mesajlar_AliciId_Okundu" ON "Mesajlar" ("AliciId", "Okundu");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE INDEX "IX_Mesajlar_GonderenId" ON "Mesajlar" ("GonderenId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE INDEX "IX_Mesajlar_UstMesajId" ON "Mesajlar" ("UstMesajId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    CREATE INDEX "IX_WhatsAppAyarlari_KullaniciId" ON "WhatsAppAyarlari" ("KullaniciId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326204037_CRMModulu') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260326204037_CRMModulu', '10.0.5');
    END IF;
END $EF$;
COMMIT;

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326214329_CariPersonelSoforIliski') THEN
    DROP INDEX "IX_KullaniciCariler_KullaniciId_CariId";
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326214329_CariPersonelSoforIliski') THEN
    ALTER TABLE "Cariler" ADD "SoforId" integer;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326214329_CariPersonelSoforIliski') THEN
    CREATE INDEX "IX_KullaniciCariler_KullaniciId_CariId" ON "KullaniciCariler" ("KullaniciId", "CariId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326214329_CariPersonelSoforIliski') THEN
    CREATE INDEX "IX_Cariler_SoforId" ON "Cariler" ("SoforId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326214329_CariPersonelSoforIliski') THEN
    ALTER TABLE "Cariler" ADD CONSTRAINT "FK_Cariler_Soforler_SoforId" FOREIGN KEY ("SoforId") REFERENCES "Soforler" ("Id") ON DELETE SET NULL;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260326214329_CariPersonelSoforIliski') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260326214329_CariPersonelSoforIliski', '10.0.5');
    END IF;
END $EF$;
COMMIT;

