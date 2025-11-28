import SwiftUI

struct DetailsView: View {
    let urlPath: String

    @State private var movie: MovieDetailResponse?
    @State private var isLoading = true
    @State private var error: String?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    // ---------- HERO ----------
                    if let poster = movie?.posterUrl,
                       let url = URL(string: poster) {

                        ZStack(alignment: .bottom) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.black.opacity(0.3)
                            }
                            .clipped()

                            LinearGradient(
                                colors: [.clear, .black],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 120)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    // ---------- CONTENT ----------
                    if let movie {

                        VStack(alignment: .leading, spacing: 16) {

                            // Title
                            Text(movie.title)
                                .font(.title)
                                .bold()
                                .foregroundColor(AppColors.gold)

                            // Meta
                            HStack(spacing: 12) {
                                if let year = movie.year {
                                    MetaText("\(year)")
                                }
                                if let age = movie.ageRating {
                                    MetaText(age)
                                }
                                if let duration = movie.durationMinutes {
                                    MetaText("\(duration) min")
                                }
                            }

                            // Genres
                            if !movie.genres.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(movie.genres, id: \.self) { genre in
                                            Text(genre)
                                                .font(.caption)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(AppColors.gold)
                                                .foregroundColor(.black)
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }

                            // Description
                            Text(movie.description)
                                .foregroundColor(.white.opacity(0.9))
                                .fixedSize(horizontal: false, vertical: true)

                            // Cast
                            if !movie.cast.isEmpty {
                                Text("Cast")
                                    .font(.headline)
                                    .foregroundColor(AppColors.gold)
                                    .padding(.top, 12)

                                ForEach(movie.cast, id: \.self) { actor in
                                    Text(actor)
                                        .foregroundColor(.white.opacity(0.85))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                    }

                    if isLoading {
                        ProgressView()
                            .tint(AppColors.gold)
                    }

                    if let error {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .task { await loadMovie() }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func loadMovie() async {
        do {
            movie = try await MovieApi.fetchMovieDetail(urlPath)
        } catch {
            self.error = "Could not load movie"
        }
        isLoading = false
    }
}

private func MetaText(_ text: String) -> some View {
    Text(text)
        .font(.subheadline)
        .foregroundColor(.white.opacity(0.7))
}
