import SwiftUI

enum Route: Hashable {
    case movieDetail(String)
}


struct ListView: View {
    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            AppBackground {
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {

                        FeedSection(
                            title: "Recommended",
                            feedId: FeedIds.recommended.rawValue,
                            variant: "poster",
                            onSelect: { movie in
                                path.append(.movieDetail(movie.urlPath))
                            }
                        )

                        FeedSection(
                            title: "Focus",
                            feedId: FeedIds.focus.rawValue,
                            variant: "landscape",
                            onSelect: { movie in
                                path.append(.movieDetail(movie.urlPath))
                            }
                        )

                        FeedSection(
                            title: "New Arrivals",
                            feedId: FeedIds.newArrivals.rawValue,
                            variant: "poster",
                            onSelect: { movie in
                                path.append(.movieDetail(movie.urlPath))
                            }
                        )

                        FeedSection(
                            title: "Festival",
                            feedId: FeedIds.festival.rawValue,
                            variant: "landscape",
                            onSelect: { movie in
                                path.append(.movieDetail(movie.urlPath))
                            }
                        )
                    }
                    .padding(.top, 20)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .movieDetail(let urlPath):
                    DetailsView(urlPath: urlPath)
                }
            }
        }
    }
}
