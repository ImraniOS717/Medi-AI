//
//  LoginViewModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//

import SwiftUI

let MAIN_THREAD = DispatchQueue.main

final class LoginViewModel: ObservableObject {
    
    @Published var email: String = "eirmind.test@gmail.com"
    @Published var password: String = "Dr@12345"
    @Published var token: String = ""
    @Published var agentName: String = ""
    @Published var statusCode: Int = 0
    let userDefaultKey = "userDefaultKey"
    let userDefault = UserDefaults.standard
    
    
    init() {
        login { [weak self] isLoginSuccessfully in
            guard let self else { return }
            if isLoginSuccessfully {
                
                
                getAgents {  isGetAgentSuccessfully  in
                    
                    
                    if isGetAgentSuccessfully {
                        self.resetPassword()
                        
                    }
                    
                }
                
            }
            
            transcriptionSettings()
            signUpApi()
            
        }
        
        
//        SocketManagerService.shared.connect()
//        
//        SocketManagerService.shared.on(event: "diagnose") { data, ack in
//            print("Received data: \(data)")
//            if let jsonData = try? JSONSerialization.data(withJSONObject: data[0], options: []),
//               let response = try? JSONDecoder().decode(SocketResponse.self, from: jsonData) {
//                print("Decoded response: \(response)")
//            }
//        }
//        
//        // Emit event
//        SocketManagerService.shared.emit(event: "diagnose", data: ["key": "value"])
        
        // Disconnect when needed
//        SocketManagerService.shared.disconnect()

        
        
        
    }
    
    
    func getAgents(completion: @escaping ((Bool) -> Void)) {
//        let token = retrieveToken()
        
        guard !token.isEmpty else {
            print("❌ Cannot get agents: No token found.")
            completion(false)
            return
        }
        
        WebServiceManager.shared.performRequest(endPoint: ApiEndPoints.diagnosisAgentEndPoint,
                                                method: .get,
                                                token: self.token,
                                                completion: { (result: Result<GenericResponse<[DiagnosisAgentResponse]>, Error>) in
            switch result {
            case .success(let response):
                print("✅ Get Agents Response: \(response)")
                
//                if response.type == "success" {
//                    let listOfAgents = response.data
////                    listOfAgents.forEach(print($0.agentName))
//                }
//                
//                let listOfAgents = response.data
////                listOfAgents.forEach { print($0.agentName) }

                
                
                completion(true)
                
                
            case .failure(let error):
                print("❌ Failed to Get Agents: \(error.localizedDescription)")
                completion(false)
            }
        },statusCode: { statusCode in
            
            
        }
        )
    }

    
    
    func signUpApi() {
        
        
        let preferencesPayLoad = PreferencesPayload(language: "english",
                                                    model: "gpt-4",
                                                    transcription_speed: "5.3")
        let signUpPayLoad = SignupResponsePayload(name: "Faraz",
                                                  email: "faraz@gmail.com",
                                                  password: "12345Faraz",
                                                  re_enter_password: "12345Faraz",
                                                  recaptchaToken: "",
                                                  speciality: "Doctor",
                                                  org_id: "",
                                                  preferences: preferencesPayLoad)
        
        guard let body = try? JSONEncoder().encode(signUpPayLoad) else {
            return
        }
        
        WebServiceManager.shared.performRequest(endPoint: ApiEndPoints.signUpEndPoint,
                                                method: .post,
                                                body: body,
                                                token: retrieveToken()) { (result: Result<GenericResponse<EmptyData>, Error>) in
            
            
            switch result {
            case.success(let response):
                print(response)
            case.failure(let error):
                print(error.localizedDescription)
                
            }
            
            
            
        }
    }
    
    func transcriptionSettings() {
        
        
        WebServiceManager.shared.performRequest(endPoint: ApiEndPoints.transcriptionSettingsEndPoint,
                                                method: .post,
                                                token: retrieveToken()) { (result: Result<GenericResponse<EmptyData>, Error>) in
            
            switch result {
            case.success(let response):
                print(response)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func resetPassword() {
        /// send necessary data in body
        
        let resetPasswordPayLoad = ResetPasswordPayLoad(token: retrieveToken(),
                                                        password: "Dr@12345789",
                                                        re_enter_password: "Dr@12345789")
        
        guard let bodyData = try? JSONEncoder().encode(resetPasswordPayLoad) else { return }
        
        WebServiceManager.shared.performRequest(endPoint: ApiEndPoints.resetEndPoint,
                                                method: .post,
                                                body: bodyData,
                                                token: retrieveToken()) { (result: Result<ResetPasswordResponse, Error>) in
            switch result {
            case .success(let response):
                print(response)
            case.failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    func login(completion: @escaping ((Bool) -> Void)) {
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
                UserDefaultDataManager.shared.save(response.token, forKey: "tokenSave")
                print(response)
                
                self.userDefault.set(response.token, forKey: self.userDefaultKey)
                
                MAIN_THREAD.async {
                    self.token = response.token
                    print("🔐 Logged in token: \(self.token)")
                    completion(true)
                }

                print(self.token)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(false)
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
                self.handleStatusCodeForLoginApi(statusCode: self.statusCode)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                
            }
        } statusCode: { statusCode in
            self.statusCode = statusCode
        }
    }
    
    
    func retrieveToken() -> String {
        if let token = UserDefaults.standard.string(forKey: userDefaultKey) {
            print("🔐 Retrieved Token: \(token)")
            return token
        } else {
            print("❌ Token not found in UserDefaults")
            return ""
        }
    }

    
    
//    401
//    Incorrect password
//
//    403
//    User is inactive
//
//    500
//    Internal Server Error
    
    
    func handleStatusCodeForLoginApi(statusCode: Int) {
        switch statusCode {
        case 401:
            print("Incorrect password")
        case 403:
            print("User is inactive")
        case 500:
            print("Internal Server Error")
        default:
            break
        }
    }
    
    
    
}
