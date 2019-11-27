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
    let count: Int
    var items: [DialogItem]
    let unreadCount: Int?
    var profiles: [ProfileItem]
    var groups: [GroupItem]?
}

struct GroupItem: Decodable {
    let id: Int
    let name: String
    let photo100: String
}

struct ProfileItem: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo50: String
    let photo100: String
}

struct DialogItem: Decodable {
    let conversation: Conversation
    let lastMessage: LastMessage
}

struct LastMessage: Decodable {
    let id: Int
    let date: Double
    let text: String
    let action: Action?
    let conversationMessageId: Int
}

struct Conversation: Decodable {
    let peer: Peer
    let unreadCount: Int?
    let chatSettings: ChatSettings?
}

struct Peer: Decodable {
    let id: Int
    let type: String
    
}

struct ChatSettings: Decodable {
    let membersCount: Int?
    let title: String
    let photo: Photo
}

struct Action: Decodable {
    let photo: Photo
}

struct Photo: Decodable {
    let photo50: String
    let photo100: String
    let photo200: String
}
