//
//  API.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 03/10/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

struct API {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.101"
    
    static let newsFeed = "/method/newsfeed.get"
    static let messages = "/method/messages.getConversations"
}
