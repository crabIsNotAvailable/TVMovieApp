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

                        HighlightHero(feedId: FeedIds.mostSeen.rawValue,
                            onSelect: { movie in
                                path.append(.movieDetail(movie.urlPath))
                            }
                        )
                        
                        FeedSection(
                            title: "For deg",
                            feedId: FeedIds.recommended.rawValue,
                            variant: "poster",
                            onSelect: { movie in
                                path.append(.movieDetail(movie.urlPath))
                            }
                        )

                        FeedSection(
                            title: "Vist på festival",
                            feedId: FeedIds.festival.rawValue,
                            variant: "landscape",
                            onSelect: { movie in
                                path.append(.movieDetail(movie.urlPath))
                            }
                        )
                        FeedSection(
                            title: "Alltid film",
                            feedId: FeedIds.focus.rawValue,
                            variant: "landscape",
                            onSelect: { movie in
                                path.append(.movieDetail(movie.urlPath))
                            }
                        )

                        FeedSection(
                            title: "Nyankommende",
                            feedId: FeedIds.newArrivals.rawValue,
                            variant: "landscape",
                            onSelect: { movie in
                                path.append(.movieDetail(movie.urlPath))
                            }
                        )
                        FeedSection(
                            title: "Kjøp eller lei",
                            feedId: FeedIds.buyRent.rawValue,
                            variant: "poster",
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
