namespace Backend.Models.Feed;

public sealed record RootFeedResponse(
    string Layout,
    List<Feed> Feeds
);

public sealed record Feed(
    string Id,
    string Title,
    string? Section_Title,
    string Type,
    string Self_Uri,
    int Size,
    int Start,
    int Total,
    FeedStyles? Styles,
    List<string>? Experiments,
    TrackingInfo? T,
    List<FeedContentItem> Content
);

public sealed record FeedStyles(
    FeedLayout Layout,
    FeedTheme Theme
);

public sealed record FeedLayout(
    string Name,
    string? Text,
    string? Aspect
);

public sealed record FeedTheme(
    string Name
);

public sealed record TrackingInfo(
    string C
);

public sealed record FeedContentItem(
    string Content_Id,
    string Gpid,
    string Title,
    string? Original_Title,
    string? Description,
    FeedImage Image,
    bool Downloadable,
    bool Autoplay,
    string Url,
    System.Collections.Generic.List<Label>? Labels,
    TrackingInfo? T
);
public class SingleFeedResponse
{
    public string Id { get; set; }
    public string Title { get; set; }
    public string? Section_Title { get; set; }

    public List<FeedContentItem> Content { get; set; } = new();
}

public sealed record FeedImage(
    string Src
);

public sealed record Label(
    string Text,
    string Type
);
