import UIKit

// Gives layout logic to movies in FeedSectionView

extension FeedSectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCollectionViewCell.reuseId,
            for: indexPath
        ) as! MovieCollectionViewCell

        let movie = movies[indexPath.item]
        let imageUrl = toMovieImage(movie.imageUrl, type: variant)
        cell.configure(with: imageUrl)

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        onSelect(movies[indexPath.item])
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        if variant == "poster" {
            return CGSize(width: 320, height: 480)
        } else {
            return CGSize(width: 640, height: 360)
        }
    }
}
