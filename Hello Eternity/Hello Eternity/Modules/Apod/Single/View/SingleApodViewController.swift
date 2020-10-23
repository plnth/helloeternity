import UIKit

class SingleApodViewController: UIViewController {
    
    private let viewModel: SingleApodViewModel
    private let apodTitle: String
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        return scrollView
    }()
    
    private var apodContentView: SingleApodContentView?
    private let activityIndicator = UIActivityIndicatorView()
    
    private lazy var apodSearchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Asset.skyBlue.color
        textField.textColor = Asset.deepBlue.color
        textField.placeholder = L10n.apodSearchPlaceholder
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .always
        textField.delegate = self
        return textField
    }()
    
    init(viewModel: SingleApodViewModel) {
        
        self.viewModel = viewModel
        self.apodTitle = viewModel.fetchedApod?.title ?? ""
        
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: L10n.apodTabToday, image: nil, selectedImage: nil)
    
        switch self.viewModel.configuration {
        case .network:
            self.viewModel.fetchApodData { result in
                switch result {
                case .success(let apodData):
                    self.createContentView(with: apodData)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        case .storage:
            if !self.apodTitle.isEmpty, let apod = self.viewModel.fetchApodFromStorage(for: self.apodTitle) {
                self.createContentView(with: apod)
                
                if let data = self.viewModel.mediaData,
                   let image = UIImage(data: data) {
                    self.apodContentView?.updateImage(with: image)
                }
            }
        case .search:
            self.view.addSubview(self.apodSearchTextField)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Asset.peacockBlue.color
        self.view.addSubview(self.contentScrollView)
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        if case ApodConfiguration.search = self.viewModel.configuration {
            return
        } else {
            self.activityIndicator.startAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if self.apodSearchTextField.superview != nil { //TODO
            self.apodSearchTextField.snp.makeConstraints { make in
                let insetValue = AppConstants.LayoutConstants.commonLeadingTrailingInset
                make.leading.trailing.equalToSuperview().inset(insetValue)
                
                let navBarHeight = UIApplication.shared.statusBarFrame.size.height +
                    (navigationController?.navigationBar.frame.height ?? 0.0)
                make.top.equalToSuperview().inset(navBarHeight + insetValue)
            }
        }
        
        if case ApodConfiguration.network = self.viewModel.configuration {
            self.parent?.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(onSearchForMoreApods)), animated: false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let contentView = self.apodContentView {
            let bottomOffset: CGFloat = self.tabBarController?.tabBar.frame.size.height ?? 2 *  AppConstants.LayoutConstants.commonSpacingOffset
            self.contentScrollView.contentSize = contentView.frame.size
            self.contentScrollView.contentSize.height += bottomOffset
        }
    }
    
    private func createContentView(with apodData: Apod) {
        self.apodContentView = SingleApodContentView(
            frame: UIScreen.main.bounds,
            title: apodData.title ?? "",
            date: apodData.date ?? "",
            explanation: apodData.explanation ?? "",
            configuration: self.viewModel.configuration
        )
        
        self.setupImageFromURL(apodData.url!) //TODO
        
        if let contentView = self.apodContentView {
            DispatchQueue.main.async { [weak self] in
                
                guard let `self` = self else { return }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                self.contentScrollView.addSubview(contentView)
                self.addActions()
            }
        }
    }
    
    private func addActions() {
        switch self.viewModel.configuration {
        case .network, .search:
            self.apodContentView?.saveOrDeleteButton.addTarget(self, action: #selector(self.onSaveApod), for: .touchUpInside)
        case .storage:
            self.apodContentView?.saveOrDeleteButton.addTarget(self, action: #selector(self.onDeleteApod), for: .touchUpInside)
        }
    }
    
    private func setupImageFromURL(_ url: String) {
        
        self.viewModel.fetchApodMedia(fromURL: url) { [weak self] result in
            switch result {
            case .success(let imageData):
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.apodContentView?.updateImage(with: image)
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    @objc private func onSaveApod() {
        self.viewModel.onSaveApod()
    }
    
    @objc private func onDeleteApod() {
        self.viewModel.onDeleteApod()
    }
    
    @objc private func onSearchForMoreApods() {
        self.viewModel.onSearchForMoreApods(configuration: .search)
    }
}

//MARK: - UITextFieldDelegate
extension SingleApodViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard let text = textField.text else {
            self.addDatePicker()
            return
        }
        
        if text.isEmpty {
            self.addDatePicker()
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.clearContent()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    private func addDatePicker() {
        self.view.endEditing(true)
        let pickerController = DatePickerViewController()
        pickerController.delegate = self
        self.presentPopup(viewController: pickerController)
    }
    
    private func searchForApod() {
        
        guard let text = self.apodSearchTextField.text else { return }
        
        self.clearContent()
        self.activityIndicator.startAnimating()
        
        self.viewModel.fetchApodData(forDate: text) { [weak self] result in
            
            guard let `self` = self else { return }
            
            switch result {
            case .success(let apod):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.apodSearchTextField.resignFirstResponder()
                    self.contentScrollView.snp.remakeConstraints { make in
                        make.leading.trailing.bottom.equalToSuperview()
                        make.top.equalTo(self.apodSearchTextField.snp.bottom)
                    }
                    self.createContentView(with: apod)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showFetchErrorMessage()
                }
                debugPrint(error)
            }
        }
    }
    
    private func clearContent() {
        self.apodSearchTextField.resignFirstResponder()
        self.apodContentView?.removeFromSuperview()
        self.apodContentView = nil
    }
    
    private func showFetchErrorMessage() {
        let alert = UIAlertController(
            title: L10n.apodSearchErrorTitle,
            message: L10n.apodSearchErrorMessage,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: L10n.apodSearchErrorOk, style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true) {
            self.clearContent()
        }
    }
}

//MARK: - DatePickerViewDelegate
extension SingleApodViewController: DatePickerViewDelegate {
    func datePicker(_ picker: DatePickerView, didSelectDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: didSelectDate)
        //TODO
        self.apodSearchTextField.text = dateString
        self.apodSearchTextField.resignFirstResponder()
        self.searchForApod()
    }
    
    func datePickerDidCancel(_ picker: DatePickerView) {
        self.apodSearchTextField.resignFirstResponder()
    }
}

//MARK: - PopupPresenter
extension SingleApodViewController: PopupPresenter {
    func presentPopup(viewController: UIViewController) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let `self` = self else { return }
            
            Popup.show(viewController, on: self)
        }
    }
}
