import Foundation
import CoreData
import Moya

class SavedViewModel {
    private let router: SingleAPODRouter.Routes
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    private(set) var savedAPODs: [APOD] = []
    
    init(router: SingleAPODRouter.Routes) {
        self.router = router
        
        guard let context = self.context else { return }
        
        do {
            let request = APOD.fetchRequest() as NSFetchRequest
            self.savedAPODs = try context.fetch(request)
        } catch {
            debugPrint(error)
        }
    }
    
    func openSingleAPODModule(with title: String) {
        self.router.openSingleAPODModule(configuration: .storage(title))
    }
}
