using Blazored.LocalStorage;
using CRMFiloServis.Mobile.Services;
using Microsoft.Extensions.Logging;

namespace CRMFiloServis.Mobile;

public static class MauiProgram
{
	// API Base URL - appsettings.json'dan okunacak şekilde yapılandırılabilir
	private const string ApiBaseUrl = "https://localhost:5001/"; // Geliştirme ortamı

	public static MauiApp CreateMauiApp()
	{
		var builder = MauiApp.CreateBuilder();
		builder
			.UseMauiApp<App>()
			.ConfigureFonts(fonts =>
			{
				fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
				fonts.AddFont("OpenSans-Semibold.ttf", "OpenSansSemibold");
			});

		builder.Services.AddMauiBlazorWebView();

		// Blazored LocalStorage
		builder.Services.AddBlazoredLocalStorage();

		// HttpClient yapılandırması
		builder.Services.AddHttpClient<IApiService, ApiService>(client =>
		{
			client.BaseAddress = new Uri(ApiBaseUrl);
			client.Timeout = TimeSpan.FromSeconds(30);
			client.DefaultRequestHeaders.Add("Accept", "application/json");
			client.DefaultRequestHeaders.Add("X-Client-Type", "Mobile");
			client.DefaultRequestHeaders.Add("X-Client-Version", "1.0.0");
		});

		// Servis kayıtları
		builder.Services.AddSingleton<IKonumService, KonumService>();

#if DEBUG
		builder.Services.AddBlazorWebViewDeveloperTools();
		builder.Logging.AddDebug();
#endif

		return builder.Build();
	}
}
