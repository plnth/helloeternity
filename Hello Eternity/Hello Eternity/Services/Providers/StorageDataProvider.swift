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
    
    private lazy var childContext: NSManagedObjectContext? = {
        guard let parentContext = self.context else { return nil }
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = parentContext
        return childContext
    }()
    
    private let mediaFilesProvider = MediaFilesProvider.default
    
    func fetchStoredAPODs() throws -> [APOD] {
        guard let context = self.context else {
            throw StorageProviderError.noContext
        }
        
        do {
            let request = APOD.fetchRequest() as NSFetchRequest
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            let savedAPODs = try context.fetch(request)
            
            return savedAPODs
        } catch {
            throw StorageProviderError.fetchFailed
        }
    }
    
    func newAPODItem() throws -> APOD {
        
        guard let childContext = self.childContext else {
            throw StorageProviderError.noContext
        }
        
        return APOD(context: childContext)
    }
    
    func newMediaItem() throws -> Media {
        
        guard let childContext = self.childContext else {
            throw StorageProviderError.noContext
        }
        
        return Media(context: childContext)
    }
    
    func fetchAPODByTitle(_ title: String) throws -> APOD? {
        
        guard let context = self.context else {
            throw StorageProviderError.noContext
        }
        
        let request = APOD.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "title CONTAINS %@", title)
        request.predicate = predicate
        
        do {
            let apod = try context.fetch(request).first
            return apod
        } catch {
            throw StorageProviderError.fetchFailed
        }
    }
    
    func saveAPOD(_ apod: APOD, withMedia media: Media, withData data: Data) {
        let path = self.saveMediaData(media, data)
        apod.media?.filePath = path
        do {
            try self.childContext?.save()
            try self.saveContext()
        } catch {
            debugPrint(error)
        }
    }
    
    func saveMediaData(_ media: Media, _ data: Data) -> String? {
        if let title = media.title {
            let path = self.mediaFilesProvider.saveMediaWithPath(mediaData: data, with: title)
            return path
        }
        return nil
    }
    
    func getMediaFileDataForTitle(_ title: String) -> Data? {
        return self.mediaFilesProvider.getMediaFileDataForTitle(title)
    }
    
    func deleteAPOD(_ apod: APOD) {
        self.context?.delete(apod)
        try? self.saveContext()
    }
    
    func saveContext() throws {
        do {
            try self.context?.save()
        } catch {
            throw StorageProviderError.savingFailed
        }
    }
}
