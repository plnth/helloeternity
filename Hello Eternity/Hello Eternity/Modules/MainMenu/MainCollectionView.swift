import UIKit
import SnapKit

final class MainCollectionView: UICollectionView {
    
    convenience init(collectionViewLayout: UICollectionViewLayout) {
        self.init(frame: UIScreen.main.bounds, collectionViewLayout: collectionViewLayout)
    }
}
