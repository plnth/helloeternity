import Foundation

final class ApodModule {
    
    let router: ApodRouter
    private let viewModel: ApodViewModel
    let viewController: ApodViewController
    
    init() {
        let router = ApodRouter()
        let viewModel = ApodViewModel(router: router)
        let viewController = ApodViewController(viewModel: viewModel)
        
        router.viewController = viewController
        self.router = router
        self.viewController = viewController
        self.viewModel = viewModel
    }
}
