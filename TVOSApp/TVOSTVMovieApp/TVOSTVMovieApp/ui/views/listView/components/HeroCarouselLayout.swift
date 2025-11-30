import UIKit

final class HeroCarouselLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }

        scrollDirection = .horizontal

        let height = collectionView.bounds.height
        let width = height * 16 / 9

        itemSize = CGSize(width: width, height: height * 0.92)
        minimumLineSpacing = 80

        let sideInset = (collectionView.bounds.width - itemSize.width) / 2
        sectionInset = UIEdgeInsets(
            top: 0,
            left: sideInset,
            bottom: 0,
            right: sideInset
        )
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}
