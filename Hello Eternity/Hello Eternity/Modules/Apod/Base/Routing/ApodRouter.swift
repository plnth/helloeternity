import Foundation

final class ApodRouter: Router<ApodViewController> {
    typealias Routes = Closable
    
    private let todayApodRouter: SingleApodRouter
    private let savedApodsRouter: GroupedApodsRouter
    
    init(todayApodRouter: SingleApodRouter, savedApodsRouter: GroupedApodsRouter) {
        self.todayApodRouter = todayApodRouter
        self.savedApodsRouter = savedApodsRouter
    }
    
    func setupApodTabs() {
        let todayViewModel = SingleApodViewModel(router: self.todayApodRouter, configuration: .network)
        let todayController = SingleApodViewController(viewModel: todayViewModel)
        self.todayApodRouter.viewController = todayController
        
        let savedViewModel = GroupedApodsViewModel(router: self.savedApodsRouter)
        let savedController = GroupedApodsViewController(viewModel: savedViewModel)
        self.savedApodsRouter.viewController = savedController
        
        self.viewController?.viewControllers = [todayController, savedController]
    }
}
