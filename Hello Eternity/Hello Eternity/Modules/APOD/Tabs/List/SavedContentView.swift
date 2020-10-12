import UIKit

final class SavedContentViewCell: UITableViewCell, ReusableView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupAppearance()
    }
    
    private lazy var _selectedBackgroundView: UIView = {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = Asset.peacockBlue.color
        return view
    }()
    
    private func setupAppearance() {
        self.backgroundColor = Asset.skyBlue.color
        self.accessoryType = .disclosureIndicator
        self.layer.borderWidth = 1
        self.layer.borderColor = Asset.grayBlue.color.cgColor
        self.textLabel?.textColor = Asset.deepBlue.color
        self.textLabel?.font = .boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
        self.selectedBackgroundView = self._selectedBackgroundView
    }
}
