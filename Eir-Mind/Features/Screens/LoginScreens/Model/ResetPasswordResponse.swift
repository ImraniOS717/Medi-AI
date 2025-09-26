//
//  ResetPasswordResponse.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//

import Foundation

struct ResetPasswordResponse: Codable {
    let token: String
    let msg: String
}
/// send to server
struct ResetPasswordPayLoad: Codable {
    let token: String
    let password: String
    let re_enter_password: String
}
