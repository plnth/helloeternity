import Foundation
import CoreData


extension Media {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Media> {
        return NSFetchRequest<Media>(entityName: "Media")
    }

    @NSManaged public var filePath: String?
    @NSManaged public var url: String?
    @NSManaged public var title: String?
    @NSManaged public var apodData: APOD?

}
