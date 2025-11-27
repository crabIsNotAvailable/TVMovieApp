import SwiftUI

struct HeroSection: View {
    let movie: MovieDetailResponse

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // 🎬 Image
            AsyncImage(url: URL(string: movie.posterUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(height: 400)
            .cornerRadius(16)

            // 🎥 Title
            Text(movie.title)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(AppColors.gold)

            // ℹ️ Meta
            HStack(spacing: 20) {
                if let year = movie.year {
                    Text("\(year)")
                }
                if let duration = movie.durationMinutes {
                    Text("\(duration) min")
                }
            }
            .font(.title3)
            .foregroundColor(.white.opacity(0.8))
        }
    }
}
