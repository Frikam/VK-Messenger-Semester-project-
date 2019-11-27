//
//  NewsFeedPresenter.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 09/10/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
  func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
  weak var viewController: NewsFeedDisplayLogic?
    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d.MM"
        return dt
    }()
  
  func presentData(response: NewsFeed.Model.Response.ResponseType) {
    switch response {
    case .presentDialogs(let dialog):
        let cells = dialog.items.map({(dialogItem) in cellViewModel(from: dialogItem, dialogResponse: dialog)})
    
        let dialogViewModel = DialogViewModel.init(cells: cells)
        viewController?.displayData(viewModel: .displayDialogs(dialogViewModel: dialogViewModel))
    case .presentLongPollServer(let server):
        let server = LongPollServer.init(ts: "\(server.ts)", pts: "\(server.pts)", key: server.key, server: server.server)
        viewController?.displayData(viewModel: .saveLongPollServer(serverViewModel: server))
    case .presentHistory(let history):
        guard let messages = history.messages else { return }
        let cells = messages.items.map({messageItem in cellViewModel(from: messageItem)})
        let messagesViewModel = LongPollHistory.init(cells: cells, newPts: history.newPts)
        viewController?.displayData(viewModel: .displayHistory(historyViewModel: messagesViewModel))
    }
  }

    private func cellViewModel(from dialogItem: DialogItem, dialogResponse: DialogResponse) -> DialogViewModel.Cell {
        let name: String
        let urlPhoto: String
        let date = Date(timeIntervalSince1970: dialogItem.lastMessage.date)
        let dateTitle = dateFormatter.string(from: date)
        var lastMessage = dialogItem.lastMessage.text
        var unreadMessages = 0
        
        if let number = dialogItem.conversation.unreadCount {
            unreadMessages = number
        }
        if (lastMessage == "") {
            lastMessage = "Сообщение"
        }
        
        if dialogItem.conversation.peer.type == "user" {
            name = dialogResponse.profiles.filter({$0.id == dialogItem.conversation.peer.id}).map({return "\($0.firstName) \($0.lastName)"})[0]
            urlPhoto = dialogResponse.profiles.filter({$0.id == dialogItem.conversation.peer.id}).map({return "\($0.photo100)"})[0]
        } else if dialogItem.conversation.peer.type == "chat" {
            name = (dialogItem.conversation.chatSettings?.title)!
            urlPhoto = (dialogItem.conversation.chatSettings?.photo.photo100)!
        } else {
            name = dialogResponse.groups!.filter({$0.id == -dialogItem.conversation.peer.id}).map({return "\($0.name)"})[0]
            urlPhoto = (dialogResponse.groups!.filter({$0.id == -dialogItem.conversation.peer.id}).map({return "\($0.photo100)"})[0])
        }
        
        return DialogViewModel.Cell.init(id: dialogItem.conversation.peer.id, lastMessageId: dialogItem.lastMessage.id, name: name,
                                         message: lastMessage,
                                         date: dateTitle,
                                         photoUrlString: urlPhoto, unreadMessages: unreadMessages, messageViewController: MessagesViewController(), conversationMessageId: dialogItem.lastMessage.conversationMessageId)
    }
    
    private func getName(from profileItem: ProfileItem, dialogCell: DialogViewModel.Cell) -> String {
        return "\(profileItem.firstName) \(profileItem.lastName)"
    }
    
    private func cellViewModel(from message: Message) -> LongPollHistory.Cell {
        let date = Date(timeIntervalSince1970: message.date )
        let dateTitle = dateFormatter.string(from: date)
        
        return LongPollHistory.Cell.init(text: message.text ?? "", date: dateTitle, fromId: message.id, id: message.fromId, conversationMessageId: message.conversationMessageId, peerId: message.peerId)
    }
}
