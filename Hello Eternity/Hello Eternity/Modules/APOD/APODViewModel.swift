import Foundation

final class APODViewModel {
    
    private let router: APODRouter.Routes
    weak var output: APODModuleOutput?
    
    init(router: APODRouter.Routes) {
        self.router = router
    }
    
    func createTodayViewModel() -> SingleAPODViewModel {
        return SingleAPODViewModel(router: self.router)
    }
    
    func createSavedViewModel() -> SavedViewModel {
        return SavedViewModel(router: self.router)
    }
    
    func onClose() {
        router.close()
    }
}

extension APODViewModel: APODModuleInput {}
