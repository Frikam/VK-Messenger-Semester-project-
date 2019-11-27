//
//  LongPollHistoryResponse.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 13/11/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

struct LongPollHistoryResponseWrapped: Decodable {
    let response: LongPollHistoryResponse
}

struct LongPollHistoryResponse: Decodable {
    //let history: 
    var messages: MessageItem?
    let groups: [GroupItem]?
    var profiles: [Profile]?
    let newPts: Int
}

struct MessageItem: Decodable {
    let count: Int
    var items: [Message]
}

struct Profile: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
}

