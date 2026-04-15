using System.Diagnostics;
using System.IO.Compression;
using System.Reflection;
using System.Text.Json;
using KOAFiloServis.Shared;
using KOAFiloServis.Shared.Entities;

namespace KOAFiloServis.Installer;

public partial class MainForm : Form
{
    private const string EmbeddedPackageFileName = "KOAFiloServis-package.zip";
    private enum KurulumTipi { Normal, Docker }
    private enum KurulumModu { YeniKurulum, MevcutYedekIle }

    private KurulumTipi _kurulumTipi = KurulumTipi.Normal;
    private KurulumModu _kurulumModu = KurulumModu.YeniKurulum;
    private string _hedefDizin = @"C:\KOAFiloServis";
    private string? _yedekDosyaYolu;
    private string? _paketDosyaYolu;
    private string _yedekKayitKlasoru = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), "KOAFiloServis_Yedekler");

    public MainForm()
    {
        InitializeComponent();
        txtMakineKodu.Text = LisansHelper.GetMachineCode();
        InitializePackageSource();
        InitializeBackupSettings();
        FormClosed += (_, _) => CleanupTemporaryPackageFiles();
    }

    private void InitializeBackupSettings()
    {
        // Varsayılan yedek kayıt konumu
        txtYedekKayitYolu.Text = _yedekKayitKlasoru;

        // Mevcut yedekleri listele
        RefreshBackupList();

        // dbsettings.json varsa ayarları yükle
        LoadDbSettingsIfExists();
    }

    private void LoadDbSettingsIfExists()
    {
        var dbSettingsPath = Path.Combine(AppContext.BaseDirectory, "dbsettings.json");
        if (!File.Exists(dbSettingsPath))
        {
            // Yandaki dizinlere bak
            var parentDir = Directory.GetParent(AppContext.BaseDirectory)?.FullName;
            if (parentDir != null)
            {
                var webPath = Path.Combine(parentDir, "KOAFiloServis.Web", "dbsettings.json");
                if (File.Exists(webPath))
                    dbSettingsPath = webPath;
            }
        }

        if (File.Exists(dbSettingsPath))
        {
            try
            {
                var json = File.ReadAllText(dbSettingsPath);
                var settings = JsonSerializer.Deserialize<DbSettings>(json);
                if (settings != null && settings.Provider == "PostgreSQL")
                {
                    txtYedekHost.Text = settings.Host ?? "localhost";
                    txtYedekPort.Text = settings.Port?.ToString() ?? "5432";
                    txtYedekDatabase.Text = settings.DatabaseName ?? "";
                    txtYedekUser.Text = settings.Username ?? "postgres";
                    txtYedekPassword.Text = settings.Password ?? "";

                    txtYukleHost.Text = settings.Host ?? "localhost";
                    txtYuklePort.Text = settings.Port?.ToString() ?? "5432";
                    txtYukleDatabase.Text = settings.DatabaseName ?? "";
                    txtYukleUser.Text = settings.Username ?? "postgres";
                    txtYuklePassword.Text = settings.Password ?? "";
                }
            }
            catch { }
        }
    }

    private void RefreshBackupList()
    {
        lstYedekGecmis.Items.Clear();

        if (Directory.Exists(_yedekKayitKlasoru))
        {
            var files = Directory.GetFiles(_yedekKayitKlasoru, "*.zip")
                .Union(Directory.GetFiles(_yedekKayitKlasoru, "*.sql"))
                .OrderByDescending(f => File.GetCreationTime(f))
                .Take(20);

            foreach (var file in files)
            {
                var info = new FileInfo(file);
                var sizeKb = info.Length / 1024.0;
                var sizeDisplay = sizeKb > 1024 ? $"{sizeKb / 1024:F2} MB" : $"{sizeKb:F0} KB";
                lstYedekGecmis.Items.Add($"{info.CreationTime:yyyy-MM-dd HH:mm} | {info.Name} | {sizeDisplay}");
            }
        }
    }

    #region Yedek Al Tab Events

    private void btnYedekKonumSec_Click(object sender, EventArgs e)
    {
        using var dlg = new FolderBrowserDialog
        {
            Description = "Yedek Kayıt Konumu Seçin",
            SelectedPath = _yedekKayitKlasoru
        };

        if (dlg.ShowDialog() == DialogResult.OK)
        {
            _yedekKayitKlasoru = dlg.SelectedPath;
            txtYedekKayitYolu.Text = _yedekKayitKlasoru;
            RefreshBackupList();
        }
    }

    private async void btnYedekBaglantiTest_Click(object sender, EventArgs e)
    {
        btnYedekBaglantiTest.Enabled = false;
        lblYedekAlDurum.Text = "Bağlantı test ediliyor...";
        lblYedekAlDurum.ForeColor = Color.DarkBlue;

        try
        {
            var result = await TestPostgreSqlConnectionAsync(
                txtYedekHost.Text, txtYedekPort.Text, txtYedekDatabase.Text,
                txtYedekUser.Text, txtYedekPassword.Text);

            if (result.Success)
            {
                lblYedekAlDurum.Text = "✅ Bağlantı başarılı!";
                lblYedekAlDurum.ForeColor = Color.DarkGreen;
            }
            else
            {
                lblYedekAlDurum.Text = $"❌ Bağlantı hatası: {result.Message}";
                lblYedekAlDurum.ForeColor = Color.DarkRed;
            }
        }
        catch (Exception ex)
        {
            lblYedekAlDurum.Text = $"❌ Hata: {ex.Message}";
            lblYedekAlDurum.ForeColor = Color.DarkRed;
        }
        finally
        {
            btnYedekBaglantiTest.Enabled = true;
        }
    }

    private async void btnYedekAl_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrWhiteSpace(txtYedekDatabase.Text))
        {
            MessageBox.Show("Veritabanı adı boş olamaz!", "Uyarı", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        btnYedekAl.Enabled = false;
        progressYedekAl.Value = 0;

        try
        {
            lblYedekAlDurum.Text = "Yedek alınıyor...";
            lblYedekAlDurum.ForeColor = Color.DarkBlue;
            progressYedekAl.Value = 10;

            Directory.CreateDirectory(_yedekKayitKlasoru);

            var timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
            var backupDir = Path.Combine(_yedekKayitKlasoru, $"KOAFiloServis_Backup_{timestamp}");
            Directory.CreateDirectory(backupDir);

            var sqlFile = Path.Combine(backupDir, "database.sql");

            progressYedekAl.Value = 30;
            lblYedekAlDurum.Text = "pg_dump çalıştırılıyor...";

            var pgDumpResult = await RunPgDumpAsync(
                txtYedekHost.Text, txtYedekPort.Text, txtYedekDatabase.Text,
                txtYedekUser.Text, txtYedekPassword.Text, sqlFile);

            if (!pgDumpResult.Success)
            {
                lblYedekAlDurum.Text = $"❌ pg_dump hatası: {pgDumpResult.Message}";
                lblYedekAlDurum.ForeColor = Color.DarkRed;
                return;
            }

            progressYedekAl.Value = 70;
            lblYedekAlDurum.Text = "ZIP paketi oluşturuluyor...";

            // dbsettings.json kaydet
            var dbSettings = new DbSettings
            {
                Provider = "PostgreSQL",
                Host = txtYedekHost.Text,
                Port = int.TryParse(txtYedekPort.Text, out var p) ? p : 5432,
                DatabaseName = txtYedekDatabase.Text,
                Username = txtYedekUser.Text,
                Password = txtYedekPassword.Text
            };
            var settingsJson = JsonSerializer.Serialize(dbSettings, new JsonSerializerOptions { WriteIndented = true });
            File.WriteAllText(Path.Combine(backupDir, "dbsettings.json"), settingsJson);

            // ZIP oluştur
            var zipFile = backupDir + ".zip";
            if (File.Exists(zipFile)) File.Delete(zipFile);
            ZipFile.CreateFromDirectory(backupDir, zipFile);

            progressYedekAl.Value = 90;

            // Geçici dizini temizle
            try { Directory.Delete(backupDir, true); } catch { }

            progressYedekAl.Value = 100;
            lblYedekAlDurum.Text = $"✅ Yedek alındı: {Path.GetFileName(zipFile)}";
            lblYedekAlDurum.ForeColor = Color.DarkGreen;

            RefreshBackupList();

            MessageBox.Show($"Yedek başarıyla alındı!\n\n{zipFile}", "Başarılı", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        catch (Exception ex)
        {
            lblYedekAlDurum.Text = $"❌ Hata: {ex.Message}";
            lblYedekAlDurum.ForeColor = Color.DarkRed;
            MessageBox.Show($"Yedek alınırken hata oluştu:\n{ex.Message}", "Hata", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnYedekAl.Enabled = true;
        }
    }

    #endregion

    #region Yedek Yükle Tab Events

    private void btnYukleDosyaSec_Click(object sender, EventArgs e)
    {
        using var dlg = new OpenFileDialog
        {
            Title = "Yedek Dosyası Seçin",
            Filter = "Yedek Dosyaları|*.zip;*.sql|ZIP Dosyaları|*.zip|SQL Dosyaları|*.sql|Tüm Dosyalar|*.*",
            InitialDirectory = _yedekKayitKlasoru
        };

        if (dlg.ShowDialog() == DialogResult.OK)
        {
            txtYukleDosyaYolu.Text = dlg.FileName;
            var info = new FileInfo(dlg.FileName);
            var sizeKb = info.Length / 1024.0;
            var sizeDisplay = sizeKb > 1024 ? $"{sizeKb / 1024:F2} MB" : $"{sizeKb:F0} KB";
            lblYukleDosyaBilgi.Text = $"Dosya: {info.Name} | Boyut: {sizeDisplay} | Tarih: {info.CreationTime:yyyy-MM-dd HH:mm}";
            lblYukleDosyaBilgi.ForeColor = Color.DarkGreen;
        }
    }

    private async void btnYukleBaglantiTest_Click(object sender, EventArgs e)
    {
        btnYukleBaglantiTest.Enabled = false;
        lblYedekYukleDurum.Text = "Bağlantı test ediliyor...";
        lblYedekYukleDurum.ForeColor = Color.DarkBlue;

        try
        {
            var result = await TestPostgreSqlConnectionAsync(
                txtYukleHost.Text, txtYuklePort.Text, txtYukleDatabase.Text,
                txtYukleUser.Text, txtYuklePassword.Text, chkYukleDbOlustur.Checked);

            if (result.Success)
            {
                lblYedekYukleDurum.Text = "✅ Bağlantı başarılı!";
                lblYedekYukleDurum.ForeColor = Color.DarkGreen;
            }
            else
            {
                lblYedekYukleDurum.Text = $"❌ Bağlantı hatası: {result.Message}";
                lblYedekYukleDurum.ForeColor = Color.DarkRed;
            }
        }
        catch (Exception ex)
        {
            lblYedekYukleDurum.Text = $"❌ Hata: {ex.Message}";
            lblYedekYukleDurum.ForeColor = Color.DarkRed;
        }
        finally
        {
            btnYukleBaglantiTest.Enabled = true;
        }
    }

    private async void btnYedekYukle_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrWhiteSpace(txtYukleDosyaYolu.Text) || !File.Exists(txtYukleDosyaYolu.Text))
        {
            MessageBox.Show("Lütfen geçerli bir yedek dosyası seçin!", "Uyarı", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        var onay = MessageBox.Show(
            $"Yedek yüklenecek:\n{txtYukleDosyaYolu.Text}\n\n" +
            $"Hedef veritabanı: {txtYukleDatabase.Text}@{txtYukleHost.Text}\n\n" +
            "Bu işlem mevcut verileri değiştirebilir. Devam etmek istiyor musunuz?",
            "Yedek Yükleme Onayı",
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Warning);

        if (onay != DialogResult.Yes) return;

        btnYedekYukle.Enabled = false;
        progressYedekYukle.Value = 0;

        try
        {
            lblYedekYukleDurum.Text = "Yedek yükleniyor...";
            lblYedekYukleDurum.ForeColor = Color.DarkBlue;
            progressYedekYukle.Value = 10;

            var backupFile = txtYukleDosyaYolu.Text;
            string? sqlFile = null;
            string? tempDir = null;

            // ZIP ise aç
            if (backupFile.EndsWith(".zip", StringComparison.OrdinalIgnoreCase))
            {
                lblYedekYukleDurum.Text = "ZIP açılıyor...";
                progressYedekYukle.Value = 20;

                tempDir = Path.Combine(Path.GetTempPath(), $"KOAFiloServis_Restore_{Guid.NewGuid():N}");
                ZipFile.ExtractToDirectory(backupFile, tempDir);

                // SQL dosyasını bul
                sqlFile = Directory.GetFiles(tempDir, "*.sql", SearchOption.AllDirectories).FirstOrDefault();
                if (sqlFile == null)
                {
                    throw new FileNotFoundException("ZIP içinde SQL dosyası bulunamadı!");
                }

                // dbsettings.json varsa oku
                var settingsFile = Path.Combine(tempDir, "dbsettings.json");
                if (File.Exists(settingsFile))
                {
                    try
                    {
                        var json = File.ReadAllText(settingsFile);
                        var settings = JsonSerializer.Deserialize<DbSettings>(json);
                        // Opsiyonel: ZIP'teki ayarları kullan
                    }
                    catch { }
                }
            }
            else
            {
                sqlFile = backupFile;
            }

            // Veritabanı oluştur (gerekirse)
            if (chkYukleDbOlustur.Checked)
            {
                lblYedekYukleDurum.Text = "Veritabanı kontrol ediliyor...";
                progressYedekYukle.Value = 30;

                await CreateDatabaseIfNotExistsAsync(
                    txtYukleHost.Text, txtYuklePort.Text, txtYukleDatabase.Text,
                    txtYukleUser.Text, txtYuklePassword.Text);
            }

            // Temizle (gerekirse)
            if (chkYukleTemizle.Checked)
            {
                lblYedekYukleDurum.Text = "Mevcut veriler temizleniyor...";
                progressYedekYukle.Value = 40;

                await DropAndRecreateDatabaseAsync(
                    txtYukleHost.Text, txtYuklePort.Text, txtYukleDatabase.Text,
                    txtYukleUser.Text, txtYuklePassword.Text);
            }

            // psql ile yükle
            lblYedekYukleDurum.Text = "psql ile yükleniyor...";
            progressYedekYukle.Value = 60;

            var psqlResult = await RunPsqlRestoreAsync(
                txtYukleHost.Text, txtYuklePort.Text, txtYukleDatabase.Text,
                txtYukleUser.Text, txtYuklePassword.Text, sqlFile);

            if (!psqlResult.Success)
            {
                lblYedekYukleDurum.Text = $"❌ psql hatası: {psqlResult.Message}";
                lblYedekYukleDurum.ForeColor = Color.DarkRed;
                return;
            }

            progressYedekYukle.Value = 90;

            // Geçici dizini temizle
            if (tempDir != null)
            {
                try { Directory.Delete(tempDir, true); } catch { }
            }

            progressYedekYukle.Value = 100;
            lblYedekYukleDurum.Text = "✅ Yedek başarıyla yüklendi!";
            lblYedekYukleDurum.ForeColor = Color.DarkGreen;

            MessageBox.Show("Yedek başarıyla yüklendi!", "Başarılı", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        catch (Exception ex)
        {
            lblYedekYukleDurum.Text = $"❌ Hata: {ex.Message}";
            lblYedekYukleDurum.ForeColor = Color.DarkRed;
            MessageBox.Show($"Yedek yüklenirken hata oluştu:\n{ex.Message}", "Hata", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnYedekYukle.Enabled = true;
        }
    }

    #endregion

    #region PostgreSQL İşlemleri

    private class DbSettings
    {
        public string? Provider { get; set; }
        public string? Host { get; set; }
        public int? Port { get; set; }
        public string? DatabaseName { get; set; }
        public string? Username { get; set; }
        public string? Password { get; set; }
    }

    private record CommandResult(bool Success, string Message);

    private static string? FindPgTool(string toolName)
    {
        // PATH'te ara
        var pathEnv = Environment.GetEnvironmentVariable("PATH") ?? "";
        foreach (var path in pathEnv.Split(Path.PathSeparator))
        {
            var fullPath = Path.Combine(path, toolName + ".exe");
            if (File.Exists(fullPath)) return fullPath;
        }

        // PostgreSQL kurulum dizinlerini ara
        var programFiles = new[]
        {
            Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles),
            Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86)
        };

        foreach (var pf in programFiles)
        {
            if (string.IsNullOrEmpty(pf)) continue;
            var pgDir = Path.Combine(pf, "PostgreSQL");
            if (!Directory.Exists(pgDir)) continue;

            foreach (var version in Directory.GetDirectories(pgDir).OrderByDescending(d => d))
            {
                var binPath = Path.Combine(version, "bin", toolName + ".exe");
                if (File.Exists(binPath)) return binPath;
            }
        }

        return null;
    }

    private async Task<CommandResult> TestPostgreSqlConnectionAsync(
        string host, string port, string database, string user, string password, bool checkDbExists = true)
    {
        var psql = FindPgTool("psql");
        if (psql == null)
            return new CommandResult(false, "psql bulunamadı. PostgreSQL kurulu ve PATH'e ekli olduğundan emin olun.");

        var testDb = checkDbExists ? database : "postgres";
        var connStr = $"postgresql://{user}:{password}@{host}:{port}/{testDb}";

        var psi = new ProcessStartInfo
        {
            FileName = psql,
            Arguments = $"-d \"{connStr}\" -c \"SELECT 1;\"",
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using var process = Process.Start(psi);
        if (process == null)
            return new CommandResult(false, "psql başlatılamadı");

        var error = await process.StandardError.ReadToEndAsync();
        await process.WaitForExitAsync();

        if (process.ExitCode == 0)
            return new CommandResult(true, "Bağlantı başarılı");

        return new CommandResult(false, error);
    }

    private async Task<CommandResult> RunPgDumpAsync(
        string host, string port, string database, string user, string password, string outputFile)
    {
        var pgDump = FindPgTool("pg_dump");
        if (pgDump == null)
            return new CommandResult(false, "pg_dump bulunamadı. PostgreSQL kurulu ve PATH'e ekli olduğundan emin olun.");

        var connStr = $"postgresql://{user}:{password}@{host}:{port}/{database}";

        var psi = new ProcessStartInfo
        {
            FileName = pgDump,
            Arguments = $"-d \"{connStr}\" --clean --if-exists -f \"{outputFile}\"",
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using var process = Process.Start(psi);
        if (process == null)
            return new CommandResult(false, "pg_dump başlatılamadı");

        var error = await process.StandardError.ReadToEndAsync();
        await process.WaitForExitAsync();

        if (process.ExitCode == 0 && File.Exists(outputFile))
            return new CommandResult(true, "Yedek alındı");

        return new CommandResult(false, string.IsNullOrEmpty(error) ? "pg_dump başarısız" : error);
    }

    private async Task<CommandResult> RunPsqlRestoreAsync(
        string host, string port, string database, string user, string password, string sqlFile)
    {
        var psql = FindPgTool("psql");
        if (psql == null)
            return new CommandResult(false, "psql bulunamadı. PostgreSQL kurulu ve PATH'e ekli olduğundan emin olun.");

        var connStr = $"postgresql://{user}:{password}@{host}:{port}/{database}";

        var psi = new ProcessStartInfo
        {
            FileName = psql,
            Arguments = $"-d \"{connStr}\" -f \"{sqlFile}\" -v ON_ERROR_STOP=0",
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using var process = Process.Start(psi);
        if (process == null)
            return new CommandResult(false, "psql başlatılamadı");

        var error = await process.StandardError.ReadToEndAsync();
        await process.WaitForExitAsync();

        // psql bazı uyarılar verebilir ama işlem başarılı olabilir
        if (process.ExitCode == 0 || string.IsNullOrWhiteSpace(error) || !error.Contains("ERROR"))
            return new CommandResult(true, "Yedek yüklendi");

        return new CommandResult(false, error);
    }

    private async Task CreateDatabaseIfNotExistsAsync(
        string host, string port, string database, string user, string password)
    {
        var psql = FindPgTool("psql");
        if (psql == null) return;

        var connStr = $"postgresql://{user}:{password}@{host}:{port}/postgres";

        var psi = new ProcessStartInfo
        {
            FileName = psql,
            Arguments = $"-d \"{connStr}\" -c \"CREATE DATABASE \\\"{database}\\\" WITH ENCODING 'UTF8';\"",
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using var process = Process.Start(psi);
        if (process != null)
            await process.WaitForExitAsync();
    }

    private async Task DropAndRecreateDatabaseAsync(
        string host, string port, string database, string user, string password)
    {
        var psql = FindPgTool("psql");
        if (psql == null) return;

        var connStr = $"postgresql://{user}:{password}@{host}:{port}/postgres";

        // Bağlantıları kapat ve veritabanını sil
        var dropPsi = new ProcessStartInfo
        {
            FileName = psql,
            Arguments = $"-d \"{connStr}\" -c \"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '{database}'; DROP DATABASE IF EXISTS \\\"{database}\\\"; CREATE DATABASE \\\"{database}\\\" WITH ENCODING 'UTF8';\"",
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using var process = Process.Start(dropPsi);
        if (process != null)
            await process.WaitForExitAsync();
    }

    #endregion

    private readonly List<string> _temporaryPackageFiles = new();

    private void rbNormal_CheckedChanged(object sender, EventArgs e)
    {
        if (rbNormal.Checked)
        {
            _kurulumTipi = KurulumTipi.Normal;
            pnlDockerAyarlari.Visible = false;
            pnlNormalAyarlari.Visible = true;
        }
    }

    private void rbDocker_CheckedChanged(object sender, EventArgs e)
    {
        if (rbDocker.Checked)
        {
            _kurulumTipi = KurulumTipi.Docker;
            pnlDockerAyarlari.Visible = true;
            pnlNormalAyarlari.Visible = false;
        }
    }

    private void rbYeniKurulum_CheckedChanged(object sender, EventArgs e)
    {
        if (rbYeniKurulum.Checked)
        {
            _kurulumModu = KurulumModu.YeniKurulum;
            grpYedek.Enabled = false;
            lblYedekDurum.Text = "Sıfır veritabanı ile kurulum yapılacak.";
        }
    }

    private void rbMevcutYedek_CheckedChanged(object sender, EventArgs e)
    {
        if (rbMevcutYedek.Checked)
        {
            _kurulumModu = KurulumModu.MevcutYedekIle;
            grpYedek.Enabled = true;
            lblYedekDurum.Text = "Yedek dosyası seçilmedi.";
        }
    }

    private void btnYedekSec_Click(object sender, EventArgs e)
    {
        using var dlg = new OpenFileDialog
        {
            Title = "Veritabanı Yedek Dosyası Seçin",
            Filter = "Yedek Dosyaları|*.backup;*.sql;*.bak;*.zip|Tüm Dosyalar|*.*"
        };

        if (dlg.ShowDialog() == DialogResult.OK)
        {
            _yedekDosyaYolu = dlg.FileName;
            lblYedekDurum.Text = $"Seçilen: {Path.GetFileName(_yedekDosyaYolu)}";
        }
    }

    private void btnPaketSec_Click(object sender, EventArgs e)
    {
        using var dlg = new OpenFileDialog
        {
            Title = "Kurulum Paketi Seçin",
            Filter = "ZIP Dosyaları|*.zip"
        };

        if (dlg.ShowDialog() == DialogResult.OK)
        {
            _paketDosyaYolu = dlg.FileName;
            lblPaketDurum.Text = $"Seçilen: {Path.GetFileName(_paketDosyaYolu)}";
        }
    }

    private void btnDizinSec_Click(object sender, EventArgs e)
    {
        using var dlg = new FolderBrowserDialog
        {
            Description = "Kurulum Dizini Seçin",
            SelectedPath = _hedefDizin
        };

        if (dlg.ShowDialog() == DialogResult.OK)
        {
            _hedefDizin = dlg.SelectedPath;
            txtHedefDizin.Text = _hedefDizin;
        }
    }

    private void btnMakineKoduKopyala_Click(object sender, EventArgs e)
    {
        if (!string.IsNullOrWhiteSpace(txtMakineKodu.Text))
        {
            Clipboard.SetText(txtMakineKodu.Text);
            MessageBox.Show("Makine kodu panoya kopyalandı.\n\nBu kodu lisans almak için kullanın.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
    }

    private async void btnKurulumBaslat_Click(object sender, EventArgs e)
    {
        if (!HasAvailablePackage())
        {
            MessageBox.Show("Kurulum paketi bulunamadı. Tek EXE paketini kullanın ya da manuel ZIP seçin.", "Uyarı", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        if (_kurulumModu == KurulumModu.MevcutYedekIle && (string.IsNullOrWhiteSpace(_yedekDosyaYolu) || !File.Exists(_yedekDosyaYolu)))
        {
            MessageBox.Show("Mevcut yedek ile kurulum seçtiniz ancak yedek dosyası belirtmediniz.", "Uyarı", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        var onay = MessageBox.Show(
            $"Kurulum Tipi: {(_kurulumTipi == KurulumTipi.Normal ? "Normal (IIS/Windows)" : "Docker")}\n" +
            $"Kurulum Modu: {(_kurulumModu == KurulumModu.YeniKurulum ? "Sıfır Kurulum" : "Mevcut Yedek İle")}\n" +
            $"Hedef Dizin: {_hedefDizin}\n\n" +
            "Kurulumu başlatmak istiyor musunuz?",
            "Kurulum Onayı",
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Question);

        if (onay != DialogResult.Yes) return;

        btnKurulumBaslat.Enabled = false;
        progressBar.Visible = true;
        lblDurum.Visible = true;

        try
        {
            if (_kurulumTipi == KurulumTipi.Normal)
            {
                await NormalKurulumAsync();
            }
            else
            {
                await DockerKurulumAsync();
            }

            MessageBox.Show("Kurulum başarıyla tamamlandı!", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Kurulum hatası: {ex.Message}", "Hata", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnKurulumBaslat.Enabled = true;
            progressBar.Visible = false;
            lblDurum.Visible = false;
        }
    }

    private async Task NormalKurulumAsync()
    {
        lblDurum.Text = "Dizin oluşturuluyor...";
        progressBar.Value = 10;
        await Task.Delay(100);

        Directory.CreateDirectory(_hedefDizin);

        lblDurum.Text = "Paket açılıyor...";
        progressBar.Value = 30;
        await Task.Delay(100);

        var tempDir = Path.Combine(Path.GetTempPath(), "KOAFiloServis_Install_" + Guid.NewGuid().ToString("N")[..8]);
        Directory.CreateDirectory(tempDir);

        var paketDosyaYolu = await PreparePackageFileAsync();
        ZipFile.ExtractToDirectory(paketDosyaYolu, tempDir, overwriteFiles: true);

        var sourceDir = tempDir;
        var publishSubDir = Path.Combine(tempDir, "publish");
        if (Directory.Exists(publishSubDir))
            sourceDir = publishSubDir;

        lblDurum.Text = "Dosyalar kopyalanıyor...";
        progressBar.Value = 50;
        await Task.Delay(100);

        CopyDirectory(sourceDir, _hedefDizin);

        if (_kurulumModu == KurulumModu.MevcutYedekIle && !string.IsNullOrWhiteSpace(_yedekDosyaYolu))
        {
            lblDurum.Text = "Yedek dosyası kopyalanıyor...";
            progressBar.Value = 70;
            await Task.Delay(100);

            var yedekHedef = Path.Combine(_hedefDizin, "Data", "restore");
            Directory.CreateDirectory(yedekHedef);
            File.Copy(_yedekDosyaYolu, Path.Combine(yedekHedef, Path.GetFileName(_yedekDosyaYolu)), overwrite: true);
        }

        lblDurum.Text = "Yapılandırma oluşturuluyor...";
        progressBar.Value = 85;
        await Task.Delay(100);

        var prodConfig = Path.Combine(_hedefDizin, "appsettings.Production.json");
        var exampleConfig = Path.Combine(_hedefDizin, "appsettings.Production.json.example");
        if (!File.Exists(prodConfig) && File.Exists(exampleConfig))
        {
            File.Copy(exampleConfig, prodConfig);
        }

        ConfigureSqliteForNormalInstall();
        CreateDesktopShortcut();

        try { Directory.Delete(tempDir, true); } catch { }

        lblDurum.Text = "Kurulum tamamlandı.";
        progressBar.Value = 100;
    }

    private async Task DockerKurulumAsync()
    {
        lblDurum.Text = "Docker dizini oluşturuluyor...";
        progressBar.Value = 10;
        await Task.Delay(100);

        var dockerDir = Path.Combine(_hedefDizin, "docker");
        Directory.CreateDirectory(dockerDir);

        lblDurum.Text = "Paket açılıyor...";
        progressBar.Value = 30;
        await Task.Delay(100);

        var tempDir = Path.Combine(Path.GetTempPath(), "KOAFiloServis_Install_" + Guid.NewGuid().ToString("N")[..8]);
        Directory.CreateDirectory(tempDir);

        var paketDosyaYolu = await PreparePackageFileAsync();
        ZipFile.ExtractToDirectory(paketDosyaYolu, tempDir, overwriteFiles: true);

        var sourceDir = tempDir;
        var publishSubDir = Path.Combine(tempDir, "publish");
        if (Directory.Exists(publishSubDir))
            sourceDir = publishSubDir;

        lblDurum.Text = "Dosyalar kopyalanıyor...";
        progressBar.Value = 50;
        await Task.Delay(100);

        CopyDirectory(sourceDir, dockerDir);

        if (_kurulumModu == KurulumModu.MevcutYedekIle && !string.IsNullOrWhiteSpace(_yedekDosyaYolu))
        {
            lblDurum.Text = "Yedek dosyası kopyalanıyor...";
            progressBar.Value = 65;
            await Task.Delay(100);

            var yedekHedef = Path.Combine(dockerDir, "restore");
            Directory.CreateDirectory(yedekHedef);
            File.Copy(_yedekDosyaYolu, Path.Combine(yedekHedef, Path.GetFileName(_yedekDosyaYolu)), overwrite: true);
        }

        lblDurum.Text = "Docker dosyaları oluşturuluyor...";
        progressBar.Value = 80;
        await Task.Delay(100);

        var dockerfile = Path.Combine(dockerDir, "Dockerfile");
        var compose = Path.Combine(dockerDir, "docker-compose.yml");
        var envFile = Path.Combine(dockerDir, ".env");

        File.WriteAllText(dockerfile, GetDockerfileContent());
        File.WriteAllText(compose, GetDockerComposeContent());
        File.WriteAllText(envFile, GetEnvContent());

        try { Directory.Delete(tempDir, true); } catch { }

        lblDurum.Text = "Docker kurulumu tamamlandı.";
        progressBar.Value = 100;

        MessageBox.Show(
            $"Docker dosyaları oluşturuldu:\n{dockerDir}\n\n" +
            "Başlatmak için:\n" +
            "cd " + dockerDir + "\n" +
            "docker compose up -d --build",
            "Docker Kurulum",
            MessageBoxButtons.OK,
            MessageBoxIcon.Information);
    }

    private void InitializePackageSource()
    {
        var adjacentPackage = FindAdjacentPackageFile();
        if (TryGetEmbeddedPackageResourceName() is not null)
        {
            _paketDosyaYolu = null;
            lblPaketDurum.Text = "Gömülü kurulum paketi hazır. Bu EXE tek başına kurulum yapabilir.";
            btnPaketSec.Enabled = false;
            return;
        }

        if (!string.IsNullOrWhiteSpace(adjacentPackage))
        {
            _paketDosyaYolu = adjacentPackage;
            lblPaketDurum.Text = $"Otomatik paket bulundu: {Path.GetFileName(adjacentPackage)}";
            return;
        }

        lblPaketDurum.Text = "Kurulum paketi seçilmedi. Tek EXE değilse ZIP seçin.";
    }

    private bool HasAvailablePackage()
        => TryGetEmbeddedPackageResourceName() is not null || (!string.IsNullOrWhiteSpace(_paketDosyaYolu) && File.Exists(_paketDosyaYolu));

    private async Task<string> PreparePackageFileAsync()
    {
        if (!string.IsNullOrWhiteSpace(_paketDosyaYolu) && File.Exists(_paketDosyaYolu))
        {
            return _paketDosyaYolu;
        }

        var resourceName = TryGetEmbeddedPackageResourceName();
        if (resourceName is null)
        {
            throw new FileNotFoundException("Kurulum paketi bulunamadı.");
        }

        var tempPackagePath = Path.Combine(Path.GetTempPath(), $"KOAFiloServis_Paket_{Guid.NewGuid():N}.zip");
        var assembly = Assembly.GetExecutingAssembly();
        await using var resourceStream = assembly.GetManifestResourceStream(resourceName)
            ?? throw new FileNotFoundException("Gömülü kurulum paketi okunamadı.", resourceName);
        await using var fileStream = File.Create(tempPackagePath);
        await resourceStream.CopyToAsync(fileStream);

        _temporaryPackageFiles.Add(tempPackagePath);
        return tempPackagePath;
    }

    private static string? FindAdjacentPackageFile()
    {
        var baseDir = AppContext.BaseDirectory;
        var directPath = Path.Combine(baseDir, EmbeddedPackageFileName);
        if (File.Exists(directPath))
        {
            return directPath;
        }

        return Directory.GetFiles(baseDir, "*.zip", SearchOption.TopDirectoryOnly)
            .FirstOrDefault(file => Path.GetFileName(file).Contains("KOAFiloServis", StringComparison.OrdinalIgnoreCase));
    }

    private static string? TryGetEmbeddedPackageResourceName()
    {
        return Assembly.GetExecutingAssembly()
            .GetManifestResourceNames()
            .FirstOrDefault(name => name.EndsWith($".{EmbeddedPackageFileName}", StringComparison.OrdinalIgnoreCase));
    }

    private void CleanupTemporaryPackageFiles()
    {
        foreach (var tempFile in _temporaryPackageFiles)
        {
            try
            {
                if (File.Exists(tempFile))
                {
                    File.Delete(tempFile);
                }
            }
            catch
            {
            }
        }
    }

    private static void CopyDirectory(string sourceDir, string destDir)
    {
        Directory.CreateDirectory(destDir);

        foreach (var file in Directory.GetFiles(sourceDir))
        {
            var destFile = Path.Combine(destDir, Path.GetFileName(file));
            File.Copy(file, destFile, overwrite: true);
        }

        foreach (var dir in Directory.GetDirectories(sourceDir))
        {
            var destSubDir = Path.Combine(destDir, Path.GetFileName(dir));
            CopyDirectory(dir, destSubDir);
        }
    }

    private void ConfigureSqliteForNormalInstall()
    {
        var storageRoot = @"C:\KOAFiloServis_yedekleme";
        var sqliteRelativePath = "KOAFiloServis.db";
        var sqliteFullPath = Path.Combine(_hedefDizin, sqliteRelativePath);

        Directory.CreateDirectory(_hedefDizin);
        Directory.CreateDirectory(storageRoot);
        Directory.CreateDirectory(Path.Combine(storageRoot, "database"));
        Directory.CreateDirectory(Path.Combine(storageRoot, "uploads"));
        Directory.CreateDirectory(Path.Combine(storageRoot, "keys"));
        Directory.CreateDirectory(Path.Combine(storageRoot, "logs"));

        if (!File.Exists(sqliteFullPath))
        {
            using var stream = File.Create(sqliteFullPath);
        }

        var prodJson = """
        {
          "DatabaseProvider": "SQLite",
          "ConnectionStrings": {
            "DefaultConnection": "Data Source=KOAFiloServis.db;"
          },
          "OpenAI": {
            "ApiKey": "",
            "Model": "gpt-4o-mini",
            "BaseUrl": "https://api.openai.com/v1"
          },
          "PythonScraper": {
            "BaseUrl": "http://localhost:5050",
            "Enabled": false
          },
          "Logging": {
            "LogLevel": {
              "Default": "Information",
              "Microsoft.AspNetCore": "Warning",
              "Microsoft.EntityFrameworkCore.Database.Command": "Warning",
              "Microsoft.EntityFrameworkCore.Infrastructure": "Warning",
              "System.Net.Http.HttpClient": "Warning"
            }
          },
          "AllowedHosts": "*"
        }
        """;

        File.WriteAllText(Path.Combine(_hedefDizin, "appsettings.Production.json"), prodJson);

        var dbSettings = new DatabaseSettings
        {
            Provider = DatabaseProvider.SQLite,
            DatabaseName = sqliteRelativePath,
            Host = string.Empty,
            Port = 0,
            Username = string.Empty,
            Password = string.Empty,
            UseIntegratedSecurity = false,
            AdditionalOptions = null,
            LastUpdated = DateTime.UtcNow
        };

        var dbSettingsJson = JsonSerializer.Serialize(dbSettings, new JsonSerializerOptions
        {
            WriteIndented = true
        });

        File.WriteAllText(Path.Combine(_hedefDizin, "dbsettings.json"), dbSettingsJson);
    }

    private void CreateDesktopShortcut()
    {
        try
        {
            var exePath = Path.Combine(_hedefDizin, "KOAFiloServis.Web.exe");
            if (!File.Exists(exePath))
                return;

            var desktopPath = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
            if (string.IsNullOrWhiteSpace(desktopPath))
                return;

            var shortcutPath = Path.Combine(desktopPath, "KOAFiloServis.lnk");
            var shellType = Type.GetTypeFromProgID("WScript.Shell");
            if (shellType == null)
                return;

            dynamic shell = Activator.CreateInstance(shellType)!;
            dynamic shortcut = shell.CreateShortcut(shortcutPath);
            shortcut.TargetPath = exePath;
            shortcut.WorkingDirectory = _hedefDizin;
            shortcut.IconLocation = exePath;
            shortcut.Description = "CRM Filo Servis";
            shortcut.Save();
        }
        catch
        {
        }
    }

    private static string GetDockerfileContent() => """
        FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
        WORKDIR /app
        COPY . .
        ENV ASPNETCORE_URLS=http://+:8080
        ENV ASPNETCORE_ENVIRONMENT=Production
        EXPOSE 8080
        ENTRYPOINT ["dotnet", "KOAFiloServis.Web.dll"]
        """;

    private static string GetDockerComposeContent() => """
        version: '3.9'
        services:
          KOAFiloServis-web:
            build: .
            container_name: KOAFiloServis-web
            restart: unless-stopped
            ports:
              - "8080:8080"
            env_file:
              - .env
            volumes:
              - KOAFiloServis_uploads:/app/wwwroot/uploads
              - KOAFiloServis_logs:/app/logs
            depends_on:
              - postgres

          postgres:
            image: postgres:16
            container_name: KOAFiloServis-postgres
            restart: unless-stopped
            environment:
              POSTGRES_DB: KOAFiloServisDb
              POSTGRES_USER: postgres
              POSTGRES_PASSWORD: postgres
            ports:
              - "5432:5432"
            volumes:
              - KOAFiloServis_pgdata:/var/lib/postgresql/data

        volumes:
          KOAFiloServis_pgdata:
          KOAFiloServis_uploads:
          KOAFiloServis_logs:
        """;

    private static string GetEnvContent() => """
        ASPNETCORE_ENVIRONMENT=Production
        DatabaseProvider=PostgreSQL
        ConnectionStrings__DefaultConnection=Host=postgres;Port=5432;Database=KOAFiloServisDb;Username=postgres;Password=postgres
        PythonScraper__Enabled=false
        """;
}
