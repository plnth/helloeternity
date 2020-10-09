import Foundation

final class MainViewModel {
    
    private let router: MainRouter.Routes
    
    init(router: MainRouter.Routes) {
        self.router = router
    }
    
    func onOpedAPODModule() {
        router.openAPODModule()
    }
}
