//
//  HeroImage.swift
//  TVMovieAppTVOS
//
//  Created by Maren Rødland on 27/11/2025.
//
import SwiftUI

struct HeroImage: View {
    let urlString: String?

    var body: some View {
        Group {
            if let urlString,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.black.opacity(0.3)
                }
            } else {
                Color.black.opacity(0.3)
            }
        }
        .clipped()
    }
}
