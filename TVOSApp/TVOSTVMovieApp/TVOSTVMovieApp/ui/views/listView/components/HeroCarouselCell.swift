//
//  HeroCarouselCell.swift
//  TVOSTVMovieApp
//
//  Created by Maren Rødland on 30/11/2025.
//


import UIKit

final class HeroCarouselCell: UICollectionViewCell {

    static let reuseId = "HeroCarouselCell"

    private let imageView = UIImageView()

    override var canBecomeFocused: Bool { true }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.clipsToBounds = false

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12

        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func didUpdateFocus(
        in context: UIFocusUpdateContext,
        with coordinator: UIFocusAnimationCoordinator
    ) {
        coordinator.addCoordinatedAnimations {
            if self.isFocused {
                self.transform = CGAffineTransform(scaleX: 1.18, y: 1.18)
                self.layer.shadowOpacity = 0.6
                self.layer.shadowRadius = 30
            } else {
                self.transform = .identity
                self.layer.shadowOpacity = 0
            }
        }
    }


    func configure(urlString: String) {
        imageView.image = nil
        guard let url = URL(string: urlString) else { return }

        Task { @MainActor in
            let (data, _) = try await URLSession.shared.data(from: url)
            imageView.image = UIImage(data: data)
        }
    }
}
