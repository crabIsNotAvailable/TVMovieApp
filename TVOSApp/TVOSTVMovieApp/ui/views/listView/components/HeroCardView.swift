import UIKit

final class HeroCardView: UIView {

    var onSelect: (() -> Void)?

    private let imageView = UIImageView()

    init(movie: MovieListItem) {
        super.init(frame: .zero)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18

        addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 900, height: 500)

        Task { @MainActor in
            let (data, _) = try await URLSession.shared.data(from: URL(string: movie.imageUrl)!)
            imageView.image = UIImage(data: data)
        }
    }

    required init?(coder: NSCoder) { fatalError() }
}
