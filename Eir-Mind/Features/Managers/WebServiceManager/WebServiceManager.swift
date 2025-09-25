//
//  WebServiceManager.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

final class WebServiceManager {
    
    static let shared: WebServiceManager = WebServiceManager()
    
    private init() {}
    
    func performRequest<T: Decodable>(endPoint: String,
                                      method: HTTPMethod = .get,
                                      body: Data? = nil,
                                      completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: NetworkConstants.baseUrl + endPoint) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL string."])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        /// If there's a body, add it and set headers
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                print(String(decoding: data, as: UTF8.self))
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
