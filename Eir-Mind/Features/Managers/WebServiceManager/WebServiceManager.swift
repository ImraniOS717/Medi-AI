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

struct HttpError: LocalizedError {
    let statusCode: Int
    let message: String
    
    var errorMessagesDescription: String {
        return message + " (\(statusCode))"
    }
    
}


final class WebServiceManager {
    
    static let shared: WebServiceManager = WebServiceManager()
    
    private init() {}
    
    func performRequest<T: Decodable>(endPoint: String,
                                      method: HTTPMethod = .get,
                                      body: Data? = nil,
                                      token: String? = nil,
                                      completion: @escaping (Result<T, Error>) -> Void) {
        
        
        guard InternetManager.shared.isConnected else { return }
        
        guard let url = URL(string: NetworkConstants.baseUrl + endPoint) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL string."])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
//        if let _ = token {
//            if let  userData = UserDefaultDataManager.shared.load(forKey: ViewConstants.saveUserDataKey, type: LoginResponseModel.self) {
//                printer.print("WebServiceManager ==>  Retrieved saved user data: \(userData)")
//                request.setValue("Bearer \(String(describing: userData.token))", forHTTPHeaderField: "Authorization")
//            }
//        }
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
            
//            if let response = response as? HTTPURLResponse {
////                completion(.failure(HttpError(statusCode: response.statusCode, message: "Unable to decode response")))
//            }
            
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
    
    
    
    
    
    func performRequest<T: Decodable>(
        endPoint: String,
        method: HTTPMethod = .post,
        formData: [MultipartFormData],
        token: String? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard InternetManager.shared.isConnected else { return }
        
        guard let url = URL(string: NetworkConstants.baseUrl + endPoint) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL string."])))
            return
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Authorization if needed
        if let _ = token {
            if let userData = UserDefaultDataManager.shared.load(forKey: ViewConstants.saveUserDataKey, type: LoginResponseModel.self) {
                request.setValue("Bearer \(userData.token)", forHTTPHeaderField: "Authorization")
            }
        }
        

        var body = Data()
        
        for part in formData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            
            if let value = part.value {
                // Text field
                body.append("Content-Disposition: form-data; name=\"\(part.name)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            } else if let data = part.data, let fileName = part.fileName, let mimeType = part.mimeType {
                // File field
                body.append("Content-Disposition: form-data; name=\"\(part.name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                body.append(data)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        // Upload task
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
                printer.print("✅ Response: \(String(decoding: data, as: UTF8.self))", severity: .high)
                completion(.success(decoded))
            } catch {
                printer.print("❌ Decode error: \(error)", severity: .high)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    
    
}
