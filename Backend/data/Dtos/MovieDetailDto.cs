namespace Backend.Dtos;

public sealed record MovieDetailDto(
    string Id,
    string Title,
    string Description,
    int? DurationMinutes,
    string? PosterUrl,
    int? Year,
    string? AgeRating,
    List<string> Genres,
    List<string> Cast
);
