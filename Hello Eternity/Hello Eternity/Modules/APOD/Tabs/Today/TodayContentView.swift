import UIKit

final class TodayContentView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.deepBlue.color
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.deepBlue.color
        label.textAlignment = .left
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let saveHDImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Asset.skyBlue.color
        button.setTitle(L10n.apodSaveHDImage, for: .normal)
        button.setTitleColor(Asset.deepBlue.color, for: .normal)
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
        return textView
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Asset.skyBlue.color
        button.setTitle(L10n.apodSave, for: .normal)
        button.setTitleColor(Asset.deepBlue.color, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    convenience init(frame: CGRect, title: String, date: String, image: UIImage, explanation: String) {
        self.init(frame: frame)
        
        self.addSubviews()
        
        self.titleLabel.text = title
        self.dateLabel.text = date
        self.imageView.image = image
        self.explanationTextView.text = explanation
        self.setupSubviews()
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
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.greaterThanOrEqualTo(50)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(self.titleLabel)
            make.width.equalTo(self.titleLabel).dividedBy(2)
            make.height.equalTo(25)
        }
        
        self.imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.dateLabel.snp.bottom).offset(5)
            make.height.lessThanOrEqualTo(300)
        }
        
        self.saveHDImageButton.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        
        //TODO
        self.explanationTextView.snp.makeConstraints { make in
            make.top.equalTo(self.saveHDImageButton.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        self.saveButton.snp.makeConstraints { make in
            make.top.equalTo(self.explanationTextView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalToSuperview().dividedBy(4)
        }
    }
}
