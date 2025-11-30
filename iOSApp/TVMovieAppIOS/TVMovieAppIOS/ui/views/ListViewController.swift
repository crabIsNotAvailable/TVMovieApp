//
//  ListViewController.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 29/11/2025.
//


import UIKit

final class ListViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setupScroll()
        setupSections()
    }

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

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupSections() {
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
