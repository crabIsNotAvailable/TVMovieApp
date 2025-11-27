using System.Text.Json.Serialization;

namespace Backend.Models.Detail;

public sealed class MoviePageResponse
{
    public TrackingInfo? T { get; set; }

    public PlayerBlock? Player { get; set; }

    public DetailBlock? Details { get; set; }

}

public sealed class TrackingInfo
{
    public string? Title { get; set; }

    [JsonPropertyName("content_id")]
    public string? ContentId { get; set; }
}


public sealed class PlayerBlock
{
    public DetailImage? Image { get; set; }

    public string? Url { get; set; }
}


public sealed class DetailBlock
{
    public string? Description { get; set; }

    [JsonPropertyName("metainfo")]
    public List<MetaInfoItem>? Metainfo { get; set; }

    [JsonPropertyName("cast_and_crew")]
    public List<CastItem>? CastAndCrew { get; set; }
}

public sealed class DetailImage
{
    public string? Src { get; set; }
}


public sealed class MetaInfoItem
{
    public string? Text { get; set; }
    public string? Type { get; set; }
    public string? Value { get; set; }

    [JsonPropertyName("alt_text")]
    public string? AltText { get; set; }
}


public sealed class CastItem
{
    public string? Text { get; set; }

    [JsonPropertyName("filter_query")]
    public string? FilterQuery { get; set; }
}

