import UIKit

final class DatePickerView: UIView {
    
    var onCancelTapped: (() -> Void)? {
        get {
            return self.datePickerToolBar.onCancelTapped
        }
        set {
            self.datePickerToolBar.onCancelTapped = newValue
        }
    }
    
    var onDoneTapped: (() -> Void)? {
        get {
            return self.datePickerToolBar.onDoneTapped
        }
        set {
            self.datePickerToolBar.onDoneTapped = newValue
        }
    }
    
    let datePickerToolBar = DatePickerToolBar()
    
    lazy var pickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.backgroundColor = Asset.skyBlue.color
        pickerView.datePickerMode = .date
        if #available(iOS 13.4, *) {
            pickerView.preferredDatePickerStyle = .wheels
            //possibly TODO:
//            if #available(iOS 14.0, *) {
//                pickerView.preferredDatePickerStyle = .inline
//            }
        }
        return pickerView
    }()
    
    convenience init() {
        self.init(frame: .zero)
        self.configure()
    }
    
    private func configure() {
        
        self.backgroundColor = .white
        
        self.addSubview(self.datePickerToolBar)
        self.addSubview(self.pickerView)
        
        self.datePickerToolBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            let height = UIApplication.shared.statusBarFrame.height
            make.height.equalTo(height)
        }
        
        self.pickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.datePickerToolBar.snp.bottom)
        }
    }
}
