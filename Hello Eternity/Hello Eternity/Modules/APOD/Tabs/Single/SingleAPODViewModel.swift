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
    
    private(set) var mediaData: Data?
    
    init(router: APODRouter.Routes, configuration: SingleAPODModuleConfiguration) {
        self.router = router
        self.configuration = configuration
        
        if case let SingleAPODModuleConfiguration.storage(title) = configuration {
            self.fetchedAPOD = try? self.storageProvider.fetchAPODByTitle(title)
            self.mediaData = self.storageProvider.getMediaFileDataForTitle(title)
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
                    
                    let media = try self.storageProvider.newMediaItem()
                    if let url = apodItem.url {
                        let title = url.split { $0 == "/" }.last.map(String.init)
                        media.title = title
                    }
                    media.url = apodItem.url
                    
                    apodItem.media = media
                    
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
        self.networkProvider.performTodayPictureFromURLRequest(pictureURL: pictureURL.deletingPrefix(prefix)) { [weak self] result in
            let convertedResult = result.mapError { error -> MoyaError in
                return MoyaError.underlying(error, nil)
            }
            .flatMap { imageData -> Result<Data, MoyaError> in
                self?.mediaData = imageData
                return .success(imageData)
            }
            completion(convertedResult)
        }
    }
    
    func fetchAPODFromStorage(for title: String) -> APOD? {
        let apod = try? self.storageProvider.fetchAPODByTitle(title)
        return apod
    }
    
    func onSaveAPOD() {
        if let media = self.fetchedAPOD?.media,
           let data = self.mediaData {
            let path = self.storageProvider.saveMediaData(media, data)
            self.fetchedAPOD?.media?.filePath = path
            self.saveContext()
        }
    }
    
    private func saveContext() {
        try? self.storageProvider.saveContext()
    }
}

extension SingleAPODViewModel: SingleAPODModuleInput {}
