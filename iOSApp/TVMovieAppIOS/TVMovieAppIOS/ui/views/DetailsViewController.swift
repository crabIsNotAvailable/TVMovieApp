import UIKit
import SwiftUI

final class DetailsViewController: UIViewController {

    private let urlPath: String

    private var movie: MovieDetailResponse? {
        didSet { updateUI() }
    }

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let metaStack = UIStackView()
    private let genresStack = UIStackView()
    private let descriptionLabel = UILabel()
    private let castStack = UIStackView()

    private let loader = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()

    // MARK: - Init

    init(urlPath: String) {
        self.urlPath = urlPath
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMovie()
    }

    // MARK: - Setup

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
        contentStack.spacing = 24
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        setupPoster()
        setupLabels()
        setupLoader()
    }

    private func setupPoster() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        contentStack.addArrangedSubview(posterImageView)
    }

    private func setupLabels() {
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textColor = UIColor(AppColors.gold)
        titleLabel.numberOfLines = 0

        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        descriptionLabel.numberOfLines = 0

        metaStack.axis = .horizontal
        metaStack.spacing = 12

        genresStack.axis = .horizontal
        genresStack.spacing = 8

        castStack.axis = .vertical
        castStack.spacing = 6

        [titleLabel, metaStack, genresStack, descriptionLabel, castStack]
            .forEach { contentStack.addArrangedSubview($0) }
    }

    private func setupLoader() {
        loader.color = UIColor(AppColors.gold)
        loader.startAnimating()
        contentStack.addArrangedSubview(loader)

        errorLabel.textColor = .red
        errorLabel.isHidden = true
        contentStack.addArrangedSubview(errorLabel)
    }

    // MARK: - Data

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

    // MARK: - UI Update

    private func updateUI() {
        guard let movie else { return }

        titleLabel.text = movie.title
        descriptionLabel.text = movie.description

        metaStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if let year = movie.year { metaStack.addArrangedSubview(metaLabel(year.description)) }
        if let age = movie.ageRating { metaStack.addArrangedSubview(metaLabel(age)) }
        if let duration = movie.durationMinutes {
            metaStack.addArrangedSubview(metaLabel("\(duration) min"))
        }

        genresStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        movie.genres.forEach {
            let label = pillLabel($0)
            genresStack.addArrangedSubview(label)
        }

        castStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        movie.cast.forEach {
            let label = UILabel()
            label.text = $0
            label.textColor = UIColor.white.withAlphaComponent(0.85)
            castStack.addArrangedSubview(label)
        }

        if let url = URL(string: movie.posterUrl ?? "") {
            loadImage(from: url)
        }
    }

    // MARK: - Helpers

    private func metaLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }

    private func pillLabel(_ text: String) -> UILabel {
        let label = PaddingLabel()
        label.text = text
        label.backgroundColor = UIColor(AppColors.gold)
        label.textColor = .black
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        return label
    }

    private func loadImage(from url: URL) {
        Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            posterImageView.image = UIImage(data: data)
        }
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}

