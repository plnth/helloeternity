import UIKit

class SavedViewController: UIViewController {
    
    private let viewModel: SavedViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.peacockBlue.color
    }
    
    init(viewModel: SavedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: "Saved", image: nil, selectedImage: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
