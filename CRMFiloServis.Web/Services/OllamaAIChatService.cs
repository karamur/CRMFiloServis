using Microsoft.Extensions.AI;
using OllamaSharp;

namespace CRMFiloServis.Web.Services;

/// <summary>
/// Ollama ile interaktif chat servisi - Microsoft.Extensions.AI ve OllamaSharp kullanarak
/// </summary>
public interface IOllamaAIChatService
{
    Task<string> ChatAsync(string message, CancellationToken cancellationToken = default);
    IAsyncEnumerable<string> ChatStreamAsync(string message, CancellationToken cancellationToken = default);
    Task<string> ChatWithHistoryAsync(List<ChatMessage> history, string message, CancellationToken cancellationToken = default);
    IAsyncEnumerable<string> ChatWithHistoryStreamAsync(List<ChatMessage> history, string message, CancellationToken cancellationToken = default);
    Task<bool> IsAvailableAsync();
    Task<List<string>> GetAvailableModelsAsync();
    void ClearHistory();
    string CurrentModel { get; }
    void SetModel(string modelName);
}

public class OllamaAIChatService : IOllamaAIChatService
{
    private readonly IConfiguration _configuration;
    private readonly ILogger<OllamaAIChatService> _logger;
    private readonly List<ChatMessage> _chatHistory = new();
    private string _currentModel;
    private readonly string _baseUrl;

    public OllamaAIChatService(
        IConfiguration configuration,
        ILogger<OllamaAIChatService> logger)
    {
        _configuration = configuration;
        _logger = logger;
        _baseUrl = _configuration["Ollama:BaseUrl"] ?? "http://localhost:11434";
        _currentModel = _configuration["Ollama:Model"] ?? "llama3.2";
    }

    public string CurrentModel => _currentModel;

    public void SetModel(string modelName)
    {
        _currentModel = modelName;
        _logger.LogInformation("Ollama modeli değiştirildi: {Model}", modelName);
    }

    public void ClearHistory()
    {
        _chatHistory.Clear();
        _logger.LogInformation("Chat geçmişi temizlendi");
    }

    public async Task<bool> IsAvailableAsync()
    {
        try
        {
            using var httpClient = new HttpClient { Timeout = TimeSpan.FromSeconds(5) };
            var response = await httpClient.GetAsync($"{_baseUrl}/api/tags");
            return response.IsSuccessStatusCode;
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Ollama bağlantı kontrolü başarısız");
            return false;
        }
    }

    public async Task<List<string>> GetAvailableModelsAsync()
    {
        try
        {
            var ollamaClient = new OllamaApiClient(new Uri(_baseUrl));
            var models = await ollamaClient.ListLocalModelsAsync();
            return models.Select(m => m.Name).ToList();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Ollama model listesi alınamadı");
            return new List<string>();
        }
    }

    public async Task<string> ChatAsync(string message, CancellationToken cancellationToken = default)
    {
        try
        {
            await EnsureValidModelAsync(cancellationToken);
            IChatClient chatClient = new OllamaApiClient(new Uri(_baseUrl), _currentModel);

            _chatHistory.Add(new ChatMessage(ChatRole.User, message));

            var response = await chatClient.GetResponseAsync(_chatHistory, cancellationToken: cancellationToken);
            var assistantMessage = response.Text ?? "";

            _chatHistory.Add(new ChatMessage(ChatRole.Assistant, assistantMessage));

            return assistantMessage;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Ollama chat hatası");
            throw new InvalidOperationException($"Ollama ile iletişim kurulamadı: {ex.Message}", ex);
        }
    }

    public async IAsyncEnumerable<string> ChatStreamAsync(
        string message,
        [System.Runtime.CompilerServices.EnumeratorCancellation] CancellationToken cancellationToken = default)
    {
        await EnsureValidModelAsync(cancellationToken);
        IChatClient chatClient = new OllamaApiClient(new Uri(_baseUrl), _currentModel);

        _chatHistory.Add(new ChatMessage(ChatRole.User, message));
        var fullResponse = "";

        await foreach (var update in chatClient.GetStreamingResponseAsync(_chatHistory, cancellationToken: cancellationToken))
        {
            if (!string.IsNullOrEmpty(update.Text))
            {
                fullResponse += update.Text;
                yield return update.Text;
            }
        }

        _chatHistory.Add(new ChatMessage(ChatRole.Assistant, fullResponse));
    }

    public async Task<string> ChatWithHistoryAsync(
        List<ChatMessage> history,
        string message,
        CancellationToken cancellationToken = default)
    {
        try
        {
            await EnsureValidModelAsync(cancellationToken);
            IChatClient chatClient = new OllamaApiClient(new Uri(_baseUrl), _currentModel);

            var messages = new List<ChatMessage>(history)
            {
                new ChatMessage(ChatRole.User, message)
            };

            var response = await chatClient.GetResponseAsync(messages, cancellationToken: cancellationToken);
            return response.Text ?? "";
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Ollama chat with history hatası");
            throw new InvalidOperationException($"Ollama ile iletişim kurulamadı: {ex.Message}", ex);
        }
    }

    public async IAsyncEnumerable<string> ChatWithHistoryStreamAsync(
        List<ChatMessage> history,
        string message,
        [System.Runtime.CompilerServices.EnumeratorCancellation] CancellationToken cancellationToken = default)
    {
        await EnsureValidModelAsync(cancellationToken);
        IChatClient chatClient = new OllamaApiClient(new Uri(_baseUrl), _currentModel);

        var messages = new List<ChatMessage>(history)
        {
            new ChatMessage(ChatRole.User, message)
        };

        await foreach (var update in chatClient.GetStreamingResponseAsync(messages, cancellationToken: cancellationToken))
        {
            if (!string.IsNullOrEmpty(update.Text))
            {
                yield return update.Text;
            }
        }
    }

    private async Task EnsureValidModelAsync(CancellationToken cancellationToken = default)
    {
        var models = await GetAvailableModelsAsync();

        if (!models.Any())
        {
            throw new InvalidOperationException("Ollama çalışıyor ancak yüklü model bulunamadı. Örn: `ollama pull llama3.2` komutunu çalıştırın.");
        }

        if (models.Contains(_currentModel, StringComparer.OrdinalIgnoreCase))
        {
            return;
        }

        var eskiModel = _currentModel;
        _currentModel = models.First();
        _logger.LogWarning("Seçili Ollama modeli bulunamadı. Model otomatik değiştirildi. Eski: {EskiModel}, Yeni: {YeniModel}", eskiModel, _currentModel);
    }
}

// Ollama yapılandırma sınıfı
public class OllamaSettings
{
    public string BaseUrl { get; set; } = "http://localhost:11434";
    public string Model { get; set; } = "llama3.2";
}
