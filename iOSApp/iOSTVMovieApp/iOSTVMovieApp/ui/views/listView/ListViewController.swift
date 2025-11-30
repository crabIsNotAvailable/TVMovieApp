import UIKit

final class ListViewController: UIViewController, UIScrollViewDelegate {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private let backgroundGradient = CAGradientLayer()
    private let scrollHintView = UIImageView()

    private var isLandscape: Bool {
        view.bounds.width > view.bounds.height
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = [.top]
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.largeTitleDisplayMode = .never

        applyBackgroundGradient()
        setupScroll()
        setupScrollHint()
        setupSections()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
        updateTopPaddingForOrientation()
        updateScrollHintVisibility()
    }

    private func applyBackgroundGradient() {
        backgroundGradient.colors = [
            UIColor(red: 0.00, green: 0.22, blue: 0.10, alpha: 1).cgColor,
            UIColor(red: 0.01, green: 0.06, blue: 0.02, alpha: 1).cgColor
        ]

        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundGradient.endPoint   = CGPoint(x: 0.5, y: 1.0)

        view.layer.insertSublayer(backgroundGradient, at: 0)
    }

    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self

        stackView.axis = .vertical
        stackView.spacing = 28
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor)
        ])
    }

    private func setupScrollHint() {

        let config = UIImage.SymbolConfiguration(
            pointSize: 22,
            weight: .bold
        )

        scrollHintView.image = UIImage(
            systemName: "chevron.down",
            withConfiguration: config
        )

        scrollHintView.tintColor = .white
        scrollHintView.translatesAutoresizingMaskIntoConstraints = false

        scrollHintView.layer.shadowColor = UIColor.black.cgColor
        scrollHintView.layer.shadowRadius = 1.5
        scrollHintView.layer.shadowOpacity = 1
        scrollHintView.layer.shadowOffset = .zero

        view.addSubview(scrollHintView)

        NSLayoutConstraint.activate([
            scrollHintView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollHintView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -24
            ),
            scrollHintView.widthAnchor.constraint(equalToConstant: 28),
            scrollHintView.heightAnchor.constraint(equalToConstant: 28)
        ])

        startScrollHintAnimation()
    }

    private func startScrollHintAnimation() {
        UIView.animate(
            withDuration: 1.2,
            delay: 0,
            options: [.repeat, .autoreverse, .allowUserInteraction],
            animations: {
                self.scrollHintView.transform =
                    CGAffineTransform(translationX: 0, y: 10)
            }
        )
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isLandscape else { return }

        let hideAfter = view.bounds.height * 0.9
        let shouldShow = scrollView.contentOffset.y < hideAfter

        UIView.animate(withDuration: 0.25) {
            self.scrollHintView.alpha = shouldShow ? 1 : 0
        }
    }

    private func updateScrollHintVisibility() {
        scrollHintView.isHidden = !isLandscape
    }

    private func updateTopPaddingForOrientation() {
        scrollView.contentInset.top = isLandscape ? 0 : 100
    }

    private func setupSections() {

        let hero = HighlightHeroView(feedId: FeedIds.mostSeen.rawValue)
        hero.onSelect = { [weak self] movie in
            self?.navigationController?.pushViewController(
                DetailsViewController(urlPath: movie.urlPath),
                animated: true
            )
        }

        stackView.addArrangedSubview(hero)

        addSection(title: "For deg", feedId: FeedIds.recommended.rawValue, variant: "poster")
        addSection(title: "Vist på festival", feedId: FeedIds.festival.rawValue, variant: "landscape")
        addSection(title: "Alltid film", feedId: FeedIds.focus.rawValue, variant: "landscape")
        addSection(title: "Nyankommende", feedId: FeedIds.newArrivals.rawValue, variant: "landscape")
        addSection(title: "Kjøp eller lei", feedId: FeedIds.buyRent.rawValue, variant: "poster")
    }

    private func addSection(title: String, feedId: String, variant: String) {
        let section = FeedSectionView(
            title: title,
            feedId: feedId,
            variant: variant
        ) { [weak self] movie in
            self?.navigationController?.pushViewController(
                DetailsViewController(urlPath: movie.urlPath),
                animated: true
            )
        }

        stackView.addArrangedSubview(section)
    }
}
