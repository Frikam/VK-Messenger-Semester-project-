//
//  MessagesPresenter.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 06/11/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol MessagesPresentationLogic {
  func presentData(response: Messages.Model.Response.ResponseType)
}

class MessagesPresenter: MessagesPresentationLogic {
  weak var viewController: MessagesDisplayLogic?
  
    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d.MM"
        return dt
    }()
    
  func presentData(response: Messages.Model.Response.ResponseType) {
    switch response {
        
    case .presentHistory(let history):
        let cells = history.items.map({messageItem in cellViewModel(from: messageItem)})
        
        let messagesViewModel = HistoryViewModel.init(cells: cells)
        viewController?.displayData(viewModel: .displayHistory(historyViewModel: messagesViewModel))
    case .updateHistory(let history):
        let cells = history.messages!.items.map({messageItem in cellViewModel(from: messageItem)})
        if cells.count != 0 {
            let messagesViewModel = HistoryViewModel.init(cells: cells)
            viewController?.displayData(viewModel: .displayNewMessages(historyViewModel: messagesViewModel))

        }
    }

  }
    private func cellViewModel(from message: Message) -> HistoryViewModel.Cell {
        let date = Date(timeIntervalSince1970: message.date )
        let dateTitle = dateFormatter.string(from: date)
        
        return HistoryViewModel.Cell.init(text: message.text ?? "", date: dateTitle, fromId: message.fromId, id: message.id, conversationMessageId: message.conversationMessageId, peerId: message.peerId)
    }

}
