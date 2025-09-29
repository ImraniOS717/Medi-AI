//
//  LoginModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//

import Foundation

struct LoginResponseModel : Codable {
    let type : String?
    let msg : String?
    let user : User?
    let token : String?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "type"
        case msg = "msg"
        case user = "user"
        case token = "token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
        user = try values.decodeIfPresent(User.self, forKey: .user)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
    
}



/// send data to server
struct LoginPayLoad: Codable {
    let email: String
    let password: String
}
