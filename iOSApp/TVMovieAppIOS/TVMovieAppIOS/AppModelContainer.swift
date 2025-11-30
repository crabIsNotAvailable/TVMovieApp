//
//  AppModelContainer.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 29/11/2025.
//


import SwiftData

@MainActor
enum AppModelContainer {
    static let shared = MovieDatabase.shared
}