//
//  FeedViewController.swift
//  VKNewsFeed
//
//  Created by Алексей Пархоменко on 23/02/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    private let networkService: Networking = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetcher.getDialogs {(dialogResponse) in
            guard let dialogResponse = dialogResponse else {
                print("return")
                return }
            dialogResponse.items.map({
                (dialogItem) in print("Hello world")
            })
            
            print("dasd", dialogResponse)
        }
        view.backgroundColor = #colorLiteral(red: 0.5671284795, green: 0.7945078611, blue: 0.9987251163, alpha: 1)
        // Do any additional setup after loading the view.
    }
}
