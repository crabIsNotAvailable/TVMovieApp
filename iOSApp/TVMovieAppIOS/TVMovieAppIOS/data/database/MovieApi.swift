//
//  MovieApi.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 25/11/2025.
//


import Foundation

class MovieApi {
    static let base = "http://localhost:8080/api/Movies" // Simulator only

    static func fetchFeed(_ feedId: String) async throws -> FeedDTO {
        let url = URL(string: "\(base)/feed/id/\(feedId)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(FeedDTO.self, from: data)
    }

    static func fetchMovieDetail(_ path: String) async throws -> MovieDetailResponse {
        let encoded = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let url = URL(string: "\(base)/detail/\(encoded)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(MovieDetailResponse.self, from: data)
    }
}
