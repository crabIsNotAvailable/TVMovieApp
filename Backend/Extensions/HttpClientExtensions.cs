using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;

namespace Backend.Extensions;

public static class HttpClientExtensions
{
    public static async Task<T?> GetFromJsonSafeAsync<T>(this HttpClient client, string url, JsonSerializerOptions? opts = null, CancellationToken ct = default)
    {
        var res = await client.GetAsync(url, ct);
        if (!res.IsSuccessStatusCode) return default;
        var stream = await res.Content.ReadAsStreamAsync(ct);
        return await JsonSerializer.DeserializeAsync<T>(stream, opts ?? new JsonSerializerOptions { PropertyNameCaseInsensitive = true }, ct);
    }
}
