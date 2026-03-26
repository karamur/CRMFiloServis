using Microsoft.AspNetCore.Mvc;
using CRMFiloServis.Shared.Entities;
using CRMFiloServis.Web.Services;

namespace CRMFiloServis.Web.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IKullaniciService _kullaniciService;

    public AuthController(IKullaniciService kullaniciService)
    {
        _kullaniciService = kullaniciService;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.KullaniciAdi) || string.IsNullOrWhiteSpace(request.Sifre))
        {
            return BadRequest(new { Basarili = false, Mesaj = "Kullanici adi ve sifre gerekli!" });
        }

        var sonuc = await _kullaniciService.GirisYapAsync(request.KullaniciAdi, request.Sifre);

        if (sonuc.Basarili)
        {
            return Ok(new
            {
                Basarili = true,
                Kullanici = new
                {
                    sonuc.Kullanici!.Id,
                    sonuc.Kullanici.KullaniciAdi,
                    sonuc.Kullanici.AdSoyad,
                    sonuc.Kullanici.Email,
                    sonuc.Kullanici.Telefon,
                    sonuc.Kullanici.SonGirisTarihi,
                    Rol = new
                    {
                        sonuc.Kullanici.Rol?.Id,
                        sonuc.Kullanici.Rol?.RolAdi,
                        sonuc.Kullanici.Rol?.Aciklama
                    }
                },
                Token = GenerateSimpleToken(sonuc.Kullanici.Id)
            });
        }

        return Unauthorized(new { Basarili = false, Mesaj = sonuc.Mesaj });
    }

    [HttpPost("logout")]
    public async Task<IActionResult> Logout()
    {
        await _kullaniciService.CikisYapAsync();
        return Ok(new { Basarili = true });
    }

    private string GenerateSimpleToken(int userId)
    {
        // Basit token - production'da JWT kullanilmali
        var timestamp = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
        return Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes($"{userId}:{timestamp}"));
    }
}

public class LoginRequest
{
    public string KullaniciAdi { get; set; } = "";
    public string Sifre { get; set; } = "";
}
