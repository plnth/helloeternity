import Foundation

final class APODViewModel {
    
    private let router: APODRouter.Routes
    weak var output: APODModuleOutput?
    
    init(router: APODRouter.Routes) {
        self.router = router
    }
    
    func onClose() {
        router.close()
    }
}

extension APODViewModel: APODModuleInput {}
