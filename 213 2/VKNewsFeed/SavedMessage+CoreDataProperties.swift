//
//  SavedMessage+CoreDataProperties.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 25/11/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedMessage> {
        return NSFetchRequest<SavedMessage>(entityName: "SavedMessage")
    }

    @NSManaged public var conversationId: Int64
    @NSManaged public var conversationMessageId: Int64
    @NSManaged public var date: String?
    @NSManaged public var fromId: Int64
    @NSManaged public var id: Int64
    @NSManaged public var message: String?

}
