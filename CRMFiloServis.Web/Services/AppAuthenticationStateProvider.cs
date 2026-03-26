using System.Security.Claims;
using Microsoft.AspNetCore.Components.Authorization;
using CRMFiloServis.Shared.Entities;

namespace CRMFiloServis.Web.Services;

/// <summary>
/// Tum platformlarda (Web, Desktop, Linux, Android, iOS) guvenli calisacak Authentication Provider
/// Static state kullanarak circuit/sayfa degisikliklerinde oturum korur
/// </summary>
public class AppAuthenticationStateProvider : AuthenticationStateProvider
{
    private static ClaimsPrincipal _currentUser = new ClaimsPrincipal(new ClaimsIdentity());
    private static Kullanici? _aktifKullanici;
    private static readonly object _lock = new object();

    public override Task<AuthenticationState> GetAuthenticationStateAsync()
    {
        lock (_lock)
        {
            return Task.FromResult(new AuthenticationState(_currentUser));
        }
    }

    /// <summary>
    /// Kullaniciyi oturum acar - tum platformlarda guvenli
    /// </summary>
    public void GirisYap(Kullanici kullanici)
    {
        lock (_lock)
        {
            _aktifKullanici = kullanici;

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, kullanici.Id.ToString()),
                new Claim(ClaimTypes.Name, kullanici.KullaniciAdi),
                new Claim("AdSoyad", kullanici.AdSoyad),
                new Claim(ClaimTypes.Role, kullanici.Rol?.RolAdi ?? "Kullanici"),
            };

            if (!string.IsNullOrEmpty(kullanici.Email))
                claims.Add(new Claim(ClaimTypes.Email, kullanici.Email));

            var identity = new ClaimsIdentity(claims, "CRMFiloServisAuth");
            _currentUser = new ClaimsPrincipal(identity);
        }

        NotifyAuthenticationStateChanged(GetAuthenticationStateAsync());
    }

    /// <summary>
    /// Kullaniciyi oturumdan cikarir - tum platformlarda guvenli
    /// </summary>
    public void CikisYap()
    {
        lock (_lock)
        {
            _aktifKullanici = null;
            _currentUser = new ClaimsPrincipal(new ClaimsIdentity());
        }

        NotifyAuthenticationStateChanged(GetAuthenticationStateAsync());
    }

    /// <summary>
    /// Aktif kullaniciyi dondurur
    /// </summary>
    public Kullanici? GetAktifKullanici()
    {
        lock (_lock)
        {
            return _aktifKullanici;
        }
    }

    /// <summary>
    /// Kullanici giris yapmis mi kontrol eder
    /// </summary>
    public bool IsAuthenticated
    {
        get
        {
            lock (_lock)
            {
                return _aktifKullanici != null;
            }
        }
    }
}
