//
//  FeedResponse.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 08/10/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}

struct FeedResponse: Decodable {
    var items: [FeedItem]
}

struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let date: Double
    let text: String
    let likes: CountableItems?
    let comments: CountableItems?
    let reposts: CountableItems?
    let views: CountableItems?
}

struct CountableItems: Decodable {
    let count: Int
    
}
