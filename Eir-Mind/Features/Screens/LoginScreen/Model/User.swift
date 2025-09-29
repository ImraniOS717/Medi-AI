//
//  LoginModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//



import Foundation
struct User : Codable {
	let _id : String?
	let name : String?
	let email : String?
	let speciality : String?
	let number : String?
	let user_active : Bool?
	let default_format : String?
	let role : String?
	let transcription_settings : Transcription_settings?
	let org_id : String?
	let preferences : Preferences?
	let last_login : String?

	enum CodingKeys: String, CodingKey {

		case _id = "_id"
		case name = "name"
		case email = "email"
		case speciality = "speciality"
		case number = "number"
		case user_active = "user_active"
		case default_format = "default_format"
		case role = "role"
		case transcription_settings = "transcription_settings"
		case org_id = "org_id"
		case preferences = "preferences"
		case last_login = "last_login"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		speciality = try values.decodeIfPresent(String.self, forKey: .speciality)
		number = try values.decodeIfPresent(String.self, forKey: .number)
		user_active = try values.decodeIfPresent(Bool.self, forKey: .user_active)
		default_format = try values.decodeIfPresent(String.self, forKey: .default_format)
		role = try values.decodeIfPresent(String.self, forKey: .role)
		transcription_settings = try values.decodeIfPresent(Transcription_settings.self, forKey: .transcription_settings)
		org_id = try values.decodeIfPresent(String.self, forKey: .org_id)
		preferences = try values.decodeIfPresent(Preferences.self, forKey: .preferences)
		last_login = try values.decodeIfPresent(String.self, forKey: .last_login)
	}

}
