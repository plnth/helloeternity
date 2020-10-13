import UIKit
import CoreData

enum StorageProviderError: Error {
    case noContext
    case fetchFailed
    case savingFailed
}

final class StorageDataProvider {
    
    static let shared: StorageDataProvider = StorageDataProvider()
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func fetchStoredAPODs() throws -> [APOD] {
        guard let context = self.context else {
            throw StorageProviderError.noContext
        }
        
        do {
            let request = APOD.fetchRequest() as NSFetchRequest
            let savedAPODs = try context.fetch(request)
            
            return savedAPODs
        } catch {
            throw StorageProviderError.fetchFailed
        }
    }
    
    func newAPODItem() throws -> APOD {
        
        guard let context = self.context else {
            throw StorageProviderError.noContext
        }
        
        return APOD(context: context)
    }
    
    func fetchAPODByTitle(_ title: String) throws -> APOD? {
        
        guard let context = self.context else {
            throw StorageProviderError.noContext
        }
        
        let request = APOD.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "title == %@", title)
        request.predicate = predicate
        
        do {
            let apod = try context.fetch(request).first
            return apod
        } catch {
            throw StorageProviderError.fetchFailed
        }
    }
    
    func saveContext() throws {
        do {
            try self.context?.save()
        } catch {
            throw StorageProviderError.savingFailed
        }
    }
}
