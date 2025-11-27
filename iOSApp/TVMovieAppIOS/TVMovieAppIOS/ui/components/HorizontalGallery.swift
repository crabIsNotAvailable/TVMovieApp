import SwiftUI

struct HorizontalGallery: View {
    let items: [MovieListItem]
    let variant: String        // "poster" or "landscape"
    let onSelect: (MovieListItem) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(items) { movie in
                    let finalUrl = toMovieImage(movie.imageUrl, type: variant)

                    MovieImage(url: finalUrl, variant: variant)
                        .contentShape(Rectangle()) // ✅ makes whole card tappable
                        .onTapGesture {
                            onSelect(movie)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}
