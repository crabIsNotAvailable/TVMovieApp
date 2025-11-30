//
//  MovieRepository.swift
//  iOSTVMovieApp
//
//  Created by Maren Rødland on 29/11/2025.
//


import Foundation
import CoreData

@MainActor
final class MovieRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    static let shared = MovieRepository(
        context: PersistenceController.shared.container.viewContext
    )

    // MARK: - Feed

    func getFeedMovies(_ feedId: String) async -> [MovieListItem] {

        let request: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        request.predicate = NSPredicate(format: "feedId == %@", feedId)

        if let cached = try? context.fetch(request), !cached.isEmpty {
            return cached.map { $0.toDomain() }
        }

        do {
            let feed = try await MovieApi.fetchFeed(feedId)

            // feed.movies is your existing DTO array
            for dto in feed.movies {
                let entity = CDMovie(context: context)
                entity.remoteId = dto.id              // String → String
                entity.title = dto.title
                entity.imageUrl = dto.imageUrl
                entity.feedId = feedId
                entity.urlPath = dto.urlPath
            }

            try context.save()

            let saved = try context.fetch(request)
            return saved.map { $0.toDomain() }
        } catch {
            print("Error loading feed:", error)
            return []
        }
    }


    // MARK: - Movie detail

    func getMovie(by urlPath: String) async -> MovieListItem? {

        let request: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "urlPath == %@", urlPath)

        if let cached = try? context.fetch(request).first {
            return cached.toDomain()
        }

        do {
            let movie = try await MovieApi.fetchMovieDetail(urlPath)

            let entity = CDMovie(context: context)
            entity.remoteId = movie.id
            entity.title = movie.title
            entity.imageUrl = movie.posterUrl ?? ""
            entity.feedId = "detail"
            entity.urlPath = urlPath

            try context.save()

            return entity.toDomain()
        } catch {
            print("Failed to fetch movie detail:", error)
            return nil
        }
    }
}
