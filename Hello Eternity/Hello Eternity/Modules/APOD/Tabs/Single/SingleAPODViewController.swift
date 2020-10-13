import UIKit

class SingleAPODViewController: UIViewController {
    
    private let viewModel: SingleAPODViewModel
    private let apodTitle: String
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        return scrollView
    }()
    
    private var apodContentView: SingleAPODContentView?
    private let activityIndicator = UIActivityIndicatorView()
    
    init(viewModel: SingleAPODViewModel) {
        
        self.viewModel = viewModel
        self.apodTitle = viewModel.fetchedAPOD?.title ?? ""
        
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: L10n.apodTabToday, image: nil, selectedImage: nil)
    
        switch self.viewModel.configuration {
        case .network:
            self.viewModel.fetchTodayPictureInfo { result in
                switch result {
                case .success(let apodData):
                    self.createContentView(with: apodData)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        case .storage:
            if !self.apodTitle.isEmpty, let apod = self.viewModel.fetchAPODFromStorage(for: self.apodTitle) {
                self.createContentView(with: apod)
                
                if let data = self.viewModel.mediaData,
                   let image = UIImage(data: data) {
                    self.apodContentView?.updateImage(with: image)
                }
            }
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
        self.activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    private func createContentView(with apodData: APOD) {
        self.apodContentView = SingleAPODContentView(
            frame: UIScreen.main.bounds,
            title: apodData.title ?? "",
            date: apodData.date ?? "",
            explanation: apodData.explanation ?? ""
        )
        debugPrint(NSHomeDirectory())
        self.setupImageFromURL(apodData.url!) //TODO
        
        if let contentView = self.apodContentView {
            DispatchQueue.main.async { [weak self] in
                
                guard let `self` = self else { return }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                self.contentScrollView.addSubview(contentView)
                
                self.apodContentView?.saveButton.addTarget(self, action: #selector(self.onSaveAPOD), for: .touchUpInside)
            }
        }
    }
    
    private func setupImageFromURL(_ url: String) {

        self.viewModel.fetchTodayPictureFromURL(pictureURL: url) { [weak self] result in
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
    
    @objc private func onSaveAPOD() {
        self.viewModel.onSaveAPOD()
    }
}
