import Foundation

final class MovieApi {

    static let base = "http://localhost:8080/api/Movies" // Simulator only

    static func fetchFeed(_ feedId: String) async throws -> FeedDTO {
        guard let url = URL(string: "\(base)/feed/id/\(feedId)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(FeedDTO.self, from: data)
    }

    static func fetchMovieDetail(_ path: String) async throws -> MovieDetailResponse {
        let encoded = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? path

        guard let url = URL(string: "\(base)/detail/\(encoded)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(MovieDetailResponse.self, from: data)
    }
}
