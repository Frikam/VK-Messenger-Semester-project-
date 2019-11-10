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
        var cells = dialog.items.map({(dialogItem) in cellViewModel(from: dialogItem, dialogResponse: dialog)})
    
        
        let dialogViewModel = DialogViewModel.init(cells: cells)
        viewController?.displayData(viewModel: .displayDialogs(dialogViewModel: dialogViewModel))
    }
  }

    private func cellViewModel(from dialogItem: DialogItem, dialogResponse: DialogResponse) -> DialogViewModel.Cell {
        let name: String
        let urlPhoto: String
        let date = Date(timeIntervalSince1970: dialogItem.lastMessage.date)
        let dateTitle = dateFormatter.string(from: date)
        var lastMessage: String = dialogItem.lastMessage.text
        
        if (lastMessage == "") {
            lastMessage = "Сообщение"
        }
        
        if dialogItem.conversation.peer.type == "user" {
            name = dialogResponse.profiles.filter({$0.id == dialogItem.conversation.peer.id}).map({return "\($0.firstName) \($0.lastName)"})[0]
            urlPhoto = dialogResponse.profiles.filter({$0.id == dialogItem.conversation.peer.id}).map({return "\($0.photo100)"})[0]
            
        } else {
            name = (dialogItem.conversation.chatSettings?.title)!
            urlPhoto = (dialogItem.conversation.chatSettings?.photo.photo100)!
            
        }
        
        return DialogViewModel.Cell.init(id: dialogItem.conversation.peer.id, name: name,
                                         message: lastMessage,
                                         date: dateTitle,
                                         photoUrlString: urlPhoto)
    }
    
    private func getName(from profileItem: ProfileItem, dialogCell: DialogViewModel.Cell) -> String {
        return "\(profileItem.firstName) \(profileItem.lastName)"
    }
}
