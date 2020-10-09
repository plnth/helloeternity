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
    
    private lazy var contentView: TodayContentView = {
        return TodayContentView(frame: self.view.bounds,
                                title: "Mare Frigoris",
                                date: "08.10.2020",
                                image: Asset.moon.image,
                                explanation: L10n.apodLargeTestString)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Asset.peacockBlue.color
        self.view.addSubview(self.contentScrollView)
        self.contentScrollView.addSubview(self.contentView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.contentScrollView.contentSize = self.contentView.frame.size
    }
    
    init(viewModel: TodayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: L10n.apodTabToday, image: nil, selectedImage: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
