import UIKit
import SwiftUI

final class DetailsViewController: UIViewController {

    private let urlPath: String
    private var movie: MovieDetailResponse? { didSet { updateUI() } }

    // MARK: UI

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let posterContainer = UIView()
    private let posterImageView = UIImageView()

    private let playButtonContainer = UIView()
    private let playIconView = UIImageView()

    private let titleLabel = UILabel()
    private let metaStack = UIStackView()

    private let genresContainer = UIView()
    private let genresStack = UIStackView()

    private let descriptionLabel = UILabel()

    private let castHeader = UILabel()
    private let castStack = UIStackView()

    private let loader = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()

    // MARK: Init

    init(urlPath: String) {
        self.urlPath = urlPath
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMovie()
    }

    // MARK: Setup

    private func setupUI() {
        view.backgroundColor = .black
        navigationItem.largeTitleDisplayMode = .never

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 40, right: 20)

        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor)
        ])

        setupPoster()
        setupText()
        setupCast()
        setupLoader()
    }

    // MARK: Poster (true 16:9 + play button)

    private func setupPoster() {
        posterContainer.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(posterContainer)

        NSLayoutConstraint.activate([
            posterContainer.heightAnchor.constraint(
                equalTo: posterContainer.widthAnchor,
                multiplier: 9.0 / 16.0
            )
        ])

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterContainer.addSubview(posterImageView)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: posterContainer.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: posterContainer.bottomAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: posterContainer.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: posterContainer.trailingAnchor)
        ])

        // 🎬 Fake Play Button (circle + fixed triangle)

        playButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        playButtonContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        playButtonContainer.layer.cornerRadius = 36
        playButtonContainer.clipsToBounds = true

        posterContainer.addSubview(playButtonContainer)

        playIconView.image = UIImage(systemName: "play.fill")
        playIconView.tintColor = .white
        playIconView.contentMode = .scaleAspectFit
        playIconView.translatesAutoresizingMaskIntoConstraints = false

        playButtonContainer.addSubview(playIconView)

        NSLayoutConstraint.activate([
            playButtonContainer.centerXAnchor.constraint(equalTo: posterContainer.centerXAnchor),
            playButtonContainer.centerYAnchor.constraint(equalTo: posterContainer.centerYAnchor),
            playButtonContainer.widthAnchor.constraint(equalToConstant: 72),
            playButtonContainer.heightAnchor.constraint(equalToConstant: 72),

            playIconView.centerXAnchor.constraint(equalTo: playButtonContainer.centerXAnchor),
            playIconView.centerYAnchor.constraint(equalTo: playButtonContainer.centerYAnchor),
            playIconView.widthAnchor.constraint(equalToConstant: 26),
            playIconView.heightAnchor.constraint(equalToConstant: 26)
        ])
    }

    // MARK: Text

    private func setupText() {
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textColor = UIColor(AppColors.gold)
        titleLabel.numberOfLines = 0

        descriptionLabel.font = .systemFont(ofSize: 17)
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        descriptionLabel.numberOfLines = 0

        metaStack.axis = .horizontal
        metaStack.spacing = 12

        genresStack.axis = .horizontal
        genresStack.spacing = 8
        genresStack.alignment = .leading
        genresStack.translatesAutoresizingMaskIntoConstraints = false

        // ✅ KEY FIX: container prevents stretching
        genresContainer.translatesAutoresizingMaskIntoConstraints = false
        genresContainer.addSubview(genresStack)

        NSLayoutConstraint.activate([
            genresStack.topAnchor.constraint(equalTo: genresContainer.topAnchor),
            genresStack.leadingAnchor.constraint(equalTo: genresContainer.leadingAnchor),
            genresStack.bottomAnchor.constraint(equalTo: genresContainer.bottomAnchor)
        ])

        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(metaStack)
        contentStack.addArrangedSubview(genresContainer)
        contentStack.addArrangedSubview(descriptionLabel)
    }

    // MARK: Cast

    private func setupCast() {
        castHeader.text = "Cast"
        castHeader.font = .boldSystemFont(ofSize: 20)
        castHeader.textColor = UIColor(AppColors.gold)

        castStack.axis = .vertical
        castStack.spacing = 6

        contentStack.addArrangedSubview(castHeader)
        contentStack.addArrangedSubview(castStack)
    }

    // MARK: Loader

    private func setupLoader() {
        loader.color = UIColor(AppColors.gold)
        loader.startAnimating()
        contentStack.addArrangedSubview(loader)

        errorLabel.textColor = .red
        errorLabel.isHidden = true
        contentStack.addArrangedSubview(errorLabel)
    }

    // MARK: Data

    private func fetchMovie() {
        Task {
            do {
                movie = try await MovieApi.fetchMovieDetail(urlPath)
            } catch {
                showError("Could not load movie")
            }
            loader.stopAnimating()
        }
    }

    // MARK: Update UI

    private func updateUI() {
        guard let movie else { return }

        titleLabel.text = movie.title
        descriptionLabel.text = movie.description

        metaStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if let year = movie.year { metaStack.addArrangedSubview(metaLabel("\(year)")) }
        if let age = movie.ageRating { metaStack.addArrangedSubview(metaLabel(age)) }
        if let duration = movie.durationMinutes {
            metaStack.addArrangedSubview(metaLabel("\(duration) min"))
        }

        genresStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        movie.genres.forEach {
            genresStack.addArrangedSubview(pillLabel($0))
        }

        castStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        movie.cast.forEach {
            let label = UILabel()
            label.text = $0
            label.font = .systemFont(ofSize: 16)
            label.textColor = UIColor.white.withAlphaComponent(0.85)
            castStack.addArrangedSubview(label)
        }

        if let url = URL(string: movie.posterUrl ?? "") {
            loadImage(from: url)
        }
    }

    // MARK: Helpers

    private func metaLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.text = text
        return label
    }

    private func pillLabel(_ text: String) -> UILabel {
        let label = PaddingLabel()
        label.text = " \(text) "
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.backgroundColor = UIColor(AppColors.gold)
        label.textColor = .black
        label.layer.cornerRadius = 10
        label.clipsToBounds = true

        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        return label
    }

    private func loadImage(from url: URL) {
        Task { @MainActor in
            let (data, _) = try await URLSession.shared.data(from: url)
            posterImageView.image = UIImage(data: data)
        }
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}
