import UIKit

final class FocusableButton: UIButton {
    override var canBecomeFocused: Bool { true }
}

final class DetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let urlPath: String
    private var movie: MovieDetailResponse? { didSet { updateUI() } }

    // MARK: UI

    private let backButton = FocusableButton(type: .custom)

    private let posterContainer = UIView()
    private let posterImageView = UIImageView()
    private let playButtonContainer = UIView()
    private let playIconView = UIImageView()


    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let titleLabel = UILabel()
    private let metaStack = UIStackView()

    private let genresContainer = UIView()
    private let genresStack = UIStackView()

    private let descriptionLabel = UILabel()

    private let castHeader = UILabel()
    private let castCollection: UICollectionView

    private let loader = UIActivityIndicatorView(style: .large)

    // MARK: Init

    init(urlPath: String) {
        self.urlPath = urlPath

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 24
        castCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMovie()
    }

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        [backButton]
    }

    // MARK: Setup

    private func setupUI() {
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupBackButton()
        setupPoster()
        setupScrollView()
        setupText()
        setupCast()
        setupLoader()
    }

    // MARK: Back Button

    private func setupBackButton() {
        let image = UIImage(systemName: "chevron.left")?
            .withConfiguration(
                UIImage.SymbolConfiguration(pointSize: 34, weight: .bold)
            )

        backButton.setImage(image, for: .normal)
        backButton.tintColor = .black
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 22

        backButton.addTarget(self, action: #selector(goBack), for: .primaryActionTriggered)

        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: Poster

    private func setupPoster() {
        view.addSubview(posterContainer)
        posterContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            posterContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            posterContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            posterContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])

        posterContainer.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 18

        NSLayoutConstraint.activate([
            posterImageView.centerXAnchor.constraint(equalTo: posterContainer.centerXAnchor),
            posterImageView.centerYAnchor.constraint(equalTo: posterContainer.centerYAnchor),

            posterImageView.widthAnchor.constraint(
                lessThanOrEqualTo: posterContainer.widthAnchor,
                multiplier: 0.9
            ),
            posterImageView.heightAnchor.constraint(
                equalTo: posterImageView.widthAnchor,
                multiplier: 9.0 / 16.0
            ),
            posterImageView.heightAnchor.constraint(
                lessThanOrEqualTo: posterContainer.heightAnchor
            )
        ])
        
        // Fake Play Button
        
        playButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        playButtonContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        playButtonContainer.layer.cornerRadius = 48
        playButtonContainer.clipsToBounds = true

        posterContainer.addSubview(playButtonContainer)

        playIconView.image = UIImage(systemName: "play.fill")
        playIconView.tintColor = .white
        playIconView.contentMode = .scaleAspectFit
        playIconView.translatesAutoresizingMaskIntoConstraints = false

        playButtonContainer.addSubview(playIconView)

        NSLayoutConstraint.activate([
            playButtonContainer.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            playButtonContainer.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            playButtonContainer.widthAnchor.constraint(equalToConstant: 96),
            playButtonContainer.heightAnchor.constraint(equalToConstant: 96),

            playIconView.centerXAnchor.constraint(equalTo: playButtonContainer.centerXAnchor),
            playIconView.centerYAnchor.constraint(equalTo: playButtonContainer.centerYAnchor),
            playIconView.widthAnchor.constraint(equalToConstant: 32),
            playIconView.heightAnchor.constraint(equalToConstant: 32)
        ])

    }


    // MARK: Scrollable Content

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: posterContainer.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentStack.axis = .vertical
        contentStack.spacing = 14
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.isLayoutMarginsRelativeArrangement = true

        let sidePadding = view.bounds.width * 0.20
        contentStack.layoutMargins = UIEdgeInsets(
            top: 32,
            left: sidePadding,
            bottom: 20,
            right: sidePadding
        )

        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: Text

    private func setupText() {
        titleLabel.font = .boldSystemFont(ofSize: 38)
        titleLabel.textColor = UIColor(red: 0.80, green: 0.66, blue: 0.05, alpha: 1.00)
        titleLabel.numberOfLines = 0

        descriptionLabel.font = .systemFont(ofSize: 22)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0

        metaStack.axis = .horizontal
        metaStack.spacing = 12

        genresStack.axis = .horizontal
        genresStack.spacing = 10
        genresStack.alignment = .leading

        genresContainer.addSubview(genresStack)
        genresStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            genresStack.topAnchor.constraint(equalTo: genresContainer.topAnchor),
            genresStack.bottomAnchor.constraint(equalTo: genresContainer.bottomAnchor),
            genresStack.leadingAnchor.constraint(equalTo: genresContainer.leadingAnchor)
        ])

        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(metaStack)
        contentStack.addArrangedSubview(genresContainer)
        contentStack.addArrangedSubview(descriptionLabel)
    }

    // MARK: Cast

    private func setupCast() {
        castHeader.text = "CAST"
        castHeader.font = .boldSystemFont(ofSize: 22)
        castHeader.textColor = UIColor(red: 0.80, green: 0.66, blue: 0.05, alpha: 1.00)

        castCollection.backgroundColor = .clear
        castCollection.isScrollEnabled = false
        castCollection.dataSource = self
        castCollection.delegate = self
        castCollection.register(CastCell.self, forCellWithReuseIdentifier: CastCell.reuseId)
        castCollection.heightAnchor.constraint(equalToConstant: 160).isActive = true

        contentStack.addArrangedSubview(castHeader)
        contentStack.addArrangedSubview(castCollection)
    }

    private func setupLoader() {
        loader.color = UIColor(red: 0.80, green: 0.66, blue: 0.05, alpha: 1.00)
        loader.startAnimating()
        contentStack.addArrangedSubview(loader)
    }

    // MARK: Data

    private func fetchMovie() {
        Task {
            movie = try? await MovieApi.fetchMovieDetail(urlPath)
            loader.stopAnimating()
        }
    }

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
        movie.genres.forEach { genresStack.addArrangedSubview(pillLabel($0)) }

        castCollection.reloadData()
        if let urlString = movie.posterUrl,
           let url = URL(string: urlString) {

            Task { @MainActor in
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    posterImageView.image = UIImage(data: data)
                } catch {
                    print("Failed to load poster image:", error)
                }
            }
        }

    }

    private func metaLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white.withAlphaComponent(0.85)
        label.text = text
        return label
    }

    private func pillLabel(_ text: String) -> UILabel {
        let label = PaddingLabel()
        label.text = "  \(text)  "
        label.font = .boldSystemFont(ofSize: 18)
        label.backgroundColor = UIColor(red: 0.80, green: 0.66, blue: 0.05, alpha: 1.00)
        label.textColor = .black
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        return label
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - Cast Grid

extension DetailsViewController {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        movie?.cast.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CastCell.reuseId,
            for: indexPath
        ) as! CastCell

        cell.label.text = movie?.cast[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 260, height: 32)
    }
}
final class CastCell: UICollectionViewCell {

    static let reuseId = "CastCell"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.font = .systemFont(ofSize: 22)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
