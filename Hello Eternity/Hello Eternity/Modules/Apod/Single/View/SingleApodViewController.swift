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
    
    //TODO: validation
    private lazy var apodSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barTintColor = Asset.skyBlue.color
        searchBar.placeholder = L10n.apodSearchPlaceholder
        searchBar.tintColor = Asset.deepBlue.color
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        return searchBar
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
            self.view.addSubview(self.apodSearchBar)
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
        
        if self.apodSearchBar.superview != nil { //TODO
            self.apodSearchBar.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                
                let navBarHeight = UIApplication.shared.statusBarFrame.size.height +
                   (navigationController?.navigationBar.frame.height ?? 0.0)
                make.top.equalToSuperview().inset(navBarHeight)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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

//MARK: - UISearchBarDelegate
extension SingleApodViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = self.apodSearchBar.text, text.isEmpty {
            self.clearContent()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = self.apodSearchBar.text else { return }
        self.clearContent()
        self.activityIndicator.startAnimating()
        
        self.viewModel.fetchApodData(forDate: text) { [weak self] result in
            
            guard let `self` = self else { return }
            
            switch result {
            case .success(let apod):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.apodSearchBar.resignFirstResponder()
                    self.contentScrollView.snp.remakeConstraints { make in
                        make.leading.trailing.bottom.equalToSuperview()
                        make.top.equalTo(self.apodSearchBar.snp.bottom)
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
