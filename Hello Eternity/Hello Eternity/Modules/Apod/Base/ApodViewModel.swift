import Foundation

final class ApodViewModel {
    
    private let router: ApodRouter
    
    init(router: ApodRouter) {
        self.router = router
    }
    
    func onClose() {
        self.router.close()
    }
}
