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
    public static MovieListItemDto ToListDto2(FeedMovieItem item) =>
    new(
        Id: item.id,
        Title: item.title,
        ImageUrl: item.imageUrl ?? "",
        UrlPath: item.urlPath
    );

    public static MovieDetailDto ToDetailDto(MovieDetail detail) =>
        new(
            Id: detail.id,
            Title: detail.title,
            Description: detail.description,
            DurationMinutes: detail.duration.HasValue
                ? detail.duration.Value / 60
                : null,
            PosterUrl: detail.images?.poster?.src
        );
}