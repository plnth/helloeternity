import Foundation

final class GroupedApodsModule {
    
    let router: GroupedApodsRouter
    private let viewModel: GroupedApodsViewModel
    let viewController: GroupedApodsViewController
    
    init() {
        let router = GroupedApodsRouter()
        let viewModel = GroupedApodsViewModel(router: router)
        let viewController = GroupedApodsViewController(viewModel: viewModel)
        
        router.viewController = viewController
        self.router = router
        self.viewModel = viewModel
        self.viewController = viewController
    }
}
