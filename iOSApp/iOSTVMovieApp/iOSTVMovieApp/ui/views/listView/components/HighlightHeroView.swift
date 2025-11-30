import UIKit

final class HighlightHeroView: UIView {

    // MARK: - Public
    var onSelect: ((MovieListItem) -> Void)?

    // MARK: - Private
    private let feedId: String
    private var movies: [MovieListItem] = []
    private var index = 0
    private var timer: Timer?

    // MARK: - UI
    private let imageView = UIImageView()
    private let leftButton = UIButton(type: .system)
    private let rightButton = UIButton(type: .system)

    // MARK: - Init

    init(feedId: String) {
        self.feedId = feedId
        super.init(frame: .zero)
        setupUI()
        loadMovies()
        startTimer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        timer?.invalidate()
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .black
        clipsToBounds = true

        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageView.addGestureRecognizer(tap)

        setupArrowButton(leftButton, rotate: false)
        setupArrowButton(rightButton, rotate: true)

        leftButton.addTarget(self, action: #selector(showPrevious), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(showNext), for: .touchUpInside)

        addSubview(leftButton)
        addSubview(rightButton)

        NSLayoutConstraint.activate([
            leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),

            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])

        // 16:9 ratio
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 9.0 / 16.0).isActive = true
    }

    private func setupArrowButton(_ button: UIButton, rotate: Bool) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 20

        if rotate {
            button.transform = CGAffineTransform(rotationAngle: .pi)
        }

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // MARK: - Data

    private func loadMovies() {
        Task {
            let list = await MovieRepository.shared.getFeedMovies(feedId)
            self.movies = list
            self.index = 0
            showCurrent()
        }
    }

    private func showCurrent() {
        guard !movies.isEmpty else { return }
        loadImage(urlString: movies[index].imageUrl)
    }

    private func loadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        Task {
            do {
                let result = try await URLSession.shared.data(from: url)
                let data = result.0
                self.imageView.image = UIImage(data: data)
            } catch {
                // ignore
            }
        }
    }

    // MARK: - Timer

    private func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 5,
            target: self,
            selector: #selector(showNext),
            userInfo: nil,
            repeats: true
        )
    }

    // MARK: - Actions

    @objc private func showNext() {
        guard !movies.isEmpty else { return }
        index = (index + 1) % movies.count
        showCurrent()
    }

    @objc private func showPrevious() {
        guard !movies.isEmpty else { return }
        index = (index - 1 + movies.count) % movies.count
        showCurrent()
    }

    @objc private func didTap() {
        guard !movies.isEmpty else { return }
        onSelect?(movies[index])
    }
}
