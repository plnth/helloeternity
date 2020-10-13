import UIKit

final class SingleAPODContentView: UIView {
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.deepBlue.color
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.deepBlue.color
        label.textAlignment = .left
        label.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addSubview(self.activityIndicator)
        return imageView
    }()
    
    let saveHDImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Asset.skyBlue.color
        button.setTitle(L10n.apodSaveHDImage, for: .normal)
        button.setTitleColor(Asset.deepBlue.color, for: .normal)
        button.setTitleColor(Asset.purpleBlue.color, for: .highlighted)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var explanationTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = Asset.peacockBlue.color
        textView.textAlignment = .justified
        textView.textColor = Asset.deepBlue.color
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
        return textView
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Asset.skyBlue.color
        button.setTitle(L10n.apodSave, for: .normal)
        button.setTitleColor(Asset.deepBlue.color, for: .normal)
        button.setTitleColor(Asset.purpleBlue.color, for: .highlighted)
        button.layer.cornerRadius = 8
        return button
    }()
    
    convenience init(frame: CGRect, title: String, date: String, explanation: String) {
        self.init(frame: frame)
        
        self.addSubviews()
        
        self.titleLabel.text = title
        self.dateLabel.text = date
        
        self.explanationTextView.text = explanation
        self.setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let textHeight = self.explanationTextView.contentSize.height
        self.explanationTextView.frame.size.height = textHeight
        let difference = self.explanationTextView.frame.size.height - (self.frame.size.height - self.explanationTextView.frame.origin.y)
        self.frame.size.height += difference + saveButton.frame.size.height + 2 * AppConstants.LayoutConstants.commonSpacingOffset
    }
    
    private func addSubviews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.dateLabel)
        self.addSubview(self.imageView)
        self.addSubview(self.saveHDImageButton)
        self.addSubview(self.explanationTextView)
        self.addSubview(self.saveButton)
    }
    
    private func setupSubviews() {
        
        let hvConvUnit = AppConstants.LayoutConstants.hvConvUnit
        let commonSpacingOffset = AppConstants.LayoutConstants.commonSpacingOffset
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(2 * hvConvUnit)
            make.leading.trailing.equalToSuperview().inset(5 * hvConvUnit)
            make.height.greaterThanOrEqualTo(6 * hvConvUnit)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(commonSpacingOffset)
            make.leading.equalTo(self.titleLabel)
            make.width.equalTo(self.titleLabel).dividedBy(2)
            make.height.equalTo(3 * hvConvUnit)
        }
        
        self.imageView.snp.makeConstraints { make in
            let width = UIScreen.main.bounds.width * 0.5
            make.centerX.equalToSuperview()
            make.top.equalTo(self.dateLabel.snp.bottom).offset(commonSpacingOffset)
            make.width.height.equalTo(width)
        }
        
        self.activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.activityIndicator.startAnimating()
        
        self.saveHDImageButton.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(commonSpacingOffset)
            make.centerX.equalToSuperview()
            make.height.equalTo(4 * hvConvUnit)
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        
        self.explanationTextView.snp.makeConstraints { make in
            make.top.equalTo(self.saveHDImageButton.snp.bottom).offset(commonSpacingOffset)
            make.leading.trailing.equalToSuperview().inset(AppConstants.LayoutConstants.commonLeadingTrailingInset)
            make.height.greaterThanOrEqualTo(1)
        }
        
        self.saveButton.snp.makeConstraints { make in
            make.top.equalTo(self.explanationTextView.snp.bottom).offset(commonSpacingOffset)
            make.centerX.equalToSuperview()
            make.height.equalTo(4 * hvConvUnit)
            make.width.equalToSuperview().dividedBy(4)
        }
    }
    
    func updateImage(with image: UIImage) {
        
        let imageRatio = image.size.width / image.size.height
        
        self.imageView.snp.remakeConstraints { make in
            let width = UIScreen.main.bounds.width * 0.9
            make.centerX.equalToSuperview()
            make.top.equalTo(self.dateLabel.snp.bottom).offset(AppConstants.LayoutConstants.commonSpacingOffset)
            make.width.equalTo(width)
            make.height.equalTo(width / imageRatio)
        }
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        self.imageView.image = image
    }
}
