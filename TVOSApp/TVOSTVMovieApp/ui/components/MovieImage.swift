import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {

    static let reuseId = "MovieCollectionViewCell"

    private let imageView = UIImageView()

    override var canBecomeFocused: Bool {
        true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8

        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    override func didUpdateFocus(
        in context: UIFocusUpdateContext,
        with coordinator: UIFocusAnimationCoordinator
    ) {
        coordinator.addCoordinatedAnimations {
            if self.isFocused {
                self.transform = CGAffineTransform(scaleX: 1.04, y: 1.04)
                self.imageView.layer.borderWidth = 2
                self.imageView.layer.borderColor = UIColor.white.cgColor
            } else {
                self.transform = .identity
                self.imageView.layer.borderWidth = 0
            }
        }
    }

    func configure(with urlString: String) {
        imageView.image = nil

        guard let url = URL(string: urlString) else { return }

        Task { @MainActor in
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                self.imageView.image = UIImage(data: data)
            } catch {
                print("Image load failed:", error)
            }
        }
    }
}
