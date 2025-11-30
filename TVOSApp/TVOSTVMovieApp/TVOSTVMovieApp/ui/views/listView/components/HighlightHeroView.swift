import UIKit

final class HighlightHeroView: UIView {

    var onSelect: ((MovieListItem) -> Void)?

    private let feedId: String
    private var movies: [MovieListItem] = []
    private var index: Int = 0

    private let cardWidth: CGFloat = 900
    private let cardHeight: CGFloat = 500
    private let spacing: CGFloat = 520
    private let neighborRadius: Int = 2

    private var cards: [HeroCardView] = []

    init(feedId: String) {
        self.feedId = feedId
        super.init(frame: .zero)
        clipsToBounds = false
        loadMovies()
    }

    required init?(coder: NSCoder) { fatalError() }

    override var canBecomeFocused: Bool { true }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout(animated: false)
    }

    private func loadMovies() {
        Task {
            movies = await MovieRepository.shared.getFeedMovies(feedId)

            await MainActor.run {
                self.buildCards()
                self.updateLayout(animated: false)
                self.setNeedsFocusUpdate()
                self.updateFocusIfNeeded()
            }
        }
    }

    private func buildCards() {
        cards.forEach { $0.removeFromSuperview() }
        cards.removeAll()

        for (i, movie) in movies.enumerated() {
            let card = HeroCardView(movie: movie)

            card.onSelect = { [weak self] in
                guard let self else { return }
                if i == self.index {
                    self.onSelect?(movie)
                } else {
                    self.index = i
                    self.updateLayout(animated: true)
                }
            }

            addSubview(card)
            cards.append(card)
        }
    }
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 520)
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()

        DispatchQueue.main.async {
            self.setNeedsFocusUpdate()
            self.updateFocusIfNeeded()
        }
    }
    private func updateLayout(animated: Bool) {
        guard !cards.isEmpty else { return }

        let centerX = bounds.midX
        let centerY = bounds.midY

        let animations = {
            for (i, card) in self.cards.enumerated() {
                let d = signedDistance(i, self.index, self.movies.count)
                let absD = abs(d)

                if absD > self.neighborRadius {
                    card.alpha = 0
                    continue
                }

                let offsetX = CGFloat(d) * self.spacing
                let scale   = max(0.85, 1 - CGFloat(absD) * 0.08)
                let rotateY = CGFloat(-d) * 12 * (.pi / 180)
                let opacity = max(0.25, 1 - CGFloat(absD) * 0.18)

                card.alpha = opacity

                var transform = CGAffineTransform.identity
                transform = transform
                    .translatedBy(
                        x: centerX + offsetX - self.cardWidth / 2,
                        y: centerY - self.cardHeight / 2
                    )
                    .scaledBy(x: scale, y: scale)

                card.transform = transform
                card.layer.zPosition = CGFloat(1000 - absD)

                // optional: 3D tilt via layer.transform if you want
            }
        }

        if animated {
            UIView.animate(withDuration: 0.35, animations: animations)
        } else {
            animations()
        }
    }

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let press = presses.first else { return }

        switch press.type {
        case .leftArrow:
            index = wrap(index - 1)
            updateLayout(animated: true)

        case .rightArrow:
            index = wrap(index + 1)
            updateLayout(animated: true)

        case .select:
            if movies.indices.contains(index) {
                onSelect?(movies[index])
            }

        default:
            super.pressesBegan(presses, with: event)
        }
    }

    private func wrap(_ i: Int) -> Int {
        (i % movies.count + movies.count) % movies.count
    }
}
