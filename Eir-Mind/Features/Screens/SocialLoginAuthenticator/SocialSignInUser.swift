//
//  SocialSignInUser.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 27/9/2025.
//


import Foundation
/// Struct representing a user
struct SocialSignInUser {
    let id: String
    let name: String
    let email: String
    let profilePicUrl: String?
    let provider: SocialLoginProvider?
    var device_id: String?
}
