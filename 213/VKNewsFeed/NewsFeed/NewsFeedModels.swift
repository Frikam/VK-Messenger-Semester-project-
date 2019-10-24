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
        case getFeed
      }
    }
    struct Response {
      enum ResponseType {
        case presentNewsfeed
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayNewsfeed
      }
    }
  }
}

struct DialogViewModel {
    struct Cell: DialogViewCellModel {
        var name: String?
        var message: String?
        var date: String?
        var photoUrlString: String
    }
    
    let cells: [Cell]
}
