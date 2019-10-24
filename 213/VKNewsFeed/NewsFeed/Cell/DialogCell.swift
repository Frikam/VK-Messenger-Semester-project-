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
    var name : String? { get }
    var message : String? { get }
    var date : String? { get }
    var photoUrlString: String { get }
}

class DialogCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let reuseId = "DialogCell"
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(viewModel: DialogViewCellModel) {
        nameLabel.text = viewModel.name
        messageLabel.text = viewModel.message
        dateLabel.text = viewModel.date
    }
}
