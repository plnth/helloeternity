import Foundation

protocol SingleAPODModuleInput: class {}
protocol SingleAPODModuleOutput: class {}

final class SingleAPODModule {
    
    var input: SingleAPODModuleInput {
        return self.viewModel
    }
    
    var output: SingleAPODModuleOutput? {
        get {
            return self.viewModel.output
        }
        set {
            self.viewModel.output = newValue
        }
    }
    
    let router: SingleAPODRouter
    private let viewModel: SingleAPODViewModel
    let viewController: SingleAPODViewController
    
    init(configuration: SingleAPODModuleConfiguration) {
        let router = SingleAPODRouter(configuration: configuration)
        let viewModel = SingleAPODViewModel(router: router)
        let viewController = SingleAPODViewController(viewModel: viewModel)
        
        router.viewController = viewController
        self.router = router
        self.viewModel = viewModel
        self.viewController = viewController
    }
}
