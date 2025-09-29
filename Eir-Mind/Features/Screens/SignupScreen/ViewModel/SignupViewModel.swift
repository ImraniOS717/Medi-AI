//
//
//  SignupView.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 29/09/2025.
//

import SwiftUI

final class SignupViewModel: ObservableObject {
    
    // MARK: - Init()
    // MARK: - Body
    // MARK: - Private Variables and Properties
    // MARK: -

    // MARK: - Helpers
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
                                                body: body) { (result: Result<GenericResponse<EmptyData>, Error>) in
            
            
            switch result {
            case.success(let response):
                print(response)
            case.failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
}
