//
//  DialogCell.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 23/10/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

protocol DialogViewCellModel {
    var id : Int { get }
    var name : String { get }
    var message : String { get }
    var date : String { get }
    var photoUrlString: String { get }
    var unreadMessages: Int { get }
    var messageViewController: MessagesViewController { get }
    var conversationMessageId: Int { get }
    var lastMessageId: Int { get }

}

class DialogCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var unreadMessages: UILabel!
    
    static let reuseId = "DialogCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        makeImageRound()
        unreadMessages.layer.masksToBounds = true
        unreadMessages.layer.cornerRadius = 5
    }
    
    func set(viewModel: DialogViewCellModel) {
        photoImageView.set(imageURL: viewModel.photoUrlString)
        nameLabel.text = viewModel.name
        messageLabel.text = viewModel.message
        dateLabel.text = viewModel.date
        unreadMessages.text = " \(viewModel.unreadMessages) "
        showUnreadMessages()
    }
    
    func makeImageRound() {
        photoImageView.layer.cornerRadius = photoImageView.frame.size.width / 2.0
        photoImageView.layer.borderWidth = 2.0
        photoImageView.layer.borderColor = UIColor.white.cgColor
        photoImageView.layer.masksToBounds = true
        photoImageView.clipsToBounds = true
    }
    
    func showUnreadMessages() {
        if (unreadMessages.text == " 0 ") {
            unreadMessages.isHidden = true
        } else {
            unreadMessages.isHidden = false
        }
    }
}
