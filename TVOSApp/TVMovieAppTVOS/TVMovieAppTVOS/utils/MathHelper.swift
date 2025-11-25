import Foundation

// Double clamp
func clamp(_ value: Double, _ minValue: Double, _ maxValue: Double) -> Double {
    return max(minValue, min(value, maxValue))
}

// Int clamp (kept for other use)
func clamp(_ value: Int, _ minValue: Int, _ maxValue: Int) -> Int {
    return max(minValue, min(value, maxValue))
}

// Signed circular distance
func signedDistanceFor(_ i: Int, _ index: Int, _ total: Int) -> Int {
    var d = i - index
    if d > total / 2 { d -= total }
    if d < -total / 2 { d += total }
    return d
}
