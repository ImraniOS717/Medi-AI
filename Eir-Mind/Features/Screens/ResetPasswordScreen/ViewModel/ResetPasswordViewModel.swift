//
//  NewPasswordViewModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 29/09/2025.
//

import SwiftUI

class ResetPasswordViewModel: ObservableObject {
        
    // MARK: - Init()
    // MARK: - Body
    // MARK: - Private Variables and Properties
    
    // MARK: -

    // MARK: - Helpers
    func resetPassword() {
        /// send necessary data in body
        
        let userData = UserDefaultDataManager.shared.load(forKey: ViewConstants.saveUserDataKey, type: LoginResponseModel.self)
        let resetPasswordPayLoad = ResetPasswordPayLoad(token: userData?.token ?? "",
                                                        password: "Dr@12345789",
                                                        re_enter_password: "Dr@12345789")
        
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
    
    
}
