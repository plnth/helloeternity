import UIKit
import SnapKit

final class MainCollectionViewCell: UICollectionViewCell, ReusableView {
    
    private lazy var roundedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.skyBlue.color
        view.layer.cornerRadius = 10
        view.layer.borderColor = Asset.grayBlue.color.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textColor = Asset.deepBlue.color
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        setupAppearance()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.roundedBackgroundView)
        self.roundedBackgroundView.addSubview(self.titleLabel)
    }
    
    private func setupAppearance() {
        self.roundedBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints { make in
            make.edges.lessThanOrEqualToSuperview()
            make.center.equalToSuperview()
        }
        self.titleLabel.text = L10n.mainMenuApod
    }
}

final class MainCollectionView: UICollectionView {
    
    convenience init(collectionViewLayout: UICollectionViewLayout) {
        self.init(frame: UIScreen.main.bounds, collectionViewLayout: collectionViewLayout)
        self.setupAppearance()
    }
    
    private func setupAppearance() {
        self.backgroundColor = Asset.peacockBlue.color
    }
}
