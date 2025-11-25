import SwiftUI
import SwiftData

struct ListView: View {

    @Environment(\.modelContext) private var context

    @State private var mostSeen: [MovieListItem] = []
    @State private var recommended: [MovieListItem] = []
    @State private var festival: [MovieListItem] = []

    @State private var highlightIndex: Int = 0

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 80) {

                    // ⭐ Highlight carousel
                    if !mostSeen.isEmpty {
                        CascadingCarousel(
                            items: mostSeen,
                            index: $highlightIndex
                        )
                    }

                    // ⭐ Poster gallery
                    HorizontalGallery(
                        items: mostSeen,
                        variant: "poster",
                        title: "Most Seen"
                    ) { movie in
                        print("SELECTED:", movie.title)
                    }

                    // ⭐ Landscape gallery
                    HorizontalGallery(
                        items: recommended,
                        variant: "landscape",
                        title: "Recommended"
                    ) { movie in
                        print("SELECTED:", movie.title)
                    }

                    // ⭐ Poster gallery
                    HorizontalGallery(
                        items: festival,
                        variant: "poster",
                        title: "Festival"
                    ) { movie in
                        print("SELECTED:", movie.title)
                    }
                }
                .padding(.top, 80)
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
