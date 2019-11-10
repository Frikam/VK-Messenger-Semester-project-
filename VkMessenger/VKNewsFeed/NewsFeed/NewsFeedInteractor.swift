//
//  NewsFeedInteractor.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 09/10/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol NewsFeedBusinessLogic {
  func makeRequest(request: NewsFeed.Model.Request.RequestType)
}

class NewsFeedInteractor: NewsFeedBusinessLogic {

  var presenter: NewsFeedPresentationLogic?
  var service: NewsFeedService?
  
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())

  func makeRequest(request: NewsFeed.Model.Request.RequestType) {
    if service == nil {
      service = NewsFeedService()
    }
    
    switch request {
        case .getDialogs:
            fetcher.getDialogs { [weak self] (dialogResponse) in
                guard let dialogResponse = dialogResponse else { return }
                self?.presenter?.presentData(response: .presentDialogs(dialog: dialogResponse))
            }
    }
   }
        
}
