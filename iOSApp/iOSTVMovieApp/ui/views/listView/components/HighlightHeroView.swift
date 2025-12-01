import UIKit

final class HighlightHeroView: UIView {

    var onSelect: ((MovieListItem) -> Void)?

    private let feedId: String
    private var movies: [MovieListItem] = []
    private var index = 0
    private var timer: Timer?

    private var imageTask: Task<Void, Never>?

    private let containerStack = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let leftButton = UIButton(type: .system)
    private let rightButton = UIButton(type: .system)

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
        imageTask?.cancel()
    }

    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear

        // Stack
        containerStack.axis = .vertical
        containerStack.spacing = 12
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStack)

        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        // Image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        containerStack.addArrangedSubview(imageView)

        imageView.heightAnchor
            .constraint(equalTo: imageView.widthAnchor, multiplier: 9.0 / 16.0)
            .isActive = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageView.addGestureRecognizer(tap)

        // Title
        titleLabel.textColor = UIColor(red: 0.80, green: 0.66, blue: 0.05, alpha: 1.00)
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerStack.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])

        // Arrows
        setupArrowButton(leftButton, rotate: false)
        setupArrowButton(rightButton, rotate: true)

        imageView.addSubview(leftButton)
        imageView.addSubview(rightButton)

        NSLayoutConstraint.activate([
            leftButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            leftButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),

            rightButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8)
        ])

        leftButton.addTarget(self, action: #selector(showPrevious), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(showNext), for: .touchUpInside)
    }

    // MARK: Arrow Button
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
            await MainActor.run {
                self.movies = list
                self.index = 0
                self.renderMovie(animated: false)
            }
        }
    }

    private func renderMovie(animated: Bool = true) {
        guard !movies.isEmpty else { return }

        let movie = movies[index]
        imageTask?.cancel()

        imageTask = Task {
            guard
                let url = URL(string: movie.imageUrl),
                let (data, _) = try? await URLSession.shared.data(from: url),
                let image = UIImage(data: data)
            else { return }

            await MainActor.run {
                let updates = {
                    self.imageView.image = image
                    self.titleLabel.text = movie.title
                }

                guard animated else {
                    updates()
                    return
                }

                UIView.transition(
                    with: self.containerStack,
                    duration: 0.45,
                    options: [.transitionCrossDissolve, .allowAnimatedContent],
                    animations: updates
                )
            }
        }
    }

    // MARK: - Timer
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 5,
            target: self,
            selector: #selector(showNext),
            userInfo: nil,
            repeats: true
        )
    }

    private func resetTimer() {
        startTimer()
    }

    // MARK: - Actions
    @objc private func showNext() {
        guard !movies.isEmpty else { return }
        index = (index + 1) % movies.count
        renderMovie()
        resetTimer()
    }

    @objc private func showPrevious() {
        guard !movies.isEmpty else { return }
        index = (index - 1 + movies.count) % movies.count
        renderMovie()
        resetTimer()
    }

    @objc private func didTap() {
        guard !movies.isEmpty else { return }
        resetTimer()
        onSelect?(movies[index])
    }
}
