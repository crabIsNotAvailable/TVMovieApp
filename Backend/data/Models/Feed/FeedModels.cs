namespace Backend.Models.Feed;

public sealed record RootFeedResponse(
    string layout,
    List<Feed> feeds
);

public sealed record Feed(
    string id,
    string title,
    string? section_title,
    string type,
    string self_uri,
    int size,
    int start,
    int total,
    FeedStyles? styles,
    System.Collections.Generic.List<string>? experiments,
    TrackingInfo? t,
    System.Collections.Generic.List<FeedContentItem> content
);

public sealed record FeedStyles(
    FeedLayout layout,
    FeedTheme theme
);

public sealed record FeedLayout(
    string name,
    string? text,
    string? aspect
);

public sealed record FeedTheme(
    string name
);

public sealed record TrackingInfo(
    string c
);

public sealed record FeedContentItem(
    string content_id,
    string gpid,
    string title,
    string? original_title,
    string? description,
    FeedImage image,
    bool downloadable,
    bool autoplay,
    string url,
    System.Collections.Generic.List<Label>? labels,
    TrackingInfo? t
);

public sealed record FeedImage(
    string src
);

public sealed record Label(
    string text,
    string type
);
