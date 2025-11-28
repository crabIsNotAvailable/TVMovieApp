import SwiftUI

struct InfoSection: View {
    let movie: MovieDetailResponse

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {

            // 🎞 GENRES
            if !movie.genres.isEmpty {
                HStack(spacing: 14) {
                    ForEach(movie.genres, id: \.self) { genre in
                        Text(genre.uppercased())
                            .font(.caption.bold())
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(AppColors.gold)
                            .foregroundColor(.black)
                            .cornerRadius(14)
                    }
                }
            }

            // 📝 DESCRIPTION
            Text(movie.description)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .lineSpacing(8)
                .frame(maxWidth: 1200, alignment: .leading)

            // 🎭 CAST
            if !movie.cast.isEmpty {
                VStack(alignment: .leading, spacing: 16) {

                    Text("CAST")
                        .font(.title2.bold())
                        .foregroundColor(AppColors.gold)

                    ForEach(movie.cast, id: \.self) { actor in
                        Text(actor)
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }
        }
        .padding(.top, 20)
    }
}
