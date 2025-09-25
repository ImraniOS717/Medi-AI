//
//  LoginModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//

import Foundation

struct LoginModel: Codable {
    let type : String
    let msg : String
    let token : String
}

/// send data to server
struct LoginPayLoad: Codable {
    let email: String
    let password: String
}

/// response
struct ForgotPasswordResponse: Codable {
    let type: String
    let msg: String
}
