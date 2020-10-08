import Foundation

protocol APODModuleInput: class {}
protocol APODModuleOutput: class {}

final class APODModule {
    
    var input: APODModuleInput {
        return viewModel
    }
    
    var output: APODModuleOutput? {
        get {
            return viewModel.output
        }
        set {
            viewModel.output = newValue
        }
    }
    
    let router: APODRouter
    private let viewModel: APODViewModel
    let viewController: APODViewController
    
    init() {
        let router = APODRouter()
        let viewModel = APODViewModel(router: router)
        let viewController = APODViewController(viewModel: viewModel)
        
        router.viewController = viewController
        self.router = router
        self.viewController = viewController
        self.viewModel = viewModel
    }
}
