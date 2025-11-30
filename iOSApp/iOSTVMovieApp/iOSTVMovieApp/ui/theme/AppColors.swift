//
//  AppColors.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 25/11/2025.
//


import SwiftUI

struct AppColors {
    static let gold = Color(0xFFCCA90D)

    static let bgTop = Color(red: 0.00, green: 0.22, blue: 0.10)   // #01371A
    static let bgBottom = Color(red: 0.01, green: 0.06, blue: 0.02) // #041004
}

// Hex init
extension Color {
    init(_ hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
