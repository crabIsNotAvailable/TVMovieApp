import UIKit

final class ListViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        applyBackgroundGradient()

        setupScroll()
        setupSections()
    }
    private func applyBackgroundGradient() {
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [
            UIColor(red: 0.00, green: 0.22, blue: 0.10, alpha: 1).cgColor, // #01371A
            UIColor(red: 0.01, green: 0.06, blue: 0.02, alpha: 1).cgColor  // #041004
        ]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0)

        gradientLayer.frame = view.bounds
        gradientLayer.zPosition = -1

        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: Scroll
    
    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: Sections
    
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
