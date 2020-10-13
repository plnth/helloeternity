import Foundation

enum MediaFilesProviderError: Error {
    case savingFailed
    case noSuchFile
}

final class MediaFilesProvider {
    
    static let `default` = MediaFilesProvider()
    
    private let fileManager = FileManager.default
    private let mediaFilesPathComponent = "MediaFiles"
    private let rootMediaDirectory: URL
    
    init() {
        
        do {
            let documentsDirectoryURL = try self.fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            
            try self.fileManager.createDirectory(
                at: documentsDirectoryURL.appendingPathComponent(self.mediaFilesPathComponent),
                withIntermediateDirectories: true,
                attributes: nil
            )
            
            self.rootMediaDirectory = documentsDirectoryURL.appendingPathComponent(self.mediaFilesPathComponent)
            
        } catch {
            self.rootMediaDirectory = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
            debugPrint(error)
        }
    }
    
    func saveMediaWithPath(mediaData data: Data, with path: String) -> String {
        
        let fullPath = self.rootMediaDirectory.appendingPathComponent(path).path
        self.fileManager.createFile(
            atPath: fullPath,
            contents: data,
            attributes: nil)
        
        return fullPath
    }
    
    func getMediaFileDataForTitle(_ title: String) -> Data? {
        let fullPath = self.rootMediaDirectory.appendingPathComponent(title).path
        return self.fileManager.contents(atPath: fullPath)
    }
}
