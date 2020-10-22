import UIKit

class DatePickerViewController: UIViewController {
    
    private lazy var picker: DatePickerView = {
        let picker = DatePickerView()
        picker.layer.cornerRadius = AppConstants.LayoutConstants.commonCornerRadius
        picker.layer.masksToBounds = true
        
        picker.onDoneTapped = { [weak self] in
            guard let `self` = self else { return }
            
            self.delegate?.datePicker(picker, didSelectDate: picker.pickerView.date) //TODO
            self.dismiss(animated: true, completion: nil)
        }
        
        picker.onCancelTapped = { [weak self] in
            guard let `self` = self else { return }
            
            self.delegate?.datePickerDidCancel(picker)
            self.dismiss(animated: true, completion: nil)
        }
        
        return picker
    }()
    
    weak var delegate: DatePickerViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    private func configure() {
        self.view.backgroundColor = Asset.shadowGray.color
        self.view.addSubview(self.picker)
        
        self.picker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppConstants.LayoutConstants.commonLeadingTrailingInset)
            make.bottom.equalToSuperview().inset(3 * AppConstants.LayoutConstants.commonSpacingOffset)
            make.top.lessThanOrEqualToSuperview().inset(UIScreen.main.bounds.height / 2)
        }
    }
}

extension DatePickerViewController: PopupDelegate {
    var popupView: UIView {
        return self.picker
    }
    
    var blurEffectStyle: UIBlurEffect.Style {
        return .extraLight
    }
    
    var initialScaleAmount: CGFloat {
        return 0.2
    }
    
    var animationDuration: TimeInterval {
        return 0.5
    }
}
