import UIKit

class APODViewController: UITabBarController {
    
    private let viewModel: APODViewModel
    
    private lazy var todayController: SingleAPODViewController = {
        //TODO: naming
        let viewModel = self.viewModel.createTodayViewModel()
        let vc = SingleAPODViewController(viewModel: viewModel)
        return vc
    }()
    
    private lazy var savedController: SavedViewController = {
        let viewModel = self.viewModel.createSavedViewModel()
        let vc = SavedViewController(viewModel: viewModel)
        return vc
    }()
    
    init(viewModel: APODViewModel) {
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
