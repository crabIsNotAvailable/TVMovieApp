//
//  FeedSectionView.swift
//  TVMovieAppIOS
//
//  Created by Maren Rødland on 29/11/2025.
//


import UIKit

final class FeedSectionView: UIView {

    private let titleLabel = UILabel()
    private let collectionView: UICollectionView

    var movies: [MovieListItem] = []
    let variant: String
    let onSelect: (MovieListItem) -> Void

    init(
        title: String,
        feedId: String,
        variant: String,
        onSelect: @escaping (MovieListItem) -> Void
    ) {
        self.variant = variant
        self.onSelect = onSelect

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12

        self.collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        super.init(frame: .zero)

        titleLabel.text = title
        setup()
        loadMovies(feedId)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        titleLabel.font = .boldSystemFont(ofSize: 40)
        titleLabel.textColor = UIColor(red: 0.80, green: 0.66, blue: 0.05, alpha: 1.00)

        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.reuseId
        )

        collectionView.delegate = self
        collectionView.dataSource = self

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: cellHeight),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private var cellHeight: CGFloat {
        variant == "poster" ? 520 : 390
    }

    // MARK: - Data

    private func loadMovies(_ feedId: String) {
        Task {
            movies = await MovieRepository.shared.getFeedMovies(feedId)
            collectionView.reloadData()
        }
    }
}
