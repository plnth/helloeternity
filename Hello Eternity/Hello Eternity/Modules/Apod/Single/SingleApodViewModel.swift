import Foundation
import Moya
import CoreData

class SingleApodViewModel {
    
    private let router: SingleApodRouter
    weak var output: SingleApodModuleOutput?
    
    private let networkProvider = NetworkDataProvider()
    private let storageProvider = StorageDataProvider.shared

    private(set) var fetchedApod: Apod?
    
    private(set) var configuration: SingleApodModuleConfiguration
    
    private(set) var mediaData: Data?
    
    init(router: SingleApodRouter, configuration: SingleApodModuleConfiguration) {
        self.router = router
        self.configuration = configuration
        
        if case let SingleApodModuleConfiguration.storage(title) = configuration {
            self.fetchedApod = try? self.storageProvider.fetchApodByTitle(title)
            self.mediaData = self.storageProvider.getMediaFileDataForTitle(title)
        }
    }

    func fetchTodayPictureInfo(completion: @escaping ((Result<Apod, MoyaError>) -> Void)) {
        
        self.networkProvider.performTodayPictureInfoRequest { result in
            let convertedResult = result.mapError { error in
                return MoyaError.underlying(error, nil)
            }
            .flatMap { apodFromAPI -> Result<Apod, MoyaError> in
                
                do {
                    let apodItem = try self.storageProvider.newApodItem()
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
                    
                    self.fetchedApod = apodItem
                    
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
        let prefix = APIConstants.Apod.baseImageURL.absoluteString
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
    
    func fetchApodFromStorage(for title: String) -> Apod? {
        let apod = try? self.storageProvider.fetchApodByTitle(title)
        return apod
    }
    
    func onSaveApod() {
        if let apod = self.fetchedApod,
           let media = apod.media,
           let data = self.mediaData {
            self.storageProvider.saveApod(apod, withMedia: media, withData: data)
        }
    }
    
    func onDeleteApod() {
        if let apod = self.fetchedApod {
            self.storageProvider.deleteApod(apod)
            self.router.close()
        }
    }
}

extension SingleApodViewModel: SingleApodModuleInput {}
