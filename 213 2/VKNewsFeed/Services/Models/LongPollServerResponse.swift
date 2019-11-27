//
//  LongPollServerResponse.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 11/11/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

struct LongPollServerResponseWrapped: Decodable {
    let response: LongPollServerResponse
}

struct LongPollServerResponse: Decodable {
    let key: String
    let server: String
    let ts: Int
    let pts: Int
}
