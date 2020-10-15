import CoreData

class GroupedApodsViewModel {
    
    private let router: GroupedApodsRouter
    
    private let storageProvider = StorageDataProvider.shared
    var savedApods: [Apod] = [] {
        didSet {
            self.savedApods = (try? self.storageProvider.fetchStoredApods()) ?? []
        }
    }
    
    init(router: GroupedApodsRouter) {
        self.router = router
        do {
            self.savedApods = try self.storageProvider.fetchStoredApods()
        } catch {
            debugPrint(error)
        }
    }
    
    func openSingleApodModule(with title: String) {
        self.router.openSingleApodModule(configuration: .storage(title))
    }
}
