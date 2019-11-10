//
//  MessagesInteractor.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 06/11/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol MessagesBusinessLogic {
  func makeRequest(request: Messages.Model.Request.RequestType)
}

class MessagesInteractor: MessagesBusinessLogic {

  var presenter: MessagesPresentationLogic?
  var service: MessagesService?
  
     private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
  func makeRequest(request: Messages.Model.Request.RequestType) {
    if service == nil {
      service = MessagesService()
    }
    
    switch request {
        case .getHistory(let id):
            fetcher.getHistory(id: id) { [weak self] (historyResponse) in
            guard let historyResponse = historyResponse else { return }
                self?.presenter?.presentData(response: .presentHistory(history: historyResponse))
            }
    }
    }
}

