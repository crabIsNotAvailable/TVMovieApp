using Backend.Http;
using Backend.Dtos;
using Backend.Mappers;
using Backend.Models.Feed;

namespace Backend.Services;

public class MovieService : IMovieService
{
    private readonly ITv2PlayClient _client;

    public MovieService(ITv2PlayClient client)
    {
        _client = client;
    }

    public async Task<RootFeedResponse?> GetAllFeeds(CancellationToken ct = default)
    {
        return await _client.GetFeedAsync("/v4/feeds/page_01jwxh2p1me02sbhyxmht24cbp", ct);
    }

    public async Task<feed_category_dto?> GetFeedById(string feedId, CancellationToken ct = default)
    {
        var feed = await _client.GetSingleFeedAsync($"/v4/feed/{feedId}", ct);
        if (feed == null) return null;



        if (feed.content != null && feed.content.Any())
        {
            // content[] format
            return new feed_category_dto(
                id: feed.id,
                title: feed.title,
                section_title: feed.section_title,
                movies: feed.content
                    .Select(MovieMapper.ToListDto)
                    .ToList()
            );
        }

        return null;
    }





    public async Task<MovieDetailDto?> GetMovieDetail(string urlPath, CancellationToken ct = default)
    {
        var movie = await _client.GetContentByPathAsync(urlPath, ct);
        return movie == null ? null : MovieMapper.ToDetailDto(movie);
    }

    public async Task<List<MovieListItemDto>> SearchMovies(string query, CancellationToken ct = default)
    {
        var root = await GetAllFeeds(ct);
        if (root == null) return new List<MovieListItemDto>();

        return root.feeds
            .SelectMany(f => f.content)
            .Where(m => m.title.Contains(query, StringComparison.OrdinalIgnoreCase))
            .Select(MovieMapper.ToListDto)
            .ToList();
    }
}


