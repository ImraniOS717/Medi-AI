//
//  ForgotPasswordViewModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 29/09/2025.
//

import Foundation

class ForgotPasswordViewModel: ObservableObject {
    
    // MARK: - Init()
    // MARK: - Body
    // MARK: - Private Variables and Properties
    // MARK: -
    // MARK: - Helpers
    func forgotPassword() {
        /// send necessary data in body
        let forGotPasswordData : [String: String] = [
            "email": userData?.user?.email ?? ""
        ]
        
        guard let bodyData = try? JSONEncoder().encode(forGotPasswordData) else {
            print("Failed to encode forGotPasswordData to JSON. Payload: \(String(describing: forGotPasswordData))")
            return
        }
        
        WebServiceManager.shared.performRequest(endPoint: ApiEndPoints.forgotPasswordEndPoint,
                                                method: .post,
                                                body: bodyData) { (result: Result<ForgotPasswordResponse, Error>)  in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
}
