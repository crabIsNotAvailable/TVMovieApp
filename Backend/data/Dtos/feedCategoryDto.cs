using Backend.Dtos;

public record feedCategoryDto(
    string id,
    string title,
    string? section_title,
    List<MovieListItemDto> movies
);