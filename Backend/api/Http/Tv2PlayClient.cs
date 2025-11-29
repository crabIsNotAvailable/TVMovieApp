using System.Net.Http.Json;
using Backend.Models.Feed;
using Backend.Models.Detail;
using System.Text.Json;

namespace Backend.Http;

public interface ITv2PlayClient
{
    Task<RootFeedResponse?> GetFeedAsync(string path, CancellationToken ct = default);

    Task<SingleFeedResponse?> GetSingleFeedAsync(string path, CancellationToken ct = default);

    Task<MoviePageResponse?> GetContentByPathAsync(string path, CancellationToken ct = default);
}


public class Tv2PlayClient : ITv2PlayClient
{
    private readonly IHttpClientFactory _factory;
    private readonly HttpClient _client;
    private readonly JsonSerializerOptions _jsonOptions = new() { PropertyNameCaseInsensitive = true };

    public Tv2PlayClient(IHttpClientFactory factory)
    {
        _factory = factory;
        _client = _factory.CreateClient("tv2");
    }

    public async Task<RootFeedResponse?> GetFeedAsync(string feedPath, CancellationToken ct = default)
    {
        var res = await _client.GetAsync(feedPath, ct);
        res.EnsureSuccessStatusCode();
        var stream = await res.Content.ReadAsStreamAsync(ct);
        return await JsonSerializer.DeserializeAsync<RootFeedResponse>(stream, _jsonOptions, ct);
    }

    public async Task<SingleFeedResponse?> GetSingleFeedAsync(string feedPath, CancellationToken ct = default)
    {
        var res = await _client.GetAsync(feedPath, ct);

        if (!res.IsSuccessStatusCode)
            return null;

        var stream = await res.Content.ReadAsStreamAsync(ct);
        return await JsonSerializer.DeserializeAsync<SingleFeedResponse>(stream, _jsonOptions, ct);
    }

    public async Task<MoviePageResponse?> GetContentByPathAsync(string path, CancellationToken ct = default)
    {
        var url = $"/v4/content/path/{path.TrimStart('/')}";
        var res = await _client.GetAsync(url, ct);
        res.EnsureSuccessStatusCode();
        var stream = await res.Content.ReadAsStreamAsync(ct);
        return await JsonSerializer.DeserializeAsync<MoviePageResponse>(stream, _jsonOptions, ct);
    }
}
