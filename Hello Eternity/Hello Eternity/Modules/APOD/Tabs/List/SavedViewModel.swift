import Foundation
import CoreData
import Moya

class SavedViewModel {
    
    private let router: SingleAPODRouter.Routes
    
    private let storageProvider = StorageDataProvider.shared
    private(set) var savedAPODs: [APOD] = []
    
    init(router: SingleAPODRouter.Routes) {
        self.router = router
        do {
            self.savedAPODs = try self.storageProvider.fetchStoredAPODs()
        } catch {
            debugPrint(error)
        }
    }
    
    func openSingleAPODModule(with title: String) {
        self.router.openSingleAPODModule(configuration: .storage(title))
    }
}
