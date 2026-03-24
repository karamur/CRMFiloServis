using System;
using System.IO;
using System.Management;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Windows.Forms;

namespace CRMFiloServis.LisansDesktop
{
    public partial class Form1 : Form
    {
        private const string LisansAnahtar = "CRMFiloServis2026SecretKey!@#";
        private LisansBilgi? mevcutLisans;

        public Form1()
        {
            InitializeComponent();

            // Baþlangýçta müþteri makine kodunu göster
            txtMusteriMakineKodu.Text = GetMachineCode();

            // Varsayýlan süre deðerleri
            numGun.Value = 0;
            numAy.Value = 0;
            numYil.Value = 1;
        }

        private void btnOlustur_Click(object sender, EventArgs e)
        {
            // Validation
            if (string.IsNullOrWhiteSpace(txtFirmaAdi.Text))
            {
                MessageBox.Show("Firma adý boþ olamaz!", "Uyarý", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtFirmaAdi.Focus();
                return;
            }

            if (string.IsNullOrWhiteSpace(txtMusteriMakineKodu.Text))
            {
                MessageBox.Show("Müþteri makine kodu boþ olamaz!", "Uyarý", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtMusteriMakineKodu.Focus();
                return;
            }

            try
            {
                // Süre hesaplama
                int toplamGun = (int)numGun.Value;
                int toplamAy = (int)numAy.Value;
                int toplamYil = (int)numYil.Value;

                if (toplamGun == 0 && toplamAy == 0 && toplamYil == 0)
                {
                    MessageBox.Show("Lütfen en az bir süre deðeri girin!", "Uyarý", 
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                string lisansTip;
                if (toplamYil >= 5)
                    lisansTip = "Enterprise";
                else if (toplamYil >= 2)
                    lisansTip = "Professional";
                else if (toplamYil >= 1)
                    lisansTip = "Standard";
                else
                    lisansTip = "Trial";

                // Lisans Oluþtur
                var bitisTarihi = DateTime.Today
                    .AddYears(toplamYil)
                    .AddMonths(toplamAy)
                    .AddDays(toplamGun);

                var lisans = new LisansBilgi
                {
                    LisansKodu = GenerateLisansKodu(),
                    FirmaAdi = txtFirmaAdi.Text.Trim(),
                    YetkiliKisi = txtYetkili.Text.Trim(),
                    Email = txtEmail.Text.Trim(),
                    Telefon = txtTelefon.Text.Trim(),
                    LisansTipi = lisansTip,
                    BaslangicTarihi = DateTime.Today,
                    BitisTarihi = bitisTarihi,
                    MaxKullaniciSayisi = (int)numMaxKullanici.Value,
                    MaxAracSayisi = (int)numMaxArac.Value,
                    MakineKodu = txtMusteriMakineKodu.Text.Trim(),
                    Aktif = true
                };

                // Lisans Anahtarý Oluþtur
                var lisansJson = JsonSerializer.Serialize(lisans);
                var lisansAnahtari = EncryptString(lisansJson);

                // Sonuçlarý Göster
                mevcutLisans = lisans;

                var toplamSure = (bitisTarihi - DateTime.Today).Days;

                txtLisansBilgi.Text = $@"?????????????????????????????????????????????????????????
?           LÝSANS BAÞARIYLA OLUÞTURULDU!              ?
?????????????????????????????????????????????????????????

Lisans Kodu       : {lisans.LisansKodu}
Firma Adý         : {lisans.FirmaAdi}
Yetkili Kiþi      : {lisans.YetkiliKisi}
Email             : {lisans.Email}
Telefon           : {lisans.Telefon}
Lisans Tipi       : {lisans.LisansTipi}
Baþlangýç Tarihi  : {lisans.BaslangicTarihi:dd.MM.yyyy}
Bitiþ Tarihi      : {lisans.BitisTarihi:dd.MM.yyyy}
Toplam Süre       : {toplamYil} yýl, {toplamAy} ay, {toplamGun} gün ({toplamSure} gün)
Max Kullanýcý     : {lisans.MaxKullaniciSayisi}
Max Araç          : {lisans.MaxAracSayisi}
Makine Kodu       : {FormatMachineCode(lisans.MakineKodu)}

??  ÖNEMLÝ: Bu lisans sadece belirtilen makine kodunda geçerlidir!

???????????????????????????????????????????????????????
LÝSANS ANAHTARI (Aþaðýda):
";

                txtLisansAnahtari.Text = lisansAnahtari;

                btnKopyala.Enabled = true;
                btnKaydet.Enabled = true;

                MessageBox.Show("Lisans baþarýyla oluþturuldu!\n\n?? Bu lisans sadece belirtilen makine kodunda çalýþacaktýr.\n\nLütfen lisans anahtarýný kopyalayýn veya dosyaya kaydedin.",
                    "Baþarýlý", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hata: {ex.Message}", "Hata", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnMakineKoduGetir_Click(object sender, EventArgs e)
        {
            try
            {
                var machineCode = GetMachineCode();
                txtMusteriMakineKodu.Text = machineCode;
                MessageBox.Show($"Bu bilgisayarýn makine kodu:\n\n{FormatMachineCode(machineCode)}\n\nPanoya kopyalandý!",
                    "Makine Kodu", MessageBoxButtons.OK, MessageBoxIcon.Information);
                Clipboard.SetText(machineCode);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hata: {ex.Message}", "Hata", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnKopyala_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtLisansAnahtari.Text))
            {
                Clipboard.SetText(txtLisansAnahtari.Text);
                MessageBox.Show("Lisans anahtarý panoya kopyalandý!", "Baþarýlý", 
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

        private void btnKaydet_Click(object sender, EventArgs e)
        {
            if (mevcutLisans == null) return;

            try
            {
                var saveDialog = new SaveFileDialog
                {
                    Filter = "Text Dosyasý|*.txt",
                    FileName = $"Lisans_{mevcutLisans.FirmaAdi.Replace(" ", "")}_{DateTime.Now:yyyyMMdd_HHmmss}.txt",
                    Title = "Lisans Dosyasýný Kaydet"
                };

                if (saveDialog.ShowDialog() == DialogResult.OK)
                {
                    var toplamSure = (mevcutLisans.BitisTarihi - mevcutLisans.BaslangicTarihi).Days;

                    var content = $@"CRM FÝLO SERVÝS LÝSANS BÝLGÝSÝ
???????????????????????????????????????

Lisans Kodu       : {mevcutLisans.LisansKodu}
Firma Adý         : {mevcutLisans.FirmaAdi}
Yetkili Kiþi      : {mevcutLisans.YetkiliKisi}
Email             : {mevcutLisans.Email}
Telefon           : {mevcutLisans.Telefon}
Lisans Tipi       : {mevcutLisans.LisansTipi}
Baþlangýç Tarihi  : {mevcutLisans.BaslangicTarihi:dd.MM.yyyy}
Bitiþ Tarihi      : {mevcutLisans.BitisTarihi:dd.MM.yyyy}
Toplam Süre       : {toplamSure} gün
Max Kullanýcý     : {mevcutLisans.MaxKullaniciSayisi}
Max Araç          : {mevcutLisans.MaxAracSayisi}
Makine Kodu       : {FormatMachineCode(mevcutLisans.MakineKodu)}

??  ÖNEMLÝ UYARI:
Bu lisans SADECE yukarýdaki makine koduna sahip bilgisayarda geçerlidir!
Baþka bir bilgisayarda kullanýlamaz.

LÝSANS ANAHTARI:
???????????????????????????????????????
{txtLisansAnahtari.Text}

NOT: Bu anahtarý güvenli bir yerde saklayýn!
Programda Ayarlar > Lisans menüsünden girebilirsiniz.
";

                    File.WriteAllText(saveDialog.FileName, content, Encoding.UTF8);
                    MessageBox.Show($"Lisans dosyasý baþarýyla kaydedildi:\n{saveDialog.FileName}",
                        "Baþarýlý", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Hata: {ex.Message}", "Hata", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnDogrula_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtDogrulaAnahtar.Text))
            {
                MessageBox.Show("Lütfen lisans anahtarýný girin!", "Uyarý", 
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            try
            {
                var lisansJson = DecryptString(txtDogrulaAnahtar.Text.Trim());
                var lisans = JsonSerializer.Deserialize<LisansBilgi>(lisansJson);

                if (lisans == null)
                {
                    txtDogrulaSonuc.Text = "? GEÇERSÝZ LÝSANS ANAHTARI!";
                    txtDogrulaSonuc.ForeColor = Color.Red;
                    MessageBox.Show("Geçersiz lisans anahtarý!", "Hata", 
                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

                var kalanGun = (lisans.BitisTarihi - DateTime.Today).Days;
                var gecerli = lisans.Aktif && kalanGun >= 0;

                // Makine kodu kontrolü
                var buMakineKodu = GetMachineCode();
                var makineUyumlu = lisans.MakineKodu == buMakineKodu;

                txtDogrulaSonuc.ForeColor = (gecerli && makineUyumlu) ? Color.Green : Color.Red;

                txtDogrulaSonuc.Text = $@"?????????????????????????????????????????????????????????
?     {(gecerli && makineUyumlu ? "? LÝSANS GEÇERLÝ" : "? LÝSANS GEÇERSÝZ")}                            ?
?????????????????????????????????????????????????????????

Lisans Kodu       : {lisans.LisansKodu}
Firma Adý         : {lisans.FirmaAdi}
Yetkili Kiþi      : {lisans.YetkiliKisi}
Email             : {lisans.Email}
Telefon           : {lisans.Telefon}
Lisans Tipi       : {lisans.LisansTipi}
Baþlangýç Tarihi  : {lisans.BaslangicTarihi:dd.MM.yyyy}
Bitiþ Tarihi      : {lisans.BitisTarihi:dd.MM.yyyy}
{(gecerli ? $"Kalan Gün         : {kalanGun} gün" : $"Lisans Süresi     : {Math.Abs(kalanGun)} gün önce dolmuþ!")}
Max Kullanýcý     : {lisans.MaxKullaniciSayisi}
Max Araç          : {lisans.MaxAracSayisi}
Durum             : {(lisans.Aktif ? "Aktif" : "Pasif")}

???????????????????????????????????????????????????????
MAKÝNE KODU KONTROLÜ:
???????????????????????????????????????????????????????
Lisansta Kayýtlý  : {FormatMachineCode(lisans.MakineKodu)}
Bu Bilgisayar     : {FormatMachineCode(buMakineKodu)}
Durum             : {(makineUyumlu ? "? UYUMLU" : "? UYUMSUZ - Bu bilgisayarda çalýþmaz!")}
";

                var mesaj = "";
                if (!gecerli)
                    mesaj = "Lisans süresi dolmuþ veya pasif!";
                else if (!makineUyumlu)
                    mesaj = "?? Lisans bu bilgisayar için geçerli deðil!\n\nBu lisans baþka bir bilgisayar için oluþturulmuþ.";
                else
                    mesaj = "Lisans geçerli ve bu bilgisayarda kullanýlabilir!";

                MessageBox.Show(mesaj,
                    (gecerli && makineUyumlu) ? "Baþarýlý" : "Uyarý",
                    MessageBoxButtons.OK,
                    (gecerli && makineUyumlu) ? MessageBoxIcon.Information : MessageBoxIcon.Warning);
            }
            catch (Exception ex)
            {
                txtDogrulaSonuc.Text = $"? HATA:\n{ex.Message}";
                txtDogrulaSonuc.ForeColor = Color.Red;
                MessageBox.Show($"Lisans doðrulama hatasý:\n{ex.Message}", "Hata",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private static string GetMachineCode()
        {
            try
            {
                var cpuId = GetCpuId();
                var motherboardSerial = GetMotherboardSerial();
                var diskSerial = GetDiskSerial();

                var combined = $"{cpuId}-{motherboardSerial}-{diskSerial}";

                using var sha256 = SHA256.Create();
                var hash = sha256.ComputeHash(Encoding.UTF8.GetBytes(combined));
                return Convert.ToBase64String(hash).Substring(0, 32).Replace("/", "").Replace("+", "");
            }
            catch
            {
                return Environment.MachineName.GetHashCode().ToString("X8");
            }
        }

        private static string GetCpuId()
        {
            try
            {
                var searcher = new ManagementObjectSearcher("SELECT ProcessorId FROM Win32_Processor");
                foreach (ManagementObject obj in searcher.Get())
                {
                    return obj["ProcessorId"]?.ToString() ?? "UNKNOWN";
                }
            }
            catch { }
            return "CPU-UNKNOWN";
        }

        private static string GetMotherboardSerial()
        {
            try
            {
                var searcher = new ManagementObjectSearcher("SELECT SerialNumber FROM Win32_BaseBoard");
                foreach (ManagementObject obj in searcher.Get())
                {
                    return obj["SerialNumber"]?.ToString() ?? "UNKNOWN";
                }
            }
            catch { }
            return "MB-UNKNOWN";
        }

        private static string GetDiskSerial()
        {
            try
            {
                var searcher = new ManagementObjectSearcher("SELECT SerialNumber FROM Win32_PhysicalMedia");
                foreach (ManagementObject obj in searcher.Get())
                {
                    var serial = obj["SerialNumber"]?.ToString()?.Trim();
                    if (!string.IsNullOrEmpty(serial))
                        return serial;
                }
            }
            catch { }
            return "DISK-UNKNOWN";
        }

        private static string FormatMachineCode(string machineCode)
        {
            if (string.IsNullOrEmpty(machineCode) || machineCode.Length < 16)
                return machineCode;

            var formatted = "";
            for (int i = 0; i < Math.Min(machineCode.Length, 16); i++)
            {
                if (i > 0 && i % 4 == 0)
                    formatted += "-";
                formatted += machineCode[i];
            }
            return formatted;
        }

        private static string GenerateLisansKodu()
        {
            var random = new Random();
            var part1 = random.Next(1000, 9999);
            var part2 = random.Next(1000, 9999);
            var part3 = random.Next(1000, 9999);
            var part4 = random.Next(1000, 9999);
            return $"CRM-{part1}-{part2}-{part3}-{part4}";
        }

        private static string EncryptString(string plainText)
        {
            using var aes = Aes.Create();
            var key = SHA256.HashData(Encoding.UTF8.GetBytes(LisansAnahtar));
            aes.Key = key;
            aes.GenerateIV();

            using var encryptor = aes.CreateEncryptor(aes.Key, aes.IV);
            using var msEncrypt = new MemoryStream();
            msEncrypt.Write(aes.IV, 0, aes.IV.Length);

            using (var csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
            using (var swEncrypt = new StreamWriter(csEncrypt))
            {
                swEncrypt.Write(plainText);
            }

            return Convert.ToBase64String(msEncrypt.ToArray());
        }

        private static string DecryptString(string cipherText)
        {
            var fullCipher = Convert.FromBase64String(cipherText);

            using var aes = Aes.Create();
            var key = SHA256.HashData(Encoding.UTF8.GetBytes(LisansAnahtar));
            aes.Key = key;

            var iv = new byte[aes.IV.Length];
            var cipher = new byte[fullCipher.Length - iv.Length];

            Array.Copy(fullCipher, iv, iv.Length);
            Array.Copy(fullCipher, iv.Length, cipher, 0, cipher.Length);

            aes.IV = iv;

            using var decryptor = aes.CreateDecryptor(aes.Key, aes.IV);
            using var msDecrypt = new MemoryStream(cipher);
            using var csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read);
            using var srDecrypt = new StreamReader(csDecrypt);

            return srDecrypt.ReadToEnd();
        }
    }

    public class LisansBilgi
    {
        public string LisansKodu { get; set; } = "";
        public string FirmaAdi { get; set; } = "";
        public string YetkiliKisi { get; set; } = "";
        public string Email { get; set; } = "";
        public string Telefon { get; set; } = "";
        public string LisansTipi { get; set; } = "";
        public DateTime BaslangicTarihi { get; set; }
        public DateTime BitisTarihi { get; set; }
        public int MaxKullaniciSayisi { get; set; }
        public int MaxAracSayisi { get; set; }
        public string MakineKodu { get; set; } = "";  // YENÝ: Makine kodu
        public bool Aktif { get; set; }
    }
}
