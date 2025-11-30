using Backend.Dtos;
using Backend.Models.Feed;

namespace Backend.Services
{
    public interface IMovieService
    {
        Task<RootFeedResponse?> GetAllFeeds(CancellationToken ct = default);

        Task<feedCategoryDto?> GetFeedById(string feedId, CancellationToken ct = default);

        Task<MovieDetailDto?> GetMovieDetail(string urlPath, CancellationToken ct = default);

    }

}
