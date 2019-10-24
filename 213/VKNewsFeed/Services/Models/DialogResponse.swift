//
//  DialogResponse.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 24/10/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation


struct DialogResponseWrapped: Decodable {
    let response: DialogResponse
}

struct DialogResponse: Decodable {
    var count: Int
    var items: [DialogItem]
}

struct DialogItem: Decodable {
    let conversation: Conversation
    let lastMessage: LastMessage
    let unread_count: Int
}

struct LastMessage: Decodable {
    let id: Int
    let date: Double
    let text: String
}

struct Conversation: Decodable {
    let unreadCount: Int
    let chatSetting: ChatSetting
}

struct ChatSetting: Decodable {
    let membersCount: Int
    let title: String
}
