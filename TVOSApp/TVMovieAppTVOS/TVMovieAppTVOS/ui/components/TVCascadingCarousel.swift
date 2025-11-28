import SwiftUI

struct CascadingCarousel: View {
    let items: [MovieListItem]
    @Binding var index: Int
    let onSelect: (MovieListItem) -> Void

    private let cardWidth: CGFloat = 900
    private let cardHeight: CGFloat = 500
    private let spacing: CGFloat = 520
    private let neighborRadius = 3

    @FocusState private var focusedItem: Int?

    private func wrap(_ i: Int) -> Int {
        ((i % items.count) + items.count) % items.count
    }

    var body: some View {
        ZStack {

            // ================= LEFT BUTTON =================
            Button {
                index = wrap(index - 1)
                focusedItem = index
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 48, weight: .bold))
            }
            .buttonStyle(.plain)
            .focusable()
            .focused($focusedItem, equals: -1)
            .offset(x: -850)

            // ================= RIGHT BUTTON =================
            Button {
                index = wrap(index + 1)
                focusedItem = index
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 48, weight: .bold))
            }
            .buttonStyle(.plain)
            .focusable()
            .focused($focusedItem, equals: -2)
            .offset(x: 850)

            // ================= CARDS =================
            ZStack {
                ForEach(items.indices, id: \.self) { i in
                    let d = signedDistanceFor(i, index, items.count)
                    let absD = abs(d)

                    if absD <= neighborRadius {

                        let offsetX = CGFloat(d) * spacing
                        let rotateY = clamp(Double(-d) * 12, -30, 30)
                        let opacity = clamp(1 - Double(absD) * 0.18, 0.25, 1)
                        let scale   = clamp(1 - Double(absD) * 0.08, 0.85, 1)

                        HeroCard(
                            movie: items[i],
                            width: cardWidth,
                            height: cardHeight,
                            isFocused: focusedItem == i,
                            onSelect: {
                                if i == index {
                                    onSelect(items[i])
                                } else {
                                    index = i
                                    focusedItem = i
                                }
                            }
                        )
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .rotation3DEffect(
                            .degrees(rotateY),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .offset(x: offsetX)
                        .zIndex(1000 - Double(absD))
                        .focusable()
                        .focused($focusedItem, equals: i)
                        .onMoveCommand { dir in
                            if dir == .left {
                                index = wrap(index - 1)
                                focusedItem = index
                            } else if dir == .right {
                                index = wrap(index + 1)
                                focusedItem = index
                            }
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.35), value: index)
        }
        .frame(height: cardHeight + 40)
        .onAppear {
            focusedItem = index
        }
        .onMoveCommand { dir in
            if dir == .up || dir == .down {
            }
        }
    }
}


private struct HeroCard: View {
    let movie: MovieListItem
    let width: CGFloat
    let height: CGFloat
    let isFocused: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            AsyncImage(url: URL(string: movie.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Color.gray.opacity(0.25)
                }
            }
            .frame(width: width, height: height)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.5), radius: 30, y: 20)
            .scaleEffect(isFocused ? 1.12 : 1.0)
            .animation(.easeOut(duration: 0.22), value: isFocused)
        }
        .buttonStyle(.plain)
        .focusable(true)
    }
}
