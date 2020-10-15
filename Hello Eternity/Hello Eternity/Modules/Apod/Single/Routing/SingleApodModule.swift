import Foundation

protocol SingleApodModuleInput: class {}
protocol SingleApodModuleOutput: class {}

final class SingleApodModule {
    
    var input: SingleApodModuleInput {
        return self.viewModel
    }
    
    var output: SingleApodModuleOutput? {
        get {
            return self.viewModel.output
        }
        set {
            self.viewModel.output = newValue
        }
    }
    
    let router: SingleApodRouter
    private let viewModel: SingleApodViewModel
    let viewController: SingleApodViewController
    
    init(configuration: SingleApodModuleConfiguration) {
        let router = SingleApodRouter(configuration: configuration)
        let viewModel = SingleApodViewModel(router: router, configuration: configuration)
        let viewController = SingleApodViewController(viewModel: viewModel)
        
        router.viewController = viewController
        self.router = router
        self.viewModel = viewModel
        self.viewController = viewController
    }
}
