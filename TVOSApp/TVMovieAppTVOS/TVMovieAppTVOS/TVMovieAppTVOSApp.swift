import SwiftUI
import SwiftData

@main
struct TVMovieAppTVOSApp: App {

    var sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer(
                for: MovieListItem.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
