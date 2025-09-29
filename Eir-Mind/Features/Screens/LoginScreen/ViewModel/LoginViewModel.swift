//
//  LoginViewModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//

import SwiftUI

let MAIN_THREAD = DispatchQueue.main
let userData = UserDefaultDataManager.shared.load(forKey: ViewConstants.saveUserDataKey, type: LoginResponseModel.self)

enum SignupStates {
    case apple,google,none
}


final class LoginViewModel: ObservableObject {
    
    @Published var email: String = "eirmind.test@gmail.com"
    @Published var password: String = "Dr@12345"
    @Published var signupState: SignupStates = .none
    private var socialLoginAdapter: SocialAuthenticationProvider?
    
    
    init() {
        
        login { isLoginSuccess in
            if isLoginSuccess {
                printer.print("Hurray")
            }
        }
        
//        SocketManagerService.shared.connect()
//        setupSocket()
//        
        
    }
    
    func setupSocket() {
        
        if SocketManagerService.shared.isConnected {
            
            SocketManagerService.shared.emit(event: "diagnose",
                                             data: ["Hello World": "Hello World"])
        }
        SocketManagerService.shared.on(event: "diagnose",
                                       callback: { newMessages, data in
            
            
                
            
        })
        
        
    }
    
    final func onPressGoogleButton() {
        signupState = .google
        performLogin()
    }
    
    final func onPressAppleButton() {
        signupState = .apple
        performLogin()
    }
    
    private func performLogin() {
        var url = "redirect/"
        switch signupState {
        case .apple:
            self.socialLoginAdapter = AppleAuthenticationProvider()
            url += "apple"
        case .google:
//            self.socialLoginAdapter = GoogleAuthenticationProvider()
            url += "google"
        default:
            return
        }
        
        let viewController = getRootViewController()
        Task {
            do {
                let user = try await socialLoginAdapter?.login(viewController: viewController)
                printer.print("Fetch user successful: \(String(describing: user))")
                guard let user else { return }
                var params = ["id_token": user.id, "deviceType": "iOS", "reCaptchaToken": "123"]
                if signupState == .apple {
                    params["name"] = user.name
                }

            } catch {
                print("Error on Perform Login: \(error)")
                MAIN_THREAD.asyncAfter(deadline: .now() + 0.5) { ///
//                     .failure("We couldn’t complete your login. Please try again or use a different method.")
                }
            }
        }
    }
    
    private func getRootViewController() -> UIViewController { /// Return the root view controller, which is the top-level view controller of the app
        return UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first?.rootViewController ?? UIViewController()
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
                                                body: bodyData) { (result: Result<LoginResponseModel, Error>) in
            switch result {
            case .success(let response):
                printer.print(response)
                UserDefaultDataManager.shared.save(response, forKey: ViewConstants.saveUserDataKey)
                completion(true)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
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
