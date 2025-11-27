import SwiftUI

struct DetailsView: View {
    let urlPath: String

    @State private var movie: MovieDetailResponse?
    @State private var isLoading = true
    @State private var error: String?

    var body: some View {
        AppBackground {
            ScrollView {

                if isLoading {
                    ProgressView()
                        .padding()
                        .tint(AppColors.gold)
                }
                else if let movie {

                    VStack(alignment: .leading, spacing: 16) {

                        // ✅ Hero image
                        if let poster = movie.posterUrl,
                           let url = URL(string: poster) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.black.opacity(0.2)
                            }
                            .frame(height: 260)
                            .clipped()
                        }

                        VStack(alignment: .leading, spacing: 12) {

                            // ✅ Title
                            Text(movie.title)
                                .font(.title)
                                .bold()
                                .foregroundColor(AppColors.gold)

                            // ✅ Meta row
                            HStack(spacing: 12) {
                                if let year = movie.year {
                                    Text("\(year)")
                                }
                                if let age = movie.ageRating {
                                    Text(age)
                                }
                                if let duration = movie.durationMinutes {
                                    Text("\(duration) min")
                                }
                            }
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)

                            // ✅ Genres
                            if !movie.genres.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(movie.genres, id: \.self) { genre in
                                            Text(genre)
                                                .font(.caption)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 6)
                                                .background(AppColors.gold.opacity(0.9))
                                                .foregroundColor(.black)
                                                .cornerRadius(12)
                                        }
                                    }
                                }
                            }

                            // ✅ Description
                            Text(movie.description)
                                .foregroundColor(.white)
                                .font(.body)
                                .padding(.top, 8)

                            // ✅ Cast
                            if !movie.cast.isEmpty {
                                Text("Cast")
                                    .font(.headline)
                                    .foregroundColor(AppColors.gold)
                                    .padding(.top, 16)

                                ForEach(movie.cast, id: \.self) { actor in
                                    Text(actor)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.25))
                        )
                        .padding(.horizontal)
                    }
                }
                else if let error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .task {
            await loadMovie()
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func loadMovie() async {
        do {
            let response = try await MovieApi.fetchMovieDetail(urlPath)
            movie = response
        } catch {
            self.error = "Could not load movie"
        }
        isLoading = false
    }
}
