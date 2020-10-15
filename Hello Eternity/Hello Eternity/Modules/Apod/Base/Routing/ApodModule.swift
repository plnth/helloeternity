import Foundation

final class ApodModule {
    
    let router: ApodRouter
    private let viewModel: ApodViewModel
    let viewController: ApodViewController
    
    init() {
        let todayApodModule = SingleApodModule(configuration: .network)
        let savedApodModule = GroupedApodsModule(configuration: .storage(""))
        
        let router = ApodRouter(
            todayApodRouter: todayApodModule.router,
            savedApodsRouter: savedApodModule.router
        )
        let viewModel = ApodViewModel(router: router)
        let viewController = ApodViewController(viewModel: viewModel)
        
        router.viewController = viewController
        router.setupApodTabs()
        self.router = router
        self.viewController = viewController
        self.viewModel = viewModel
    }
}
