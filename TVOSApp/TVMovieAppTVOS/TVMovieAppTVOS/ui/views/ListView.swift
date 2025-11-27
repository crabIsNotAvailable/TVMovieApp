import SwiftUI
import SwiftData

enum Route: Hashable {
    case movieDetail(String)
}

struct ListView: View {

    @Environment(\.modelContext) private var context
    @State private var path: [Route] = []

    @State private var mostSeen: [MovieListItem] = []
    @State private var recommended: [MovieListItem] = []
    @State private var festival: [MovieListItem] = []

    @State private var highlightIndex = 0

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                AppColors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 80) {

                        if !mostSeen.isEmpty {
                            CascadingCarousel(
                                items: mostSeen,
                                index: $highlightIndex
                            ) { movie in
                                path.append(.movieDetail(movie.urlPath))
                            }
                        }

                        HorizontalGallery(
                            items: mostSeen,
                            variant: "poster",
                            title: "Most Seen"
                        ) { movie in
                            path.append(.movieDetail(movie.urlPath))
                        }

                        HorizontalGallery(
                            items: recommended,
                            variant: "landscape",
                            title: "Recommended"
                        ) { movie in
                            path.append(.movieDetail(movie.urlPath))
                        }

                        HorizontalGallery(
                            items: festival,
                            variant: "poster",
                            title: "Festival"
                        ) { movie in
                            path.append(.movieDetail(movie.urlPath))
                        }
                    }
                    .padding(.top, 80)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .movieDetail(let urlPath):
                    DetailsView(urlPath: urlPath)
                }
            }
        }
        .task {
            let repo = MovieRepository(context: context)
            mostSeen = await repo.getFeedMovies(FeedIds.mostSeen.rawValue)
            recommended = await repo.getFeedMovies(FeedIds.recommended.rawValue)
            festival = await repo.getFeedMovies(FeedIds.festival.rawValue)
        }
    }
}

