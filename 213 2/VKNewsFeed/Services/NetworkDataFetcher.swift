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
    func getHistory(id: String, count: Int, response: @escaping (HistoryResponse?) -> Void)
    func sendMessage(userId: String, message: String)
    //func updateHistory(response: @escaping (LongPollHistoryResponse?) -> Void)
    func getLongPollHistory(ts: String, pts: String, key: String, server: String, response: @escaping (LongPollHistoryResponse?) -> Void)
    func getLongPollServer(response: @escaping (LongPollServerResponse?) -> Void)

}

class NetworkDataFetcher: DataFetcher {
    
    private var networking: Networking
    private var server: String
    private var key: String
    private var ts: String
    private var pts: String
    private var count = 0
    private var newMessages: LongPollHistoryResponse!
    
    init(networking: Networking){
        self.networking = networking
        self.key = ""
        self.ts = ""
        self.pts = ""
        self.server = ""
    }
    
    
    func getDialogs(response: @escaping (DialogResponse?) -> Void) {
        //updateHistory()
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
    
    func getHistory(id: String, count: Int, response: @escaping (HistoryResponse?) -> Void) {
        if (count == 0) {
            return
        }
        var numberOfMessages = count
        if (count > 20) {
            numberOfMessages = 20
        }
        var params = ["user_id": id]
        params["count"] = "\(numberOfMessages)"
        params["extended"] = "1"
        networking.request(path: API.history, params: params) { (data, error) in
            if let error = error {
                print ("Error requesting data: \(error.localizedDescription)")
            }
            let decoded = self.decodeJSON(type: HistoryResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    func sendMessage(userId: String, message: String) {
        
        let randomId = arc4random()
        
        var params = ["user_id": userId]
        params["random_id"] = "\(randomId)"
        params["message"] = "\(message)"
        networking.request(path: API.send, params: params) { (data, error) in
            if let error = error {
                print ("Error requesting data: \(error.localizedDescription)")
            }
        }
    }
    
    func getLongPollServer(response: @escaping (LongPollServerResponse?) -> Void) {
        var params = ["need_pts" : "1"]
        params["lp_version"] = "3"
        networking.request(path: API.longPollServer, params: params) { (data, error) in
            let decoded = self.decodeJSON(type: LongPollServerResponseWrapped.self, from: data)
            //self.getLongPollHistory(ts: "\((decoded?.response.ts)!)", pts: "\((decoded?.response.pts)!)", key: "\((decoded?.response.key)!)", server: "\((decoded?.response.server)!)", response: response)
            response(decoded?.response)
        }
    }
    
    func getLongPollHistory(ts: String, pts: String, key: String, server: String, response: @escaping (LongPollHistoryResponse?) -> Void) {
        let url = "http://\(server)?act=a_check&key=\(key)&ts=\(ts)&wait=25&mode=2"
        //print(url)
        networking.requestFromUrl(url: NSURL(string: url)! as URL) { (data, error) in
            if let error = error {
                print ("Error requesting data: \(error.localizedDescription)")
                return
            }
            var params = ["ts" : ts]
            params["lp_version"] = "3"
            params["pts"] = pts
            self.networking.request(path: API.longPollHistory, params: params ) { (data, error) in
                if let error = error {
                    print ("Error requesting data: \(error.localizedDescription)")
                }
                let decoded = self.decodeJSON(type: LongPollHistoryResponseWrapped.self, from: data)
                self.newMessages = decoded?.response
                //response(decoded?.response)
                //self.getLongPollServer()
                response(decoded?.response)
            }
        }
    }
        
    private func decodeJSON<T: Decodable> (type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
