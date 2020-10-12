import Foundation
import Moya

class SingleAPODViewModel {
    
    private let router: APODRouter.Routes
    weak var output: SingleAPODModuleOutput?
    
    private let networkProvider = NetworkDataProvider()
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private(set) var fetchedAPOD: APOD?
    
    init(router: APODRouter.Routes) {
        self.router = router
    }

    func fetchTodayPictureInfo(completion: @escaping ((Result<APOD, MoyaError>) -> Void)) {
        
        guard let context = self.context else { return }
        
        self.networkProvider.performTodayPictureInfoRequest { result in
            let convertedResult = result.mapError { error in
                return MoyaError.underlying(error, nil)
            }
            .flatMap { apodFromAPI -> Result<APOD, MoyaError> in
                
                let apodItem = APOD(context: context)
                apodItem.date = apodFromAPI.date
                apodItem.explanation = apodFromAPI.explanation
                apodItem.hdurl = apodFromAPI.hdurl
                apodItem.title = apodFromAPI.title
                apodItem.url = apodFromAPI.url
                
                self.fetchedAPOD = apodItem
                
                return .success(apodItem)
            }
                
            completion(convertedResult)
        }
    }
    
    func fetchTodayPictureFromURL(pictureURL: String, completion: @escaping ((Result<Data, MoyaError>) -> Void)) {
        let prefix = APIConstants.APOD.baseImageURL.absoluteString
        return self.networkProvider.performTodayPictureFromURLRequest(pictureURL: pictureURL.deletingPrefix(prefix), completion: completion)
    }
    
    func onSaveAPOD() {
        self.saveContext()
    }
    
    private func saveContext() {
        do {
            try self.context?.save()
        } catch {
            debugPrint(error)
        }
    }
}

extension SingleAPODViewModel: SingleAPODModuleInput {}
