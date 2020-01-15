import Foundation
import CoreData


extension SavedConversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedConversation> {
        return NSFetchRequest<SavedConversation>(entityName: "SavedConversation")
    }

    @NSManaged public var conversationMessageId: Int64
    @NSManaged public var date: String?
    @NSManaged public var id: Int64
    @NSManaged public var lastMessageId: Int64
    @NSManaged public var message: String?
    @NSManaged public var name: String?
    @NSManaged public var photoUrlString: String?
    @NSManaged public var unreadMessages: Int64

}
