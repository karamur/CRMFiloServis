namespace KOAFiloServis.Installer;

partial class MainForm
{
    private System.ComponentModel.IContainer components = null;

    protected override void Dispose(bool disposing)
    {
        if (disposing && (components != null))
        {
            components.Dispose();
        }
        base.Dispose(disposing);
    }

    private void InitializeComponent()
    {
        this.Text = "KOA Filo Servis - Yedekleme & Kurulum";
        this.Size = new System.Drawing.Size(750, 720);
        this.StartPosition = FormStartPosition.CenterScreen;
        this.FormBorderStyle = FormBorderStyle.FixedDialog;
        this.MaximizeBox = false;

        // Başlık
        var lblBaslik = new Label
        {
            Text = "KOA Filo Servis - Yedekleme & Kurulum",
            Font = new Font("Segoe UI", 16, FontStyle.Bold),
            Location = new Point(20, 15),
            AutoSize = true,
            ForeColor = Color.FromArgb(0, 100, 180)
        };
        this.Controls.Add(lblBaslik);

        // Tab Control
        tabControl = new TabControl
        {
            Location = new Point(20, 55),
            Size = new Size(700, 560)
        };
        this.Controls.Add(tabControl);

        // ========== YEDEK AL SEKMESİ ==========
        tabYedekAl = new TabPage
        {
            Text = "📦 Yedek Al",
            Padding = new Padding(10)
        };
        tabControl.TabPages.Add(tabYedekAl);

        CreateYedekAlTab();

        // ========== YEDEK YÜKLE SEKMESİ ==========
        tabYedekYukle = new TabPage
        {
            Text = "📥 Yedek Yükle",
            Padding = new Padding(10)
        };
        tabControl.TabPages.Add(tabYedekYukle);

        CreateYedekYukleTab();

        // ========== KURULUM SEKMESİ ==========
        tabKurulum = new TabPage
        {
            Text = "⚙️ Kurulum",
            Padding = new Padding(10)
        };
        tabControl.TabPages.Add(tabKurulum);

        CreateKurulumTab();

        // Makine Kodu Grubu (altta)
        var grpMakineKodu = new GroupBox
        {
            Text = "Lisans için Makine Kodu",
            Location = new Point(20, 620),
            Size = new Size(700, 55)
        };
        this.Controls.Add(grpMakineKodu);

        txtMakineKodu = new TextBox
        {
            Location = new Point(20, 22),
            Size = new Size(500, 23),
            ReadOnly = true,
            Font = new Font("Consolas", 9)
        };
        grpMakineKodu.Controls.Add(txtMakineKodu);

        var btnMakineKoduKopyala = new Button
        {
            Text = "📋 Kopyala",
            Location = new Point(540, 20),
            Size = new Size(140, 28)
        };
        btnMakineKoduKopyala.Click += btnMakineKoduKopyala_Click;
        grpMakineKodu.Controls.Add(btnMakineKoduKopyala);
    }

    private void CreateYedekAlTab()
    {
        // PostgreSQL Bağlantı Ayarları
        var grpBaglanti = new GroupBox
        {
            Text = "PostgreSQL Bağlantı Ayarları",
            Location = new Point(10, 10),
            Size = new Size(660, 150)
        };
        tabYedekAl.Controls.Add(grpBaglanti);

        var lblHost = new Label { Text = "Sunucu:", Location = new Point(20, 30), AutoSize = true };
        txtYedekHost = new TextBox { Location = new Point(120, 27), Size = new Size(200, 23), Text = "localhost" };
        grpBaglanti.Controls.Add(lblHost);
        grpBaglanti.Controls.Add(txtYedekHost);

        var lblPort = new Label { Text = "Port:", Location = new Point(340, 30), AutoSize = true };
        txtYedekPort = new TextBox { Location = new Point(400, 27), Size = new Size(80, 23), Text = "5432" };
        grpBaglanti.Controls.Add(lblPort);
        grpBaglanti.Controls.Add(txtYedekPort);

        var lblDatabase = new Label { Text = "Veritabanı:", Location = new Point(20, 65), AutoSize = true };
        txtYedekDatabase = new TextBox { Location = new Point(120, 62), Size = new Size(200, 23), Text = "DestekCRMServisBlazorDb" };
        grpBaglanti.Controls.Add(lblDatabase);
        grpBaglanti.Controls.Add(txtYedekDatabase);

        var lblUser = new Label { Text = "Kullanıcı:", Location = new Point(20, 100), AutoSize = true };
        txtYedekUser = new TextBox { Location = new Point(120, 97), Size = new Size(150, 23), Text = "postgres" };
        grpBaglanti.Controls.Add(lblUser);
        grpBaglanti.Controls.Add(txtYedekUser);

        var lblPassword = new Label { Text = "Şifre:", Location = new Point(290, 100), AutoSize = true };
        txtYedekPassword = new TextBox { Location = new Point(350, 97), Size = new Size(150, 23), PasswordChar = '●' };
        grpBaglanti.Controls.Add(lblPassword);
        grpBaglanti.Controls.Add(txtYedekPassword);

        btnYedekBaglantiTest = new Button
        {
            Text = "🔌 Bağlantı Test",
            Location = new Point(520, 95),
            Size = new Size(120, 28)
        };
        btnYedekBaglantiTest.Click += btnYedekBaglantiTest_Click;
        grpBaglanti.Controls.Add(btnYedekBaglantiTest);

        // Yedek Konumu
        var grpYedekKonum = new GroupBox
        {
            Text = "Yedek Kayıt Konumu",
            Location = new Point(10, 170),
            Size = new Size(660, 70)
        };
        tabYedekAl.Controls.Add(grpYedekKonum);

        txtYedekKayitYolu = new TextBox
        {
            Location = new Point(20, 28),
            Size = new Size(500, 23),
            ReadOnly = true
        };
        grpYedekKonum.Controls.Add(txtYedekKayitYolu);

        btnYedekKonumSec = new Button
        {
            Text = "📁 Konum Seç...",
            Location = new Point(530, 26),
            Size = new Size(110, 28)
        };
        btnYedekKonumSec.Click += btnYedekKonumSec_Click;
        grpYedekKonum.Controls.Add(btnYedekKonumSec);

        // Progress
        progressYedekAl = new ProgressBar
        {
            Location = new Point(10, 260),
            Size = new Size(540, 25)
        };
        tabYedekAl.Controls.Add(progressYedekAl);

        lblYedekAlDurum = new Label
        {
            Text = "Hazır - Bağlantı bilgilerini girin ve yedek alın.",
            Location = new Point(10, 295),
            Size = new Size(540, 40),
            ForeColor = Color.DarkBlue
        };
        tabYedekAl.Controls.Add(lblYedekAlDurum);

        btnYedekAl = new Button
        {
            Text = "💾 Yedek Al",
            Location = new Point(560, 255),
            Size = new Size(110, 45),
            Font = new Font("Segoe UI", 10, FontStyle.Bold),
            BackColor = Color.FromArgb(0, 120, 215),
            ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat
        };
        btnYedekAl.Click += btnYedekAl_Click;
        tabYedekAl.Controls.Add(btnYedekAl);

        // Yedek Geçmişi
        var grpYedekGecmis = new GroupBox
        {
            Text = "Son Yedekler",
            Location = new Point(10, 340),
            Size = new Size(660, 170)
        };
        tabYedekAl.Controls.Add(grpYedekGecmis);

        lstYedekGecmis = new ListBox
        {
            Location = new Point(10, 22),
            Size = new Size(640, 135)
        };
        grpYedekGecmis.Controls.Add(lstYedekGecmis);
    }

    private void CreateYedekYukleTab()
    {
        // PostgreSQL Bağlantı Ayarları
        var grpBaglanti = new GroupBox
        {
            Text = "Hedef PostgreSQL Bağlantı Ayarları",
            Location = new Point(10, 10),
            Size = new Size(660, 150)
        };
        tabYedekYukle.Controls.Add(grpBaglanti);

        var lblHost = new Label { Text = "Sunucu:", Location = new Point(20, 30), AutoSize = true };
        txtYukleHost = new TextBox { Location = new Point(120, 27), Size = new Size(200, 23), Text = "localhost" };
        grpBaglanti.Controls.Add(lblHost);
        grpBaglanti.Controls.Add(txtYukleHost);

        var lblPort = new Label { Text = "Port:", Location = new Point(340, 30), AutoSize = true };
        txtYuklePort = new TextBox { Location = new Point(400, 27), Size = new Size(80, 23), Text = "5432" };
        grpBaglanti.Controls.Add(lblPort);
        grpBaglanti.Controls.Add(txtYuklePort);

        var lblDatabase = new Label { Text = "Veritabanı:", Location = new Point(20, 65), AutoSize = true };
        txtYukleDatabase = new TextBox { Location = new Point(120, 62), Size = new Size(200, 23), Text = "DestekCRMServisBlazorDb" };
        grpBaglanti.Controls.Add(lblDatabase);
        grpBaglanti.Controls.Add(txtYukleDatabase);

        var lblUser = new Label { Text = "Kullanıcı:", Location = new Point(20, 100), AutoSize = true };
        txtYukleUser = new TextBox { Location = new Point(120, 97), Size = new Size(150, 23), Text = "postgres" };
        grpBaglanti.Controls.Add(lblUser);
        grpBaglanti.Controls.Add(txtYukleUser);

        var lblPassword = new Label { Text = "Şifre:", Location = new Point(290, 100), AutoSize = true };
        txtYuklePassword = new TextBox { Location = new Point(350, 97), Size = new Size(150, 23), PasswordChar = '●' };
        grpBaglanti.Controls.Add(lblPassword);
        grpBaglanti.Controls.Add(txtYuklePassword);

        btnYukleBaglantiTest = new Button
        {
            Text = "🔌 Bağlantı Test",
            Location = new Point(520, 95),
            Size = new Size(120, 28)
        };
        btnYukleBaglantiTest.Click += btnYukleBaglantiTest_Click;
        grpBaglanti.Controls.Add(btnYukleBaglantiTest);

        // Yedek Dosya Seçimi
        var grpYedekDosya = new GroupBox
        {
            Text = "Yüklenecek Yedek Dosyası",
            Location = new Point(10, 170),
            Size = new Size(660, 100)
        };
        tabYedekYukle.Controls.Add(grpYedekDosya);

        txtYukleDosyaYolu = new TextBox
        {
            Location = new Point(20, 28),
            Size = new Size(500, 23),
            ReadOnly = true
        };
        grpYedekDosya.Controls.Add(txtYukleDosyaYolu);

        btnYukleDosyaSec = new Button
        {
            Text = "📁 Dosya Seç...",
            Location = new Point(530, 26),
            Size = new Size(110, 28)
        };
        btnYukleDosyaSec.Click += btnYukleDosyaSec_Click;
        grpYedekDosya.Controls.Add(btnYukleDosyaSec);

        lblYukleDosyaBilgi = new Label
        {
            Text = "ZIP veya SQL dosyası seçin",
            Location = new Point(20, 60),
            Size = new Size(500, 30),
            ForeColor = Color.Gray
        };
        grpYedekDosya.Controls.Add(lblYukleDosyaBilgi);

        // Seçenekler
        var grpSecenekler = new GroupBox
        {
            Text = "Yükleme Seçenekleri",
            Location = new Point(10, 280),
            Size = new Size(660, 60)
        };
        tabYedekYukle.Controls.Add(grpSecenekler);

        chkYukleDbOlustur = new CheckBox
        {
            Text = "Veritabanı yoksa oluştur",
            Location = new Point(20, 25),
            AutoSize = true,
            Checked = true
        };
        grpSecenekler.Controls.Add(chkYukleDbOlustur);

        chkYukleTemizle = new CheckBox
        {
            Text = "Önce mevcut verileri temizle",
            Location = new Point(250, 25),
            AutoSize = true,
            Checked = false
        };
        grpSecenekler.Controls.Add(chkYukleTemizle);

        // Progress
        progressYedekYukle = new ProgressBar
        {
            Location = new Point(10, 360),
            Size = new Size(540, 25)
        };
        tabYedekYukle.Controls.Add(progressYedekYukle);

        lblYedekYukleDurum = new Label
        {
            Text = "Hazır - Yedek dosyasını seçin ve yükleyin.",
            Location = new Point(10, 395),
            Size = new Size(540, 60),
            ForeColor = Color.DarkBlue
        };
        tabYedekYukle.Controls.Add(lblYedekYukleDurum);

        btnYedekYukle = new Button
        {
            Text = "📤 Yedek Yükle",
            Location = new Point(560, 355),
            Size = new Size(110, 45),
            Font = new Font("Segoe UI", 10, FontStyle.Bold),
            BackColor = Color.FromArgb(0, 150, 80),
            ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat
        };
        btnYedekYukle.Click += btnYedekYukle_Click;
        tabYedekYukle.Controls.Add(btnYedekYukle);

        // Uyarı
        var lblUyari = new Label
        {
            Text = "⚠️ DİKKAT: Yedek yükleme işlemi mevcut veritabanı verilerini değiştirebilir!",
            Location = new Point(10, 470),
            Size = new Size(660, 30),
            ForeColor = Color.DarkRed,
            Font = new Font("Segoe UI", 9, FontStyle.Bold)
        };
        tabYedekYukle.Controls.Add(lblUyari);
    }

    private void CreateKurulumTab()
    {
        // Kurulum Tipi Grubu
        var grpTip = new GroupBox
        {
            Text = "1. Kurulum Tipi",
            Location = new Point(10, 10),
            Size = new Size(660, 60)
        };
        tabKurulum.Controls.Add(grpTip);

        rbNormal = new RadioButton
        {
            Text = "Normal Kurulum (IIS / Windows Server)",
            Location = new Point(20, 25),
            AutoSize = true,
            Checked = true
        };
        rbNormal.CheckedChanged += rbNormal_CheckedChanged;
        grpTip.Controls.Add(rbNormal);

        rbDocker = new RadioButton
        {
            Text = "Docker Kurulum",
            Location = new Point(350, 25),
            AutoSize = true
        };
        rbDocker.CheckedChanged += rbDocker_CheckedChanged;
        grpTip.Controls.Add(rbDocker);

        // Kurulum Modu Grubu
        var grpMod = new GroupBox
        {
            Text = "2. Kurulum Modu",
            Location = new Point(10, 80),
            Size = new Size(660, 60)
        };
        tabKurulum.Controls.Add(grpMod);

        rbYeniKurulum = new RadioButton
        {
            Text = "Sıfır Kurulum (Yeni veritabanı)",
            Location = new Point(20, 25),
            AutoSize = true,
            Checked = true
        };
        rbYeniKurulum.CheckedChanged += rbYeniKurulum_CheckedChanged;
        grpMod.Controls.Add(rbYeniKurulum);

        rbMevcutYedek = new RadioButton
        {
            Text = "Mevcut Yedek İle Kurulum",
            Location = new Point(350, 25),
            AutoSize = true
        };
        rbMevcutYedek.CheckedChanged += rbMevcutYedek_CheckedChanged;
        grpMod.Controls.Add(rbMevcutYedek);

        // Yedek Grubu
        grpYedek = new GroupBox
        {
            Text = "3. Veritabanı Yedeği",
            Location = new Point(10, 150),
            Size = new Size(660, 60),
            Enabled = false
        };
        tabKurulum.Controls.Add(grpYedek);

        lblYedekDurum = new Label
        {
            Text = "Sıfır veritabanı ile kurulum yapılacak.",
            Location = new Point(20, 25),
            AutoSize = true
        };
        grpYedek.Controls.Add(lblYedekDurum);

        var btnYedekSecKurulum = new Button
        {
            Text = "Yedek Dosyası Seç...",
            Location = new Point(500, 22),
            Size = new Size(140, 28)
        };
        btnYedekSecKurulum.Click += btnYedekSec_Click;
        grpYedek.Controls.Add(btnYedekSecKurulum);

        // Paket Grubu
        grpPaket = new GroupBox
        {
            Text = "4. Kurulum Paketi",
            Location = new Point(10, 220),
            Size = new Size(660, 60)
        };
        tabKurulum.Controls.Add(grpPaket);

        lblPaketDurum = new Label
        {
            Text = "Kurulum paketi seçilmedi.",
            Location = new Point(20, 25),
            AutoSize = true
        };
        grpPaket.Controls.Add(lblPaketDurum);

        btnPaketSec = new Button
        {
            Text = "Paket Seç...",
            Location = new Point(500, 22),
            Size = new Size(140, 28)
        };
        btnPaketSec.Click += btnPaketSec_Click;
        grpPaket.Controls.Add(btnPaketSec);

        // Hedef Dizin Grubu
        var grpDizin = new GroupBox
        {
            Text = "5. Hedef Dizin",
            Location = new Point(10, 290),
            Size = new Size(660, 60)
        };
        tabKurulum.Controls.Add(grpDizin);

        txtHedefDizin = new TextBox
        {
            Text = @"C:\KOAFiloServis",
            Location = new Point(20, 25),
            Size = new Size(450, 23),
            ReadOnly = true
        };
        grpDizin.Controls.Add(txtHedefDizin);

        var btnDizinSec = new Button
        {
            Text = "Dizin Seç...",
            Location = new Point(500, 22),
            Size = new Size(140, 28)
        };
        btnDizinSec.Click += btnDizinSec_Click;
        grpDizin.Controls.Add(btnDizinSec);

        // Normal Ayarlar Paneli
        pnlNormalAyarlari = new Panel
        {
            Location = new Point(10, 360),
            Size = new Size(660, 40),
            Visible = true
        };
        tabKurulum.Controls.Add(pnlNormalAyarlari);

        var lblNormalInfo = new Label
        {
            Text = "ℹ️ Not: IIS ve .NET 10 Hosting Bundle kurulu olmalıdır.",
            Location = new Point(10, 12),
            AutoSize = true,
            ForeColor = Color.DarkBlue
        };
        pnlNormalAyarlari.Controls.Add(lblNormalInfo);

        // Docker Ayarlar Paneli
        pnlDockerAyarlari = new Panel
        {
            Location = new Point(10, 360),
            Size = new Size(660, 40),
            Visible = false
        };
        tabKurulum.Controls.Add(pnlDockerAyarlari);

        var lblDockerInfo = new Label
        {
            Text = "🐳 Not: Docker Desktop kurulu olmalıdır. Compose dosyaları oluşturulacak.",
            Location = new Point(10, 12),
            AutoSize = true,
            ForeColor = Color.DarkGreen
        };
        pnlDockerAyarlari.Controls.Add(lblDockerInfo);

        // Progress ve Durum
        progressBar = new ProgressBar
        {
            Location = new Point(10, 410),
            Size = new Size(540, 25),
            Visible = false
        };
        tabKurulum.Controls.Add(progressBar);

        lblDurum = new Label
        {
            Text = "Hazır",
            Location = new Point(10, 440),
            AutoSize = true,
            Visible = false
        };
        tabKurulum.Controls.Add(lblDurum);

        // Başlat Butonu
        btnKurulumBaslat = new Button
        {
            Text = "🚀 Kurulumu Başlat",
            Location = new Point(480, 405),
            Size = new Size(190, 45),
            Font = new Font("Segoe UI", 10, FontStyle.Bold),
            BackColor = Color.ForestGreen,
            ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat
        };
        btnKurulumBaslat.Click += btnKurulumBaslat_Click;
        tabKurulum.Controls.Add(btnKurulumBaslat);
    }

    // Tab Control
    private TabControl tabControl;
    private TabPage tabYedekAl;
    private TabPage tabYedekYukle;
    private TabPage tabKurulum;

    // Yedek Al Tab
    private TextBox txtYedekHost;
    private TextBox txtYedekPort;
    private TextBox txtYedekDatabase;
    private TextBox txtYedekUser;
    private TextBox txtYedekPassword;
    private Button btnYedekBaglantiTest;
    private TextBox txtYedekKayitYolu;
    private Button btnYedekKonumSec;
    private ProgressBar progressYedekAl;
    private Label lblYedekAlDurum;
    private Button btnYedekAl;
    private ListBox lstYedekGecmis;

    // Yedek Yükle Tab
    private TextBox txtYukleHost;
    private TextBox txtYuklePort;
    private TextBox txtYukleDatabase;
    private TextBox txtYukleUser;
    private TextBox txtYuklePassword;
    private Button btnYukleBaglantiTest;
    private TextBox txtYukleDosyaYolu;
    private Button btnYukleDosyaSec;
    private Label lblYukleDosyaBilgi;
    private CheckBox chkYukleDbOlustur;
    private CheckBox chkYukleTemizle;
    private ProgressBar progressYedekYukle;
    private Label lblYedekYukleDurum;
    private Button btnYedekYukle;

    // Kurulum Tab
    private RadioButton rbNormal;
    private RadioButton rbDocker;
    private RadioButton rbYeniKurulum;
    private RadioButton rbMevcutYedek;
    private GroupBox grpYedek;
    private GroupBox grpPaket;
    private Label lblYedekDurum;
    private Label lblPaketDurum;
    private TextBox txtHedefDizin;
    private TextBox txtMakineKodu;
    private Panel pnlNormalAyarlari;
    private Panel pnlDockerAyarlari;
    private ProgressBar progressBar;
    private Label lblDurum;
    private Button btnKurulumBaslat;
    private Button btnPaketSec;
}
