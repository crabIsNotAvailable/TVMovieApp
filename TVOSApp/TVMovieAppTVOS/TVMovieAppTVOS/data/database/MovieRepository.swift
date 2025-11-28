//
//  MovieRepository.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 25/11/2025.
//

import Foundation
import SwiftData

@MainActor
class MovieRepository {
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    static var shared: MovieRepository {
        MovieRepository(context: MovieDatabase.shared.mainContext)
    }
    
    
    func getFeedMovies(_ feedId: String) async -> [MovieListItem] {
        let descriptor = FetchDescriptor<MovieListItem>(
            predicate: #Predicate { $0.feedId == feedId }
        )

        if let cached = try? context.fetch(descriptor), !cached.isEmpty {
            return cached
        }

        do {
            let feed = try await MovieApi.fetchFeed(feedId)

            let items = feed.movies.map {
                MovieListItem(
                    remoteId: $0.id,
                    title: $0.title,
                    imageUrl: $0.imageUrl,
                    feedId: feedId,
                    urlPath: $0.urlPath
                )
            }

            items.forEach(context.insert)
            try context.save()

            return items
        } catch {
            print("Error loading feed:", error)
            return []
        }
    }

    
    func getMovie(by urlPath: String) async -> MovieListItem? {

        // 1️⃣ Check local cache first
        let descriptor = FetchDescriptor<MovieListItem>(
            predicate: #Predicate { $0.urlPath == urlPath }
        )

        if let cached = try? context.fetch(descriptor).first {
            return cached
        }

        // 2️⃣ Fetch from API
        do {
            let movie = try await MovieApi.fetchMovieDetail(urlPath)

            let entity = MovieListItem(
                remoteId: movie.id,
                title: movie.title,
                imageUrl: movie.posterUrl ?? "",
                feedId: "detail",
                urlPath: urlPath
            )

            context.insert(entity)
            try context.save()

            return entity
        } catch {
            print("Failed to fetch movie detail:", error)
            return nil
        }
    }

}


