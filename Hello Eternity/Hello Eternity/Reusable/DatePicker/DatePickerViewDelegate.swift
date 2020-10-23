import Foundation

protocol DatePickerViewDelegate: class {
    func datePicker(_ picker: DatePickerView, didSelectDate: Date)
    func datePickerDidCancel(_ picker: DatePickerView)
}
