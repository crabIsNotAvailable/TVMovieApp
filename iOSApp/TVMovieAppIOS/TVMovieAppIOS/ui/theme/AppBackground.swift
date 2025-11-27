//
//  AppBackground.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 25/11/2025.
//


import SwiftUI

struct AppBackground<Content: View>: View {
    let content: () -> Content

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [AppColors.bgTop, AppColors.bgBottom]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .overlay(content())
    }
}
