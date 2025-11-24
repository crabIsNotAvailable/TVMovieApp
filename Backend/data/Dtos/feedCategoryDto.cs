using Backend.Dtos;
using Backend.Models.Feed;

public record feed_category_dto(
    string id,
    string title,
    string? section_title,
    List<MovieListItemDto> movies
);