//
//  FeedSection.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 25/11/2025.
//

import Foundation
import SwiftUI

struct FeedSection: View {
    let title: String
    let feedId: String
    let variant: String
    let onSelect: (MovieListItem) -> Void

    @State private var movies: [MovieListItem] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(AppText.section)
                .foregroundColor(AppColors.gold)
                .padding(.leading)

            HorizontalGallery(
                items: movies,
                variant: variant,
                onSelect: onSelect // ✅ forward
            )
        }
        .task {
            movies = await MovieRepository.shared.getFeedMovies(feedId)
        }
    }
}
