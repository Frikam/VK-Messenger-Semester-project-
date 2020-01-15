//
//  SavedConversation+CoreDataProperties.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 21/11/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedConversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedConversation> {
        return NSFetchRequest<SavedConversation>(entityName: "SavedConversation")
    }

    @NSManaged public var unreadMessages: String?
    @NSManaged public var messagesView: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var photoUrlString: String?
    @NSManaged public var id: Int64
    @NSManaged public var message: String?

}
