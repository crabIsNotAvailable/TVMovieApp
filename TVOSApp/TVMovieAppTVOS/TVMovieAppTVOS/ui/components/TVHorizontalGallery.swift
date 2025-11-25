import SwiftUI

struct HorizontalGallery: View {
    let items: [MovieListItem]
    let variant: String
    let title: String?
    let onSelect: (MovieListItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = title {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(AppColors.gold)
                    .padding(.leading, 40)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(items) { movie in
                        MovieImage(
                            url: movie.imageUrl,
                            variant: variant
                        ) {
                            onSelect(movie)
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
        }
        .padding(.vertical, 30)
    }
}
