//
//  MovieDatabase.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 25/11/2025.
//


import SwiftData

class MovieDatabase {
    static let shared = try! ModelContainer(
        for: MovieListItem.self,
        configurations: ModelConfiguration()
    )
}
