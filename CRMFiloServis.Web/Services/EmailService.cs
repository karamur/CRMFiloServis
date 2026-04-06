using System.Net;
using System.Net.Mail;

namespace CRMFiloServis.Web.Services;

/// <summary>
/// E-posta bildirim servisi
/// </summary>
public interface IEmailService
{
    Task<bool> SendEmailAsync(string to, string subject, string body, bool isHtml = true);
    Task<bool> SendEmailAsync(List<string> to, string subject, string body, bool isHtml = true);
    Task<bool> SendBelgeUyariEmailAsync(string to, List<BelgeUyariEmail> uyarilar);
    Task<bool> SendFaturaEmailAsync(string to, string faturaNo, decimal tutar, DateTime vadeTarihi);
}

public class EmailService : IEmailService
{
    private readonly IConfiguration _configuration;
    private readonly ILogger<EmailService> _logger;
    private readonly bool _enabled;
    private readonly string _smtpHost;
    private readonly int _smtpPort;
    private readonly string _smtpUser;
    private readonly string _smtpPassword;
    private readonly string _fromEmail;
    private readonly string _fromName;
    private readonly bool _enableSsl;

    public EmailService(IConfiguration configuration, ILogger<EmailService> logger)
    {
        _configuration = configuration;
        _logger = logger;

        _enabled = configuration.GetValue("Email:Enabled", false);
        _smtpHost = configuration["Email:SmtpHost"] ?? "smtp.gmail.com";
        _smtpPort = configuration.GetValue("Email:SmtpPort", 587);
        _smtpUser = configuration["Email:SmtpUser"] ?? "";
        _smtpPassword = configuration["Email:SmtpPassword"] ?? "";
        _fromEmail = configuration["Email:FromEmail"] ?? _smtpUser;
        _fromName = configuration["Email:FromName"] ?? "CRM Filo Servis";
        _enableSsl = configuration.GetValue("Email:EnableSsl", true);
    }

    public async Task<bool> SendEmailAsync(string to, string subject, string body, bool isHtml = true)
    {
        return await SendEmailAsync(new List<string> { to }, subject, body, isHtml);
    }

    public async Task<bool> SendEmailAsync(List<string> to, string subject, string body, bool isHtml = true)
    {
        if (!_enabled)
        {
            _logger.LogWarning("E-posta servisi devre dışı. Mesaj gönderilmedi: {Subject}", subject);
            return false;
        }

        if (string.IsNullOrEmpty(_smtpUser) || string.IsNullOrEmpty(_smtpPassword))
        {
            _logger.LogError("SMTP ayarları yapılandırılmamış");
            return false;
        }

        try
        {
            using var client = new SmtpClient(_smtpHost, _smtpPort)
            {
                Credentials = new NetworkCredential(_smtpUser, _smtpPassword),
                EnableSsl = _enableSsl
            };

            var message = new MailMessage
            {
                From = new MailAddress(_fromEmail, _fromName),
                Subject = subject,
                Body = body,
                IsBodyHtml = isHtml
            };

            foreach (var recipient in to.Where(r => !string.IsNullOrWhiteSpace(r)))
            {
                message.To.Add(recipient);
            }

            await client.SendMailAsync(message);

            _logger.LogInformation("E-posta gönderildi: {Subject} -> {To}", subject, string.Join(", ", to));
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "E-posta gönderilemedi: {Subject}", subject);
            return false;
        }
    }

    public async Task<bool> SendBelgeUyariEmailAsync(string to, List<BelgeUyariEmail> uyarilar)
    {
        if (!uyarilar.Any()) return true;

        var body = $@"
<!DOCTYPE html>
<html>
<head>
    <style>
        body {{ font-family: Arial, sans-serif; }}
        .container {{ max-width: 600px; margin: 0 auto; }}
        .header {{ background-color: #dc3545; color: white; padding: 20px; text-align: center; }}
        .content {{ padding: 20px; }}
        .warning {{ background-color: #fff3cd; border: 1px solid #ffc107; padding: 15px; margin: 10px 0; border-radius: 5px; }}
        .critical {{ background-color: #f8d7da; border: 1px solid #dc3545; padding: 15px; margin: 10px 0; border-radius: 5px; }}
        table {{ width: 100%; border-collapse: collapse; }}
        th, td {{ padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }}
        th {{ background-color: #f8f9fa; }}
        .footer {{ text-align: center; padding: 20px; color: #6c757d; font-size: 12px; }}
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h2>⚠️ Belge Uyarıları</h2>
        </div>
        <div class='content'>
            <p>Aşağıdaki belgelerin süresi dolmuş veya dolmak üzere:</p>
            <table>
                <thead>
                    <tr>
                        <th>Araç/Şoför</th>
                        <th>Belge</th>
                        <th>Bitiş Tarihi</th>
                        <th>Durum</th>
                    </tr>
                </thead>
                <tbody>
                    {string.Join("", uyarilar.Select(u => $@"
                    <tr class='{(u.GunKaldi <= 0 ? "critical" : "warning")}'>
                        <td>{u.SahipAdi}</td>
                        <td>{u.BelgeAdi}</td>
                        <td>{u.BitisTarihi:dd.MM.yyyy}</td>
                        <td>{(u.GunKaldi <= 0 ? "❌ SÜRESİ GEÇMİŞ" : $"⚠️ {u.GunKaldi} gün kaldı")}</td>
                    </tr>"))}
                </tbody>
            </table>
        </div>
        <div class='footer'>
            <p>Bu e-posta CRM Filo Servis sistemi tarafından otomatik olarak gönderilmiştir.</p>
            <p>© {DateTime.Now.Year} CRM Filo Servis</p>
        </div>
    </div>
</body>
</html>";

        return await SendEmailAsync(to, $"⚠️ {uyarilar.Count} Belge Uyarısı - CRM Filo Servis", body);
    }

    public async Task<bool> SendFaturaEmailAsync(string to, string faturaNo, decimal tutar, DateTime vadeTarihi)
    {
        var body = $@"
<!DOCTYPE html>
<html>
<head>
    <style>
        body {{ font-family: Arial, sans-serif; }}
        .container {{ max-width: 600px; margin: 0 auto; }}
        .header {{ background-color: #0d6efd; color: white; padding: 20px; text-align: center; }}
        .content {{ padding: 20px; }}
        .amount {{ font-size: 24px; font-weight: bold; color: #198754; text-align: center; padding: 20px; }}
        .details {{ background-color: #f8f9fa; padding: 15px; border-radius: 5px; }}
        .footer {{ text-align: center; padding: 20px; color: #6c757d; font-size: 12px; }}
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h2>📄 Fatura Bildirimi</h2>
        </div>
        <div class='content'>
            <div class='amount'>
                {tutar:N2} ₺
            </div>
            <div class='details'>
                <p><strong>Fatura No:</strong> {faturaNo}</p>
                <p><strong>Vade Tarihi:</strong> {vadeTarihi:dd.MM.yyyy}</p>
            </div>
            <p style='margin-top: 20px;'>Faturanız oluşturulmuştur. Detaylar için sisteme giriş yapabilirsiniz.</p>
        </div>
        <div class='footer'>
            <p>Bu e-posta CRM Filo Servis sistemi tarafından otomatik olarak gönderilmiştir.</p>
        </div>
    </div>
</body>
</html>";

        return await SendEmailAsync(to, $"Fatura: {faturaNo} - CRM Filo Servis", body);
    }
}

public class BelgeUyariEmail
{
    public string SahipAdi { get; set; } = "";
    public string BelgeAdi { get; set; } = "";
    public DateTime BitisTarihi { get; set; }
    public int GunKaldi { get; set; }
}
