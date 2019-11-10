//
//  HistoryResponse.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 06/11/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

struct HistoryResponseWrapped: Decodable {
    let response: HistoryResponse
}

struct HistoryResponse: Decodable {
    let count: Int?
    var items: [Message]
}

struct Message: Decodable {
    var id: Int
    var date: Double
    var text: String?
    var fromId: Int
}
