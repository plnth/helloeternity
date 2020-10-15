import UIKit

class ApodViewController: UITabBarController {
    
    private let viewModel: ApodViewModel
    
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
    }
}
