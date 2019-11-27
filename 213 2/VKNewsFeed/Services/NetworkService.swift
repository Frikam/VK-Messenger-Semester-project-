  
//
//  NetworkService.swift
//  VKNewsFeed
//
//  Created by Илья Тетин on 03/10/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//
import Foundation

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
    func requestFromUrl(url: URL, completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: Networking {
    
    private var authService: AuthService
    
    init(authService: AuthService = AppDelegate.shared().authService) {
        self.authService = authService
    }
    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else { return }
        var allParameters = params
        allParameters["access_token"] = token
        allParameters["v"] = API.version
        let url = self.url(from: path, params: allParameters)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
        print(url)
    }
    
    func requestFromUrl(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
        //print(url)

    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
    
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
    
        components.queryItems = params.map{URLQueryItem(name: $0, value: $1)}
        
        return components.url!
        
    }
}
