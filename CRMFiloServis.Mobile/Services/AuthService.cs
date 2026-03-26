using CRMFiloServis.Shared.Entities;

namespace CRMFiloServis.Mobile.Services;

public interface IAuthService
{
    bool IsAuthenticated { get; }
    Kullanici? CurrentUser { get; }
    Task<LoginResult> LoginAsync(string username, string password);
    void Logout();
}

public class AuthService : IAuthService
{
    private readonly IApiService _apiService;
    private Kullanici? _currentUser;

    public AuthService(IApiService apiService)
    {
        _apiService = apiService;
        LoadStoredUser();
    }

    public bool IsAuthenticated => _currentUser != null;
    public Kullanici? CurrentUser => _currentUser;

    private void LoadStoredUser()
    {
        try
        {
            var userId = Preferences.Get("UserId", 0);
            if (userId > 0)
            {
                // Basit kullanici bilgisi yukle
                _currentUser = new Kullanici
                {
                    Id = userId,
                    KullaniciAdi = Preferences.Get("UserName", ""),
                    AdSoyad = Preferences.Get("UserFullName", ""),
                    Email = Preferences.Get("UserEmail", ""),
                    Telefon = Preferences.Get("UserPhone", ""),
                    Rol = new Rol
                    {
                        RolAdi = Preferences.Get("UserRole", "Kullanici")
                    }
                };
            }
        }
        catch { }
    }

    public async Task<LoginResult> LoginAsync(string username, string password)
    {
        try
        {
            // API'ye login istegi gonder
            var response = await _apiService.PostAsync<LoginRequest, LoginResponse>(
                "/api/auth/login",
                new LoginRequest { KullaniciAdi = username, Sifre = password }
            );

            if (response != null && response.Basarili && response.Kullanici != null)
            {
                _currentUser = response.Kullanici;
                SaveUser(_currentUser);

                if (!string.IsNullOrEmpty(response.Token))
                {
                    Preferences.Set("AuthToken", response.Token);
                }

                return new LoginResult { Success = true };
            }

            // Demo/Offline mod - test icin
            if (await TryDemoLogin(username, password))
            {
                return new LoginResult { Success = true };
            }

            return new LoginResult 
            { 
                Success = false, 
                Message = response?.Mesaj ?? "Giris basarisiz!" 
            };
        }
        catch (Exception ex)
        {
            // Baglanti hatasi - demo mod dene
            if (await TryDemoLogin(username, password))
            {
                return new LoginResult { Success = true };
            }

            return new LoginResult 
            { 
                Success = false, 
                Message = "Sunucuya baglanilamadi: " + ex.Message 
            };
        }
    }

    private async Task<bool> TryDemoLogin(string username, string password)
    {
        // Demo kullanicilar - offline test icin
        var demoUsers = new Dictionary<string, (string pass, string role, string name)>
        {
            { "admin", ("admin123", "Admin", "Sistem Yoneticisi") },
            { "muhasebe", ("muhasebe123", "Muhasebeci", "Muhasebe Sorumlusu") },
            { "operasyon", ("operasyon123", "Operasyon", "Operasyon Muduru") },
            { "satis", ("satis123", "SatisTemsilcisi", "Satis Temsilcisi") },
            { "sofor", ("sofor123", "SoforRol", "Ahmet Yilmaz") },
            { "test", ("test123", "Admin", "Test Kullanici") }
        };

        if (demoUsers.TryGetValue(username.ToLower(), out var user) && user.pass == password)
        {
            _currentUser = new Kullanici
            {
                Id = 1,
                KullaniciAdi = username,
                AdSoyad = user.name,
                SonGirisTarihi = DateTime.Now,
                Rol = new Rol { RolAdi = user.role }
            };
            SaveUser(_currentUser);
            return true;
        }

        return false;
    }

    private void SaveUser(Kullanici user)
    {
        Preferences.Set("UserId", user.Id);
        Preferences.Set("UserName", user.KullaniciAdi);
        Preferences.Set("UserFullName", user.AdSoyad);
        Preferences.Set("UserEmail", user.Email ?? "");
        Preferences.Set("UserPhone", user.Telefon ?? "");
        Preferences.Set("UserRole", user.Rol?.RolAdi ?? "Kullanici");
    }

    public void Logout()
    {
        _currentUser = null;
        Preferences.Remove("UserId");
        Preferences.Remove("UserName");
        Preferences.Remove("UserFullName");
        Preferences.Remove("UserEmail");
        Preferences.Remove("UserPhone");
        Preferences.Remove("UserRole");
        Preferences.Remove("AuthToken");
    }
}

public class LoginRequest
{
    public string KullaniciAdi { get; set; } = "";
    public string Sifre { get; set; } = "";
}

public class LoginResponse
{
    public bool Basarili { get; set; }
    public string? Mesaj { get; set; }
    public Kullanici? Kullanici { get; set; }
    public string? Token { get; set; }
}

public class LoginResult
{
    public bool Success { get; set; }
    public string? Message { get; set; }
}
