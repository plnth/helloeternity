import Foundation
import CoreData


extension APOD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<APOD> {
        return NSFetchRequest<APOD>(entityName: "APOD")
    }

    @NSManaged public var date: String?
    @NSManaged public var explanation: String?
    @NSManaged public var hdurl: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

}
