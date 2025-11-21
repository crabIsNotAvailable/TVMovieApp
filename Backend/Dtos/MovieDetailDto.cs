namespace Backend.Dtos;

public sealed record MovieDetailDto(
    string Id,
    string Title,
    string Description,
    int? DurationMinutes,
    string? PosterUrl
);
