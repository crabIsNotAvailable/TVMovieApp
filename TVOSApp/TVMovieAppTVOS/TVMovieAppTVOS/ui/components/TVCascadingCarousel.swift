import SwiftUI

struct CascadingCarousel: View {
    let items: [MovieListItem]
    @Binding var index: Int
    var neighborRadius = 3

    @FocusState private var focusedItem: Int?

    private func wrap(_ i: Int) -> Int {
        ((i % items.count) + items.count) % items.count
    }

    var body: some View {
        ZStack {

            // LEFT BUTTON
            Button(action: {
                index = wrap(index - 1)
                focusedItem = index
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 46, weight: .bold))
                    .padding()
            }
            .buttonStyle(.plain)
            .focusable()
            .focused($focusedItem, equals: -1)          // virtual ID
            .onMoveCommand { dir in
                if dir == .right { focusedItem = index } // move into carousel
            }
            .offset(x: -700)

            // RIGHT BUTTON
            Button(action: {
                index = wrap(index + 1)
                focusedItem = index
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 46, weight: .bold))
                    .padding()
            }
            .buttonStyle(.plain)
            .focusable()
            .focused($focusedItem, equals: -2)
            .onMoveCommand { dir in
                if dir == .left { focusedItem = index }
            }
            .offset(x: 700)


            // ------------- CAROUSEL ITEMS -------------
            ZStack {
                ForEach(items.indices, id: \.self) { i in
                    let total = items.count
                    let d = signedDistanceFor(i, index, total)
                    let absD = abs(d)

                    if absD <= neighborRadius {
                        let scale      = clamp(1.0 - Double(absD) * 0.14, 0.6, 1.0)
                        let translateX = Double(d) * 260
                        let rotateY    = clamp(Double(-d) * 10.0, -30.0, 30.0)
                        let opacity    = clamp(1.0 - Double(absD) * 0.15, 0.2, 1.0)

                        MovieImage(
                            url: items[i].imageUrl,
                            variant: "landscape"
                        ) {
                            index = i
                            focusedItem = i
                        }
                        .frame(width: 820, height: 440)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .rotation3DEffect(
                            .degrees(rotateY),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .offset(x: translateX)
                        .zIndex(Double(1000 - absD))
                        .focusable()
                        .focused($focusedItem, equals: i)
                        .onMoveCommand { direction in
                            if direction == .left {
                                index = wrap(index - 1)
                                focusedItem = index
                            } else if direction == .right {
                                index = wrap(index + 1)
                                focusedItem = index
                            }
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.4), value: index)
        }
        .frame(height: 500)
        .onAppear {
            focusedItem = index     // center gets focus at start
        }
    }
}
