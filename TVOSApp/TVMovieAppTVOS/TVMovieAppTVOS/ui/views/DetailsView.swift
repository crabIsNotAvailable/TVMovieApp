import SwiftUI

struct DetailsView: View {
    let urlPath: String

    @State private var movie: MovieDetailResponse?
    @State private var isLoading = true

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            if let movie {
                ScrollView {
                    VStack(spacing: 50) {
                        HeroSection(movie: movie)
                        InfoSection(movie: movie)
                    }
                    .padding(.horizontal, 100)
                    .padding(.bottom, 120)
                }
            } else {
                ProgressView()
                    .scaleEffect(1.6)
                    .tint(AppColors.gold)
            }
        }
        .task { await loadMovie() }
    }

    private func loadMovie() async {
        movie = try? await MovieApi.fetchMovieDetail(urlPath)
        isLoading = false
    }
}
