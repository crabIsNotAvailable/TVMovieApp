//
//  MovieImage.swift
//  TVMovieAppTVOS
//
//  Created by Maren Rødland on 25/11/2025.
//


import SwiftUI

struct MovieImage: View {
    let url: String
    let variant: String     // "poster" or "landscape"
    let onSelect: () -> Void

    private var aspect: CGFloat {
        variant == "poster" ? (2/3) : (16/9)
    }

    private var finalUrl: String {
        toMovieImage(url, type: variant)
    }

    private var width: CGFloat {
        variant == "poster" ? 160 : 380
    }

    var body: some View {
        let height = width / aspect

        AsyncImage(url: URL(string: finalUrl)) { phase in
            switch phase {
            case .success(let img):
                img.resizable()
                    .aspectRatio(aspect, contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 12)
                    .scaleEffectOnTVFocus()
            default:
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.3))
                    .frame(width: width, height: height)
            }
        }
        .onTapGesture { onSelect() }
    }
}

extension View {
    func scaleEffectOnTVFocus() -> some View {
        modifier(FocusScaleModifier())
    }
}

struct FocusScaleModifier: ViewModifier {
    @FocusState private var focused: Bool

    func body(content: Content) -> some View {
        content
            .focusable(true)
            .focused($focused)
            .scaleEffect(focused ? 1.15 : 1.0)
            .animation(.easeOut(duration: 0.2), value: focused)
    }
}
