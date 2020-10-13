import Foundation
import Moya
import CoreData

class SingleAPODViewModel {
    
    private let router: APODRouter.Routes
    weak var output: SingleAPODModuleOutput?
    
    private let networkProvider = NetworkDataProvider()
    private let storageProvider = StorageDataProvider.shared

    private(set) var fetchedAPOD: APOD?
    
    private(set) var configuration: SingleAPODModuleConfiguration
    
    init(router: APODRouter.Routes, configuration: SingleAPODModuleConfiguration) {
        self.router = router
        self.configuration = configuration
        
        if case let SingleAPODModuleConfiguration.storage(title) = configuration {
            self.fetchedAPOD = try? self.storageProvider.fetchAPODByTitle(title)
        }
    }

    func fetchTodayPictureInfo(completion: @escaping ((Result<APOD, MoyaError>) -> Void)) {
        
        self.networkProvider.performTodayPictureInfoRequest { result in
            let convertedResult = result.mapError { error in
                return MoyaError.underlying(error, nil)
            }
            .flatMap { apodFromAPI -> Result<APOD, MoyaError> in
                
                do {
                    let apodItem = try self.storageProvider.newAPODItem()
                    apodItem.date = apodFromAPI.date
                    apodItem.explanation = apodFromAPI.explanation
                    apodItem.hdurl = apodFromAPI.hdurl
                    apodItem.title = apodFromAPI.title
                    apodItem.url = apodFromAPI.url
                    
                    self.fetchedAPOD = apodItem
                    
                    return .success(apodItem)
                } catch {
                    debugPrint(error)
                    return .failure(MoyaError.underlying(error, nil))
                }
            }
                
            completion(convertedResult)
        }
    }
    
    func fetchTodayPictureFromURL(pictureURL: String, completion: @escaping ((Result<Data, MoyaError>) -> Void)) {
        let prefix = APIConstants.APOD.baseImageURL.absoluteString
        return self.networkProvider.performTodayPictureFromURLRequest(pictureURL: pictureURL.deletingPrefix(prefix), completion: completion)
    }
    
    func fetchAPODFromStorage(for title: String) -> APOD? {
        let apod = try? self.storageProvider.fetchAPODByTitle(title)
        return apod
    }
    
    func onSaveAPOD() {
        self.saveContext()
    }
    
    private func saveContext() {
        try? self.storageProvider.saveContext()
    }
}

extension SingleAPODViewModel: SingleAPODModuleInput {}
