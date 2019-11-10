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
        case getHistory(id: String)
      }
    }
    struct Response {
      enum ResponseType {
        case presentHistory(history: HistoryResponse)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayHistory(historyViewModel: HistoryViewModel)
      }
    }
  }

  
}

struct HistoryViewModel {
    struct Cell: MessageViewCellModel {
        var text: String
        var date: String
        var fromId: Int
    }
    
    var cells: [Cell]
}
