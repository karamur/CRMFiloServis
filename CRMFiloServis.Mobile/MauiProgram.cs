using Microsoft.Extensions.Logging;
using CRMFiloServis.Mobile.Services;

namespace CRMFiloServis.Mobile;

public static class MauiProgram
{
    public static MauiApp CreateMauiApp()
    {
        var builder = MauiApp.CreateBuilder();
        builder
            .UseMauiApp<App>()
            .ConfigureFonts(fonts =>
            {
                fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
            });

        builder.Services.AddMauiBlazorWebView();

#if DEBUG
        builder.Services.AddBlazorWebViewDeveloperTools();
        builder.Logging.AddDebug();
#endif

        // API servisleri
        builder.Services.AddSingleton<IApiService, ApiService>();
        builder.Services.AddSingleton<IAuthService, AuthService>();
        builder.Services.AddSingleton<IMobileDataService, MobileDataService>();

        // HttpClient - API baglantisi icin
        builder.Services.AddHttpClient("CRMApi", client =>
        {
            // Varsayilan API adresi - Preferences'tan okunacak
            var baseUrl = Preferences.Get("ApiBaseUrl", "http://192.168.1.100:5000");
            client.BaseAddress = new Uri(baseUrl);
            client.Timeout = TimeSpan.FromSeconds(30);
        });

        return builder.Build();
    }
}
