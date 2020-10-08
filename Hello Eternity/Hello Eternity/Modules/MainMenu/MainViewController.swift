import UIKit

class MainViewController: UIViewController {
        
    let viewModel: MainViewModel
    
    private lazy var apodButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .cyan
        button.setTitle("APOD", for: .normal)
        button.addTarget(self, action: #selector(onShowAPOD), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "peacockBlue")
        view.addSubview(apodButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apodButton.frame.size = CGSize(width: 100, height: 50)
        apodButton.center = view.center
    }
    
    //for test
    @objc private func onShowAPOD() {
        self.viewModel.onOpedAPODModule()
    }
}

