//
//  NetworkDataFetcher.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 08/10/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//
import Foundation

protocol DataFetcher {
    func getDialogs(response: @escaping (DialogResponse?) -> Void)
    func getHistory(id: String, response: @escaping (HistoryResponse?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    private var networking: Networking
    
    init(networking: Networking){
        self.networking = networking
    }
    
    
    func getDialogs(response: @escaping (DialogResponse?) -> Void) {
        var params = ["filter": "all"]
        params["extended"] = "1"
        
        networking.request(path: API.messages, params: params) { (data, error) in
            if let error = error {
                print ("Error requesting data: \(error.localizedDescription)")
            }
            let decoded = self.decodeJSON(type: DialogResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    func getHistory(id: String, response: @escaping (HistoryResponse?) -> Void) {
        var params = ["user_id": id]
        params["extended"] = "1"
        
        networking.request(path: API.history, params: params) { (data, error) in
            if let error = error {
                print ("Error requesting data: \(error.localizedDescription)")
            }
            let decoded = self.decodeJSON(type: HistoryResponseWrapped.self, from: data)
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
