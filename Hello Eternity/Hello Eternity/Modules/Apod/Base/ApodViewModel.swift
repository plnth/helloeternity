import Foundation

final class ApodViewModel {
    
    private let router: ApodRouter
    
    init(router: ApodRouter) {
        self.router = router
    }
    
    func createTodayViewModel() -> SingleApodViewModel {
        let singleApodRouter = self.router.createSingleApodRouter()
        return SingleApodViewModel(router: singleApodRouter, configuration: .network)
    }
    
    func createSavedViewModel() -> GroupedApodsViewModel {
        let groupedApodsRouter = self.router.createGroupedApodsRouter()
        return GroupedApodsViewModel(router: groupedApodsRouter)
    }
    
    func onClose() {
        self.router.close()
    }
}
