//
//  MovieListItem.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 25/11/2025.
//


import SwiftData

@Model
class MovieListItem {
    @Attribute(.unique) var id: String
    var title: String
    var imageUrl: String
    var feedId: String  // so we can store items per feed

    init(id: String, title: String, imageUrl: String, feedId: String) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.feedId = feedId
    }
}

struct MovieDetailResponse: Codable {
    let title: String
    let description: String
    let imageUrl: String
}
