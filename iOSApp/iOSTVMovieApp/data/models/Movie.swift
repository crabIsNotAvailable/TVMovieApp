import Foundation

struct MovieListItem: Identifiable, Hashable {
    let id: String
    let title: String
    let imageUrl: String
    let feedId: String
    let urlPath: String

    init(
        id: String,
        title: String,
        imageUrl: String,
        feedId: String,
        urlPath: String
    ) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.feedId = feedId
        self.urlPath = urlPath
    }
}
struct MovieDetailResponse: Codable {
    let id: String
    let title: String
    let description: String
    let durationMinutes: Int?
    let posterUrl: String?
    let year: Int?
    let ageRating: String?
    let genres: [String]
    let cast: [String]
}
