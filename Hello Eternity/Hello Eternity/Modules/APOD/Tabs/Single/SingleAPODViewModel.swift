import Foundation
import Moya
import CoreData

class SingleAPODViewModel {
    
    private let router: APODRouter.Routes
    weak var output: SingleAPODModuleOutput?
    
    private let networkProvider = NetworkDataProvider()
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private(set) var fetchedAPOD: APOD?
    
    private(set) var configuration: SingleAPODModuleConfiguration
    
    init(router: APODRouter.Routes, configuration: SingleAPODModuleConfiguration) {
        self.router = router
        self.configuration = configuration
        
        if case let SingleAPODModuleConfiguration.storage(title) = configuration {
            
            guard let context = self.context else { return }
            
            let request = APOD.fetchRequest() as NSFetchRequest
            let predicate = NSPredicate(format: "title == %@", title)
            request.predicate = predicate
            
            do {
                self.fetchedAPOD = try context.fetch(request).first
            } catch {
                debugPrint(error)
            }
        }
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
    
    func fetchAPODFromStorage(for title: String) -> APOD? {
        guard let context = self.context else { return nil }
        
        let request = APOD.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "title == %@", title)
        request.predicate = predicate
        do {
            let apod = try context.fetch(request).first
            return apod
        } catch {
            debugPrint(error)
            return nil
        }
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
