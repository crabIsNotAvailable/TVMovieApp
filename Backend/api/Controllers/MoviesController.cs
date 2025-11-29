using Microsoft.AspNetCore.Mvc;
using Backend.Services;
using Backend.Dtos;
namespace Backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MoviesController : ControllerBase
{
    private readonly IMovieService _service;

    public MoviesController(IMovieService service)
    {
        _service = service;
    }

    [HttpGet("feeds")]
    public async Task<IActionResult> GetAllFeeds()
    {
        var feeds = await _service.GetAllFeeds();
        return Ok(feeds);
    }


    [HttpGet("feed/id/{feedId}")]
    public async Task<IActionResult> GetFeedById(string feedId)
    {
        var feed = await _service.GetFeedById(feedId);

        if (feed == null)
            return NotFound(new { error = "Feed not found" });

        return Ok(feed);
    }

    [HttpGet("detail/{*urlPath}")]
    public async Task<IActionResult> GetMovieDetail(string urlPath)
    {
        var detail = await _service.GetMovieDetail(urlPath);
        if (detail == null)
            return NotFound();
        return Ok(detail);
    }
}
