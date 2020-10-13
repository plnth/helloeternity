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
    
    private let mediaFilesProvider = MediaFilesProvider.default
    
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
    
    func newMediaItem() throws -> Media {
        
        guard let context = self.context else {
            throw StorageProviderError.noContext
        }
        
        return Media(context: context)
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
    
    func saveMediaData(_ media: Media, _ data: Data) -> String? {
        if let title = media.title {
            return self.mediaFilesProvider.saveMediaWithPath(mediaData: data, with: title)
        }
        return nil
    }
    
    func saveContext() throws {
        do {
            try self.context?.save()
        } catch {
            throw StorageProviderError.savingFailed
        }
    }
}
