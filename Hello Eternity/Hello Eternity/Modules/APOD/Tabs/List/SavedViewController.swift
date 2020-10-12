import UIKit

class SavedViewController: UIViewController {
    
    private let viewModel: SavedViewModel
    
    private lazy var contentTableView: UITableView = {
        
        let tableView = UITableView(frame: UIScreen.main.bounds)
        tableView.separatorStyle = .none
        tableView.backgroundColor = Asset.peacockBlue.color
        tableView.bounces = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.peacockBlue.color
        view.addSubview(self.contentTableView)
        self.contentTableView.register(SavedContentViewCell.self, forCellReuseIdentifier: SavedContentViewCell.reuseIdentifier)
    }
    
    init(viewModel: SavedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: L10n.apodTabSaved, image: nil, selectedImage: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.savedAPODs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedContentViewCell.reuseIdentifier, for: indexPath) as? SavedContentViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = self.viewModel.savedAPODs[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.openSingleAPODModule()
    }
}
