//
//  NetworkDataFetcher.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 08/10/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getFeed(response: @escaping (FeedResponse?) -> Void)
    func getDialogs(response: @escaping (DialogResponse?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    private var networking: Networking
    
    init(networking: Networking){
        self.networking = networking
    }
    
    func getFeed(response: @escaping (FeedResponse?) -> Void) {
        let params = ["filters": "post, photo"]
        networking.request(path: API.newsFeed, params: params) { (data, error) in
            if let error = error {
                print ("Error requesting data: \(error.localizedDescription)")
            }
            
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    func getDialogs(response: @escaping (DialogResponse?) -> Void) {
        let params = ["filter": "all"]
        networking.request(path: API.messages, params: params) { (data, error) in
            if let error = error {
                print ("Error requesting data: \(error.localizedDescription)")
            }
            print(data)
            let decoded = self.decodeJSON(type: DialogResponseWrapped.self, from: data)
            response(decoded?.response)
        }

    }
    
    private func decodeJSON<T: Decodable> (type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}


