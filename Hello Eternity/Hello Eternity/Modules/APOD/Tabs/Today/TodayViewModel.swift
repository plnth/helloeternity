import Foundation

class TodayViewModel {
    private let router: APODRouter.Routes
    
    private let networkProvider = NetworkDataProvider()
    
    init(router: APODRouter.Routes) {
        self.router = router
    }
    
    func fetchTodayPictureInfo(completion: @escaping ((APODData?, Error?) -> Void)) {
        return self.networkProvider.performTodayPictureInfoRequest(completion: completion)
    }
    
    func fetchTodayPictureFromURL(pictureURL: String, completion: @escaping ((Data?, Error?) -> Void)) {
        let prefix = APIConstants.APOD.baseImageURL.absoluteString
        return self.networkProvider.performTodayPictureFromURLRequest(pictureURL: pictureURL.deletingPrefix(prefix), completion: completion)
    }
}
