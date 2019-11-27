//
//  MessageCell.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 06/11/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//
import Foundation
import UIKit

protocol MessageViewCellModel {
    var text: String { get }
    var date: String { get }
    var fromId: Int { get }
    var id: Int { get }
    var conversationMessageId: Int { get }
    var peerId: Int { get }
}

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var message: UILabel!
    static let reuseId = "MessageCell"
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(viewModel: MessageViewCellModel) {
        time.text = viewModel.date
        message.text = viewModel.text
    }
}
