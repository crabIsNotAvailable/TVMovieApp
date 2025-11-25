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
        // Check cache first
        let descriptor = FetchDescriptor<MovieListItem>(
            predicate: #Predicate { $0.feedId == feedId }
        )

        if let cached = try? context.fetch(descriptor), !cached.isEmpty {
            return cached
        }

        // Fetch from API
        do {
            let feed = try await MovieApi.fetchFeed(feedId)

            // Save to SwiftData
            let items = feed.movies.map {
                MovieListItem(
                    id: $0.id,
                    title: $0.title,
                    imageUrl: $0.imageUrl,
                    feedId: feedId
                )
            }

            items.forEach(context.insert)
            try? context.save()

            return items
        } catch {
            print("Error loading feed:", error)
            return []
        }
    }
}


