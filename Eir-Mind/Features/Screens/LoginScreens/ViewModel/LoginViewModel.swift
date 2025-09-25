//
//  LoginViewModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    
    @Published var email: String = "eirmind.test@gmail.com"
    @Published var password: String = "Dr@12345"
    @Published var token: String = ""
    
    init() {
        login()
        resetPassword()
        forgotPassword()
        
        SocketManagerService.shared.connect()
        
    }
    
    
    func resetPassword() {
        /// send necessary data in body
        
        let resetPasswordPayLoad = ResetPasswordPayLoad(token: retrieveToken(),
                                                        password: "Dr@12345",
                                                        re_enter_password: "Dr@12345")
        
        guard let bodyData = try? JSONEncoder().encode(resetPasswordPayLoad) else { return }
        
        WebServiceManager.shared.performRequest(endPoint: ApiEndPoints.resetEndPoint,
                                                method: .post,
                                                body: bodyData) { (result: Result<ResetPasswordResponse, Error>) in
            switch result {
            case .success(let response):
                print(response)
            case.failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    func login() {
        /// send necessary data in body
        let loginPayLoad = LoginPayLoad(email: email,
                                        password: password)
        
        guard let bodyData = try? JSONEncoder().encode(loginPayLoad) else {
            print("Failed to encode loginPayLoad to JSON. Payload: \(String(describing: loginPayLoad))")
            return
        }
        
        WebServiceManager.shared.performRequest(endPoint: ApiEndPoints.loginEndPoint,
                                                method: .post,
                                                body: bodyData) { (result: Result<LoginModel, Error>) in
            switch result {
            case .success(let response):
                DataManager.shared.save(response.token, forKey: "tokenSave")
                print(response)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func forgotPassword() {
        /// send necessary data in body
        let forGotPasswordData : [String: String] = [
            "email": email
        ]
        
        guard let bodyData = try? JSONEncoder().encode(forGotPasswordData) else {
            print("Failed to encode forGotPasswordData to JSON. Payload: \(String(describing: forGotPasswordData))")
            return
        }
        
        WebServiceManager.shared.performRequest(endPoint: ApiEndPoints.forgotPasswordEndPoint,
                                                method: .post,
                                                body: bodyData) { (result: Result<ForgotPasswordResponse, Error>) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    func retrieveToken() -> String {
        if let token = UserDefaults.standard.string(forKey: "tokenSave") {
            print("Token")
            self.token = token
        }
        return token
    }
    
    
    
//    func handleStatusCode(statusCode: Int) {
//        switch statusCode {
//            
//        default:
//            break
//        }
//    }
    
    
    
}
