import Foundation

class TodayViewModel {
    private let router: APODRouter.Routes
    
    private let networkProvider = NetworkDataProvider()
    
    init(router: APODRouter.Routes) {
        self.router = router
    }
    
    func fetchTodayPicture(completion: @escaping ((APODData?, Error?) -> Void)) {
        return self.networkProvider.performTodayPictureRequest(completion: completion)
    }
}
