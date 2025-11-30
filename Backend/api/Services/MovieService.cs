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

    public async Task<feedCategoryDto?> GetFeedById(string feedId, CancellationToken ct = default)
    {
        var feed = await _client.GetSingleFeedAsync($"/v4/feed/{feedId}", ct);
        if (feed == null) return null;



        if (feed.Content != null && feed.Content.Any())
        {
            // content[] format
            return new feedCategoryDto(
                id: feed.Id,
                title: feed.Title,
                section_title: feed.Section_Title,
                movies: feed.Content
                    .Select(MovieMapper.ToListDto)
                    .ToList()
            );
        }

        return null;
    }

    public async Task<MovieDetailDto?> GetMovieDetail(
        string urlPath,
        CancellationToken ct = default)
    {
        var page = await _client.GetContentByPathAsync(urlPath, ct);
        if (page is null)
            return null;

        return MovieMapper.ToDetailDto(page);
    }
}


