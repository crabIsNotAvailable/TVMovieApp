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
    @State private var focus: [MovieListItem] = []
    @State private var newArrivals: [MovieListItem] = []
    @State private var buyRent: [MovieListItem] = []

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
                            items: recommended,
                            variant: "landscape",
                            title: "For deg"
                        ) { movie in
                            path.append(.movieDetail(movie.urlPath))
                        }

                        HorizontalGallery(
                            items: festival,
                            variant: "poster",
                            title: "Vist på Festival"
                        ) { movie in
                            path.append(.movieDetail(movie.urlPath))
                        }

                        HorizontalGallery(
                            items: focus,
                            variant: "landscape",
                            title: "Alltid film"
                        ) { movie in
                            path.append(.movieDetail(movie.urlPath))
                        }
                        HorizontalGallery(
                            items: newArrivals,
                            variant: "landscape",
                            title: "Nyankommende"
                        ) { movie in
                            path.append(.movieDetail(movie.urlPath))
                        }

                        HorizontalGallery(
                            items: buyRent,
                            variant: "poster",
                            title: "Kjøp eller lei"
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
                    DetailsView(
                        urlPath: urlPath
                    )
                }
            }
        }
        .task {
            let repo = MovieRepository(context: context)
            mostSeen = await repo.getFeedMovies(FeedIds.mostSeen.rawValue)
            recommended = await repo.getFeedMovies(FeedIds.recommended.rawValue)
            festival = await repo.getFeedMovies(FeedIds.festival.rawValue)
            focus = await repo.getFeedMovies(FeedIds.focus.rawValue)
            newArrivals = await repo.getFeedMovies(FeedIds.newArrivals.rawValue)
            buyRent = await repo.getFeedMovies(FeedIds.buyRent.rawValue)
        }
    }
}

