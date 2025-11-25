//
//  FeedMovieDTO.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 25/11/2025.
//


struct FeedMovieDTO: Codable {
    let id: String
    let title: String
    let imageUrl: String
}

struct FeedDTO: Codable {
    let id: String
    let title: String
    let movies: [FeedMovieDTO]
}
