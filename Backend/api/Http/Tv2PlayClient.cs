using System.Net.Http.Json;
using Backend.Models.Feed;
using Backend.Models.Detail;
using System.Text.Json;

namespace Backend.Http;

public interface ITv2PlayClient
{
    Task<RootFeedResponse?> GetFeedAsync(string path, CancellationToken ct = default);

    Task<SingleFeedResponse?> GetSingleFeedAsync(string path, CancellationToken ct = default);

    Task<MovieDetail?> GetContentByPathAsync(string path, CancellationToken ct = default);
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
        // feedPath example: "/v4/feeds/page_01jwxh2p1me02sbhyxmht24cbp"
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

    public async Task<MovieDetail?> GetContentByPathAsync(string path, CancellationToken ct = default)
    {
        // path example: "film/the-fantastic-four-first-steps-e7zthsn5"
        var url = $"/v4/content/path/{path.TrimStart('/')}";
        var res = await _client.GetAsync(url, ct);
        res.EnsureSuccessStatusCode();
        var stream = await res.Content.ReadAsStreamAsync(ct);
        return await JsonSerializer.DeserializeAsync<MovieDetail>(stream, _jsonOptions, ct);
    }
}
