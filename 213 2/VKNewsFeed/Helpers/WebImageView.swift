//
//  WebImageView.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 30/10/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

class WebImageView: UIImageView {
    func set(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            DispatchQueue.main.async {
                if let data = data {
                    self?.image = UIImage(data: data)
                }
            }
        }
        
        dataTask.resume()
    }
}
