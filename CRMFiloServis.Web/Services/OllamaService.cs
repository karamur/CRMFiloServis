using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace CRMFiloServis.Web.Services;

public interface IOllamaService
{
    Task<string> RaporYorumlaAsync(string prompt);
    Task<bool> BaglantiKontrolAsync();
    string ModelAdi { get; }
}

public class OllamaService : IOllamaService
{
    private readonly HttpClient _httpClient;
    private readonly IConfiguration _configuration;
    private readonly ILogger<OllamaService> _logger;
    private readonly string _model;
    private readonly string _baseUrl;

    public string ModelAdi => _model;

    public OllamaService(
        IHttpClientFactory httpClientFactory,
        IConfiguration configuration,
        ILogger<OllamaService> logger)
    {
        _httpClient = httpClientFactory.CreateClient("Ollama");
        _configuration = configuration;
        _logger = logger;
        _baseUrl = configuration["Ollama:BaseUrl"] ?? "http://localhost:11434";
        _model = configuration["Ollama:Model"] ?? "llama3.2";
        _httpClient.BaseAddress = new Uri(_baseUrl);
        _httpClient.Timeout = TimeSpan.FromMinutes(3);
    }

    public async Task<bool> BaglantiKontrolAsync()
    {
        try
        {
            var response = await _httpClient.GetAsync("/api/tags");
            return response.IsSuccessStatusCode;
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Ollama bağlantı kontrolü başarısız: {BaseUrl}", _baseUrl);
            return false;
        }
    }

    public async Task<string> RaporYorumlaAsync(string prompt)
    {
        try
        {
            var sistemPrompt = @"Sen bir Türk mali müşavir ve bütçe analistisin. 
Kullanıcının bütçe/harcama verilerini analiz edip Türkçe rapor yazıyorsun.
Kısa, öz ve aksiyona yönelik yorumlar yap. Madde işaretleri kullan.
Emoji kullanma. Tutarları TL olarak göster. 
Önerilerin somut ve uygulanabilir olsun.";

            var request = new OllamaGenerateRequest
            {
                Model = _model,
                Prompt = prompt,
                System = sistemPrompt,
                Stream = false,
                Options = new OllamaOptions
                {
                    Temperature = 0.3,
                    TopP = 0.9,
                    NumPredict = 1024
                }
            };

            var json = JsonSerializer.Serialize(request, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
                DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
            });

            var content = new StringContent(json, Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync("/api/generate", content);

            if (!response.IsSuccessStatusCode)
            {
                var errorBody = await response.Content.ReadAsStringAsync();
                _logger.LogError("Ollama API hatası: {Status} - {Body}", response.StatusCode, errorBody);
                return $"AI analiz yapılamadı. Ollama yanıt kodu: {response.StatusCode}";
            }

            var responseBody = await response.Content.ReadAsStringAsync();
            var result = JsonSerializer.Deserialize<OllamaGenerateResponse>(responseBody, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            });

            return result?.Response?.Trim() ?? "AI yanıt alınamadı.";
        }
        catch (TaskCanceledException)
        {
            return "AI analiz zaman aşımına uğradı. Ollama sunucusunun çalıştığından emin olun.";
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "Ollama bağlantı hatası");
            return $"Ollama sunucusuna bağlanılamadı ({_baseUrl}). Lütfen Ollama'nın çalıştığından emin olun.";
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Ollama rapor yorumlama hatası");
            return $"AI analiz hatası: {ex.Message}";
        }
    }
}

// Ollama API Request/Response modelleri
public class OllamaGenerateRequest
{
    [JsonPropertyName("model")]
    public string Model { get; set; } = "";

    [JsonPropertyName("prompt")]
    public string Prompt { get; set; } = "";

    [JsonPropertyName("system")]
    public string? System { get; set; }

    [JsonPropertyName("stream")]
    public bool Stream { get; set; }

    [JsonPropertyName("options")]
    public OllamaOptions? Options { get; set; }
}

public class OllamaOptions
{
    [JsonPropertyName("temperature")]
    public double Temperature { get; set; } = 0.3;

    [JsonPropertyName("top_p")]
    public double TopP { get; set; } = 0.9;

    [JsonPropertyName("num_predict")]
    public int NumPredict { get; set; } = 1024;
}

public class OllamaGenerateResponse
{
    [JsonPropertyName("model")]
    public string? Model { get; set; }

    [JsonPropertyName("response")]
    public string? Response { get; set; }

    [JsonPropertyName("done")]
    public bool Done { get; set; }

    [JsonPropertyName("total_duration")]
    public long? TotalDuration { get; set; }
}
