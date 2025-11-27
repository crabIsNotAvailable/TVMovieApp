using Backend.Models.Feed;
using Backend.Models.Detail;
using Backend.Dtos;

namespace Backend.Mappers;

public static class MovieMapper
{
    public static MovieListItemDto ToListDto(FeedContentItem item) =>
    new(
        Id: item.content_id,
        Title: item.title,
        ImageUrl: item.image?.src ?? "",
        UrlPath: item.url
    );

    public static MovieDetailDto ToDetailDto(MoviePageResponse detail)
{
    var meta = detail.Details?.Metainfo;

    // --- duration (e.g. "110 min") ---
    int? durationMinutes = null;
    var durationMeta = meta?
        .FirstOrDefault(x => x.Text != null && x.Text.Contains("min"));

    if (durationMeta?.Text != null)
    {
        var parts = durationMeta.Text.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        if (parts.Length > 0 && int.TryParse(parts[0], out var parsedMinutes))
        {
            durationMinutes = parsedMinutes;
        }
    }

    // --- year (e.g. "2025") ---
    int? year = null;
    var yearMeta = meta?
        .FirstOrDefault(x => x.Text != null &&
                             x.Text.Length == 4 &&
                             int.TryParse(x.Text, out _));

    if (yearMeta?.Text != null && int.TryParse(yearMeta.Text, out var parsedYear))
    {
        year = parsedYear;
    }


    // --- age rating ("12+") ---
    var ageRating = meta?
        .FirstOrDefault(x => x.Type == "age")?
        .Text;

    // --- genres ---
    var genres = meta?
        .Where(x => x.Type == "genre" && !string.IsNullOrWhiteSpace(x.Text))
        .Select(x => x.Text!)
        .ToList()
        ?? new List<string>();

    // --- cast ---
    var cast = detail.Details?.CastAndCrew?
        .Where(c => !string.IsNullOrWhiteSpace(c.Text))
        .Select(c => c.Text!)
        .ToList()
        ?? new List<string>();

    return new MovieDetailDto(
        Id: detail.T.ContentId ?? string.Empty,
        Title: detail.T.Title ?? string.Empty,
        Description: detail.Details?.Description ?? string.Empty,
        DurationMinutes: durationMinutes,
        PosterUrl: detail.Player.Image?.Src,
        Year: year,
        AgeRating: ageRating,
        Genres: genres,
        Cast: cast
    );
}


}


