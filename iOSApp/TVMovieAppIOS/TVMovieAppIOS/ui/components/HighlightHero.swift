import SwiftUI
import Combine

struct HighlightHero: View {
    let feedId: String
    let onSelect: (MovieListItem) -> Void

    @State private var movies: [MovieListItem] = []
    @State private var index = 0

    private let timer = Timer.publish(every: 5, on: .main, in: .common)
        .autoconnect()

    var body: some View {
        if movies.isEmpty {
            Color.clear
                .frame(height: 1) // keeps layout stable
                .task { await loadMovies() }
        } else {
            ZStack {

                AsyncImage(url: URL(string: movies[index].imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    default:
                        Color.black.opacity(0.3)
                    }
                }
                .onTapGesture {
                    onSelect(movies[index])
                }

                // LEFT
                ArrowButton {
                    previous()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)

                // RIGHT
                ArrowButton(rotation: 180) {
                    next()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 8)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(16/9, contentMode: .fit)
            .clipped()
            .onReceive(timer) { _ in next() }
            .padding(.bottom, 16)
            .task { await loadMovies() }
        }
    }

    // MARK: - Helpers

    private func loadMovies() async {
        let list = await MovieRepository.shared.getFeedMovies(feedId)
        movies = list
        index = 0
    }

    private func next() {
        index = (index + 1) % movies.count
    }

    private func previous() {
        index = (index - 1 + movies.count) % movies.count
    }
}

private struct ArrowButton: View {
    var rotation: Double = 0
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .rotationEffect(.degrees(rotation))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
        }
    }
}
