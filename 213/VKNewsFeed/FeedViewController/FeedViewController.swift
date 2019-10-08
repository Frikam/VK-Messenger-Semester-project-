//
//  FeedViewController.swift
//  VKNewsFeed
//
//  Created by Алексей Пархоменко on 23/02/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    private let  networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let params = ["filters": "post, photo"]
        networkService.request(from: API.newsFeed, parameters: params) { (data, error) in
            if let error = error {
                print ("Error requesting data: \(error.localizedDescription)")
            }
            
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: [] )
            print(json)
        }
        view.backgroundColor = #colorLiteral(red: 0.5671284795, green: 0.7945078611, blue: 0.9987251163, alpha: 1)
        // Do any additional setup after loading the view.
    }
}
