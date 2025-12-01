// Helps keep track of index of Hero Carousel

func signedDistance(_ i: Int, _ index: Int, _ total: Int) -> Int {
    var d = i - index
    if d > total / 2 { d -= total }
    if d < -total / 2 { d += total }
    return d
}
