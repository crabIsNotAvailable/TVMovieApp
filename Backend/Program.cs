using Backend.Services;
using Backend.Http;
using Backend.Mappers;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Configuration
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "TV2 Proxy API", Version = "v1" });
});
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader()
    );
});

// Http client for TV2
builder.Services.AddHttpClient("tv2", client =>
{
    // Keep base address as just the domain, add full paths in your client code
    client.BaseAddress = new Uri("https://ai.play.tv2.no");
    client.DefaultRequestHeaders.Add("Accept", "application/json");
});

// DI
builder.Services.AddScoped<ITv2PlayClient, Tv2PlayClient>();
builder.Services.AddScoped<IMovieService, MovieService>();

var app = builder.Build();

// Enable Swagger in Development
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "TV2 Proxy API V1");
        c.RoutePrefix = "swagger"; // Accessible at /swagger
    });
}



app.UseCors("AllowAll");
// Comment out HTTPS redirect for testing
// app.UseHttpsRedirection();

app.UseAuthorization();
app.MapControllers();

// Log the URLs the app is listening on
app.Lifetime.ApplicationStarted.Register(() =>
{
    var addresses = app.Urls;
    Console.WriteLine("=== Application Started ===");
    foreach (var address in addresses)
    {
        Console.WriteLine($"Listening on: {address}");
        Console.WriteLine($"Swagger UI: {address}/swagger");
    }
    Console.WriteLine("===========================");
});

app.Run();