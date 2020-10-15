import UIKit

class ApodViewController: UITabBarController {
    
    private let viewModel: ApodViewModel
    
    private lazy var todayController: SingleApodViewController = {
        //TODO: naming
        let viewModel = self.viewModel.createTodayViewModel()
        let vc = SingleApodViewController(viewModel: viewModel)
        return vc
    }()

    private lazy var savedController: GroupedApodsViewController = {
        let viewModel = self.viewModel.createSavedViewModel()
        let vc = GroupedApodsViewController(viewModel: viewModel)
        return vc
    }()
    
    init(viewModel: ApodViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.skyBlue.color
        self.viewControllers = [self.todayController, self.savedController]
    }
}
