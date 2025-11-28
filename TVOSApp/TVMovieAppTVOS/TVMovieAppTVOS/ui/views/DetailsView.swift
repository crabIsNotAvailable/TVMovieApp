import SwiftUI

struct DetailsView: View {
    let urlPath: String
    @Environment(\.dismiss) private var dismiss

    @State private var movie: MovieDetailResponse?
    @State private var isLoading = true

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                if isLoading {
                    ProgressView()
                        .scaleEffect(1.6)
                        .tint(AppColors.gold)
                }

                else if let movie {
                    VStack(spacing: 0) {

                        // ================= HERO =================
                        ZStack(alignment: .topLeading) {

                            if let poster = movie.posterUrl,
                               let url = URL(string: poster) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    Color.black
                                }
                                .frame(
                                    maxWidth: .infinity,
                                    maxHeight: geo.size.height * 0.55
                                )
                            }

                            Button {
                                dismiss() // ✅ works now
                            } label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                                    .scaleEffect(1.15)
                            }
                            .buttonStyle(.plain)
                            .padding(24)
                        }
                        .frame(height: geo.size.height * 0.55)

                        // ================= CONTENT =================
                        VStack(alignment: .leading, spacing: 24) {

                            Text(movie.title)
                                .font(.title)
                                .bold()
                                .foregroundColor(AppColors.gold)

                            Text(movie.description)
                                .foregroundColor(.white.opacity(0.9))

                            if !movie.cast.isEmpty {
                                Text("Cast")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(AppColors.gold)

                                LazyVGrid(
                                    columns: [GridItem(.adaptive(minimum: 140), spacing: 16)],
                                    alignment: .leading,
                                    spacing: 12
                                ) {
                                    ForEach(movie.cast, id: \.self) { person in
                                        Text(person)
                                            .foregroundColor(.white.opacity(0.9))
                                        }
                                    }
                                }
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 12)
                    }
                }
            }
            .task { await loadMovie() }
        }
    }

    private func loadMovie() async {
        movie = try? await MovieApi.fetchMovieDetail(urlPath)
        isLoading = false
    }
}
