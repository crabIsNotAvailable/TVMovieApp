//
//  MathHelper.swift
//  TVOSTVMovieApp
//
//  Created by Maren Rødland on 30/11/2025.
//

func signedDistance(_ i: Int, _ index: Int, _ total: Int) -> Int {
    var d = i - index
    if d > total / 2 { d -= total }
    if d < -total / 2 { d += total }
    return d
}
