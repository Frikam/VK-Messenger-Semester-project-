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
      }
    }
    struct Response {
      enum ResponseType {
        case presentDialogs(dialog: DialogResponse)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayDialogs(dialogViewModel: DialogViewModel)
      }
    }
  }
}

struct DialogViewModel {
    struct Cell: DialogViewCellModel {
        var id: Int
        var name: String
        var message: String
        var date: String
        var photoUrlString: String
    }
    
    var cells: [Cell]
}

