import UIKit
import SwiftUI

final class HighlightHeroView: UIView {

    var onSelect: ((MovieListItem) -> Void)?

    private let feedId: String
    private var movies: [MovieListItem] = []
    private var index: Int = 0

    private let cardWidth: CGFloat = 900
    private let cardHeight: CGFloat = 500
    private let spacing: CGFloat = 520
    private let neighborRadius: Int = 2
    private let titleHeight: CGFloat = 80

    private var cards: [HeroCardView] = []

    private let titleLabel = UILabel()

    init(feedId: String) {
        self.feedId = feedId
        super.init(frame: .zero)
        clipsToBounds = false
        setupTitleLabel()
        loadMovies()
    }

    required init?(coder: NSCoder) { fatalError() }

    override var canBecomeFocused: Bool { true }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 520 + titleHeight)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout(animated: false)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        DispatchQueue.main.async {
            self.setNeedsFocusUpdate()
            self.updateFocusIfNeeded()
        }
    }

    // MARK: - Title

    private func setupTitleLabel() {
        titleLabel.textColor = UIColor(red: 0.80, green: 0.66, blue: 0.05, alpha: 1.00)
        titleLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.alpha = 0

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -40),
            titleLabel.heightAnchor.constraint(equalToConstant: titleHeight)
        ])
    }

    private func updateTitle(animated: Bool) {
        guard movies.indices.contains(index) else {
            titleLabel.text = nil
            titleLabel.alpha = 0
            return
        }

        let newText = movies[index].title.uppercased()

        if !animated || titleLabel.text == nil {
            titleLabel.text = newText
            titleLabel.alpha = 1
            return
        }

        UIView.animate(withDuration: 0.18, animations: {
            self.titleLabel.alpha = 0
        }, completion: { _ in
            self.titleLabel.text = newText
            UIView.animate(withDuration: 0.22) {
                self.titleLabel.alpha = 1
            }
        })
    }

    // MARK: - Data

    private func loadMovies() {
        Task {
            movies = await MovieRepository.shared.getFeedMovies(feedId)

            await MainActor.run {
                self.buildCards()
                self.updateLayout(animated: false)
                self.updateTitle(animated: false)
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
                    self.updateTitle(animated: true)
                }
            }

            addSubview(card)
            cards.append(card)
        }
    }

    // MARK: - Carousel layout

    private func updateLayout(animated: Bool) {
        guard !cards.isEmpty else { return }

        let centerX = bounds.midX
        let centerY = (bounds.height - titleHeight) / 2

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
            }
        }

        animated
            ? UIView.animate(withDuration: 0.35, animations: animations)
            : animations()
    }

    // MARK: - Tap usage

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let press = presses.first else { return }

        switch press.type {
        case .leftArrow:
            index = wrap(index - 1)
            updateLayout(animated: true)
            updateTitle(animated: true)

        case .rightArrow:
            index = wrap(index + 1)
            updateLayout(animated: true)
            updateTitle(animated: true)

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
