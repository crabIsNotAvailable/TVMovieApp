struct FeedMovieDTO: Codable {
    let id: String
    let title: String
    let imageUrl: String
    let urlPath: String
}

struct FeedDTO: Codable {
    let id: String
    let title: String
    let movies: [FeedMovieDTO]
}
