namespace Backend.Models.Detail;

public sealed record MovieDetail(
    string id,
    string title,
    string? original_title,
    string description,
    int? duration,
    int? year,
    MovieDetailImages? images,
    string gpid,
    System.Collections.Generic.List<Backend.Models.Feed.Label>? labels
);

public sealed record MovieDetailImages(
    DetailImage? hero,
    DetailImage? poster,
    DetailImage? background
);

public sealed record DetailImage(
    string src
);
