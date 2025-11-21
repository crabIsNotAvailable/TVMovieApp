namespace Backend.Dtos;

public sealed record MovieListItemDto(
    string Id,
    string Title,
    string ImageUrl,
    string UrlPath
);
