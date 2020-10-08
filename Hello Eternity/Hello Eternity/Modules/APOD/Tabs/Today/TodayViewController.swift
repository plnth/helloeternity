import UIKit

class TodayViewController: UIViewController {
    
    private let viewModel: TodayViewModel
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.bouncesZoom = false
        
        return scrollView
    }()
    
    private lazy var contentView: TodayContentView = {
        return TodayContentView(frame: self.view.bounds,
                                title: "Mare Frigoris",
                                date: "08.10.2020",
                                image: Asset.moon.image,
                                explanation: """
            Lighter than typically dark, smooth, mare the Mare Frigoris lies in the far lunar north. Also known as the Sea of Cold, it stretches across the familiar lunar nearside in this close up of the waxing gibbous Moon's north polar region. Dark-floored, 95 kilometer wide crater Plato is just left of the center. Sunlit peaks of the lunar Alps (Montes Alpes) are highlighted below and right of Plato, between the more southern Mare Imbrium (Sea of Rains) and Mare Frigoris. The prominent straight feature cutting through the mountains is the lunar Alpine Valley (Vallis Alpes). Joining the Mare Imbrium and Mare Frigoris, the lunar valley is about 160 kilometers long and up to 10 kilometers wide.
            """)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Asset.peacockBlue.color
        self.view.addSubview(self.contentScrollView)
        self.contentScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.contentScrollView.addSubview(self.contentView)
    }
    
    init(viewModel: TodayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: "Today", image: nil, selectedImage: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
