//
//  NewsFeedModels.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 09/10/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

enum NewsFeed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getDialogs
        case getLongPollServer
        case updateHistory(ts: String, pts: String, key: String, server: String)
      }
    }
    struct Response {
      enum ResponseType {
        case presentDialogs(dialog: DialogResponse)
        case presentLongPollServer(server: LongPollServerResponse)
        case presentHistory(history: LongPollHistoryResponse)
        
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayDialogs(dialogViewModel: DialogViewModel)
        case saveLongPollServer(serverViewModel: LongPollServer)
        case displayHistory(historyViewModel: LongPollHistory)
      }
    }
  }
}

struct DialogViewModel {
    struct Cell: DialogViewCellModel {
        var id: Int
        var lastMessageId: Int
        var name: String
        var message: String
        var date: String
        var photoUrlString: String
        var unreadMessages: Int
        var messageViewController: MessagesViewController
        var conversationMessageId: Int
    }
    
    var cells: [Cell]
}

struct LongPollServer {
    let ts: String
    let pts: String
    let key: String
    let server: String
}

struct LongPollHistory {
    struct Cell: MessageViewCellModel {
        var text: String
        var date: String
        var fromId: Int
        var id: Int
        var conversationMessageId: Int
        var peerId: Int
    }
    
    var cells: [Cell]
    var newPts: Int
}

