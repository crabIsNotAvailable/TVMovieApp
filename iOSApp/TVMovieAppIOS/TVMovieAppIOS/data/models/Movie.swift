//
//  MovieListItem.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 25/11/2025.
//

import Foundation
import SwiftData

@Model
class MovieListItem {
    @Attribute(.unique) var id: UUID
    var remoteId: String
    var title: String
    var imageUrl: String
    var feedId: String
    var urlPath: String

    init(
        remoteId: String,
        title: String,
        imageUrl: String,
        feedId: String,
        urlPath: String
    ) {
        self.id = UUID()
        self.remoteId = remoteId
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

