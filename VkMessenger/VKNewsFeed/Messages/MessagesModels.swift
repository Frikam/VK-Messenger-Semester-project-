//
//  MessagesModels.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 06/11/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

enum Messages {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getHistory(id: String, count: Int)
        case sendMessage(userId: String, message: String)
        case updateHistory
      }
    }
    struct Response {
      enum ResponseType {
        case presentHistory(history: HistoryResponse)
        case updateHistory(history: LongPollHistoryResponse)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayHistory(historyViewModel: HistoryViewModel)
        case displayNewMessages(historyViewModel: HistoryViewModel)
      }
    }
  }

  
}

struct HistoryViewModel {
    struct Cell: MessageViewCellModel {
        var text: String
        var date: String
        var fromId: Int
        var id: Int
        var conversationMessageId: Int
        var peerId: Int
    }
    
    var cells: [Cell]
}
