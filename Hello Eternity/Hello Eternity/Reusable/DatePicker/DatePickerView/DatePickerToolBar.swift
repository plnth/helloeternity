import UIKit

final class DatePickerToolBar: UIToolbar {
    
    var onCancelTapped: (() -> Void)? = nil
    var onDoneTapped: (() -> Void)? = nil
}

extension DatePickerToolBar {
    
    convenience init() {
        self.init(frame: .zero)
        self.configure()
    }
    
    private func configure() {
        
        let cancelButton = UIBarButtonItem(title: L10n.cancel, style: .plain, target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(title: L10n.done, style: .plain, target: self, action: #selector(doneButtonTepped))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
    }
    
    @objc private func cancelButtonTapped() {
        self.onCancelTapped?()
    }
    
    @objc private func doneButtonTepped() {
        self.onDoneTapped?()
    }
}
