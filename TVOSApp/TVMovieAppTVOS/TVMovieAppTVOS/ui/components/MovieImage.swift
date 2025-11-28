//
//  MovieImage.swift
//  TVMovieAppTVOS
//
//  Created by Maren Rødland on 25/11/2025.
//


import SwiftUI

struct MovieImage: View {
    let url: String
    let variant: String
    let onSelect: () -> Void

    @FocusState private var focused: Bool

    private var aspect: CGFloat {
        variant == "poster" ? (2/3) : (16/9)
    }

    private var baseWidth: CGFloat {
        variant == "poster" ? 400 : 600
    }

    // ✅ MAX SIZE (focused size!)
    private var maxWidth: CGFloat {
        baseWidth * 1.15
    }

    private var maxHeight: CGFloat {
        maxWidth / aspect
    }

    var body: some View {
        let currentWidth = focused ? maxWidth : baseWidth
        let currentHeight = currentWidth / aspect

        ZStack {
            AsyncImage(url: URL(string: toMovieImage(url, type: variant))) { phase in
                switch phase {
                case .success(let img):
                    img
                        .resizable()
                        .aspectRatio(aspect, contentMode: .fill)

                default:
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: currentWidth, height: currentHeight)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: focused ? 22 : 12)
            .animation(.easeOut(duration: 0.22), value: focused)
        }
        // ✅ OUTER BOX IS ALWAYS THE MAX SIZE
        .frame(width: maxWidth, height: maxHeight)
        .focusable(true)
        .focused($focused)
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
            .animation(.easeOut(duration: 0.2), value: focused)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.clear) // keeps layout stable
            )
            .scaleEffect(1.0)
    }
}

