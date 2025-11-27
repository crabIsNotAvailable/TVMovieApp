//
//  TVMovieAppIOSApp.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 25/11/2025.
//

import SwiftUI
import SwiftData

@main
struct TVMovieAppIOSApp: App {
    var body: some Scene {
        WindowGroup {
            ListView()
                .modelContainer(MovieDatabase.shared)
        }
    }
}

