//
//  MovieImage.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 25/11/2025.
//


import SwiftUI

struct MovieImage: View {
    let url: String
    let variant: String

    var body: some View {
        let isPoster = (variant == "poster")

        let width: CGFloat  = isPoster ? 160 : 320
        let height: CGFloat = isPoster ? 240 : 180
        let ratio: CGFloat  = isPoster ? (2.0/3.0) : (16.0/9.0)

        AsyncImage(url: URL(string: url)) { img in
            img.resizable()
                .aspectRatio(ratio, contentMode: .fill)
        } placeholder: {
            Rectangle().fill(Color.gray.opacity(0.2))
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
