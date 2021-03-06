import UIKit

class GroupedApodsViewController: UIViewController {
    
    private let viewModel: GroupedApodsViewModel
    
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
        self.contentTableView.register(GroupedApodsContentViewCell.self, forCellReuseIdentifier: GroupedApodsContentViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.rightBarButtonItem = nil
        self.viewModel.savedApods = []
        self.contentTableView.reloadData()
    }
    
    init(viewModel: GroupedApodsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: L10n.apodTabSaved, image: nil, selectedImage: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension GroupedApodsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.savedApods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupedApodsContentViewCell.reuseIdentifier, for: indexPath) as? GroupedApodsContentViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = self.viewModel.savedApods[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.openSingleApodModule(with: self.viewModel.savedApods[indexPath.row].title ?? "")
    }
}
