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
  
     private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
  func makeRequest(request: Messages.Model.Request.RequestType) {

    switch request {
        case .getHistory(let id, let count):
            fetcher.getHistory(id: id, count: count) { [weak self] (historyResponse) in
            guard let historyResponse = historyResponse else { return }
                self?.presenter?.presentData(response: .presentHistory(history: historyResponse))
            }
        case .sendMessage(let userId, let message):
            fetcher.sendMessage(userId: userId, message: message)
    case .updateHistory: break
//            fetcher.getNewHistory { [weak self] (historyResponse) in
//            guard let historyResponse = historyResponse else { return }
//                self?.presenter?.presentData(response: .updateHistory(history: historyResponse))
//            }
        }
    }
}

