import UIKit

class TodayViewController: UIViewController {
    
    private let viewModel: TodayViewModel
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        return scrollView
    }()
    
    private var apodContentView: TodayContentView?
    private let activityIndicator = UIActivityIndicatorView()
    
    init(viewModel: TodayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: L10n.apodTabToday, image: nil, selectedImage: nil)
    
        self.viewModel.fetchTodayPictureInfo { (data, error) in
            guard let apodData = data else {
                if let error = error {
                    debugPrint(error)
                }
                return
            }
            
            self.createContentView(with: apodData)
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
            self.contentScrollView.contentSize = contentView.frame.size
        }
    }
    
    private func createContentView(with apodData: APODData) {
        self.apodContentView = TodayContentView(
            frame: UIScreen.main.bounds,
            title: apodData.title,
            date: apodData.date,
            explanation: apodData.explanation
        )
        
        self.setupImageFromURL(apodData.url)
        
        if let contentView = self.apodContentView {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
                self?.contentScrollView.addSubview(contentView)
            }
        }
    }
    
    private func setupImageFromURL(_ url: String) {

        self.viewModel.fetchTodayPictureFromURL(pictureURL: url) { [weak self] (data, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.apodContentView?.updateImage(with: image)
                }
            } else if let error = error {
                debugPrint(error)
            }
        }
    }
}
