//
//  LoginModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//

import Foundation
struct SignupResponsePayload : Codable {
	let name : String?
	let email : String?
	let password : String?
	let re_enter_password : String?
	let recaptchaToken : String?
	let speciality : String?
	let org_id : String?
	let preferences : PreferencesPayload?
}
