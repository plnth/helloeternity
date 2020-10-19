import UIKit
import CoreData

enum StorageProviderError: Error {
    case fetchFailed
    case savingFailed
}

final class StorageDataProvider {
    
    static let shared: StorageDataProvider = StorageDataProvider()
    
    private let context = CoreDataStack(modelName: "HelloEternityDataModel").managedContext
    
    private lazy var childContext: NSManagedObjectContext = {
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = self.context
        return childContext
    }()
    
    private let mediaFilesProvider = MediaFilesProvider.default
    
    func fetchStoredApods() throws -> [Apod] {
        
        do {
            let request = Apod.fetchRequest() as NSFetchRequest
            let compareSelector = #selector(NSString.localizedStandardCompare(_:))
            request.sortDescriptors = [
                NSSortDescriptor(
                    key: #keyPath(Apod.title),
                    ascending: true,
                    selector: compareSelector
                )
            ]
            let savedApods = try self.context.fetch(request)
            
            return savedApods
        } catch {
            throw StorageProviderError.fetchFailed
        }
    }
    
    func newApodItem() throws -> Apod {
        
        return Apod(context: self.childContext)
    }
    
    func newMediaItem() throws -> Media {
        
        return Media(context: self.childContext)
    }
    
    func fetchApodByTitle(_ title: String) throws -> Apod? {
        
        let request = Apod.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "title CONTAINS %@", title)
        request.predicate = predicate
        
        do {
            let apod = try self.context.fetch(request).first
            return apod
        } catch {
            throw StorageProviderError.fetchFailed
        }
    }
    
    func saveApod(_ apod: Apod, withMedia media: Media, withData data: Data) {
        let path = self.saveMediaData(media, data)
        apod.media?.filePath = path
        do {
            try self.childContext.save()
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
    
    func deleteApod(_ apod: Apod) {
        self.context.delete(apod)
        try? self.saveContext()
    }
    
    func saveContext() throws {
        do {
            try self.context.save()
        } catch {
            throw StorageProviderError.savingFailed
        }
    }
}
