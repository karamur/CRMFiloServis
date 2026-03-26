using System.Net.Http.Json;
using CRMFiloServis.Shared.Entities;

namespace CRMFiloServis.Mobile.Services;

public interface IApiService
{
    Task<T?> GetAsync<T>(string endpoint);
    Task<TResponse?> PostAsync<TRequest, TResponse>(string endpoint, TRequest data);
    void SetBaseUrl(string url);
}

public class ApiService : IApiService
{
    private readonly IHttpClientFactory _httpClientFactory;
    private string _baseUrl;

    public ApiService(IHttpClientFactory httpClientFactory)
    {
        _httpClientFactory = httpClientFactory;
        _baseUrl = Preferences.Get("ApiBaseUrl", "http://192.168.1.100:5000");
    }

    public void SetBaseUrl(string url)
    {
        _baseUrl = url;
        Preferences.Set("ApiBaseUrl", url);
    }

    private HttpClient GetClient()
    {
        var client = _httpClientFactory.CreateClient();
        client.BaseAddress = new Uri(_baseUrl);
        client.Timeout = TimeSpan.FromSeconds(30);

        // Auth token varsa ekle
        var token = Preferences.Get("AuthToken", "");
        if (!string.IsNullOrEmpty(token))
        {
            client.DefaultRequestHeaders.Authorization = 
                new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }

        return client;
    }

    public async Task<T?> GetAsync<T>(string endpoint)
    {
        try
        {
            using var client = GetClient();
            return await client.GetFromJsonAsync<T>(endpoint);
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"API Error: {ex.Message}");
            return default;
        }
    }

    public async Task<TResponse?> PostAsync<TRequest, TResponse>(string endpoint, TRequest data)
    {
        try
        {
            using var client = GetClient();
            var response = await client.PostAsJsonAsync(endpoint, data);

            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadFromJsonAsync<TResponse>();
            }

            return default;
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"API Error: {ex.Message}");
            return default;
        }
    }
}
