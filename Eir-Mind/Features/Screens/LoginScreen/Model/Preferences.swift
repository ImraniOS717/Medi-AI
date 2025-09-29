//
//  LoginModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//


import Foundation
struct Preferences : Codable {
	let language : String?
	let model : String?
	let transcription_speed : String?

	enum CodingKeys: String, CodingKey {

		case language = "language"
		case model = "model"
		case transcription_speed = "transcription_speed"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		language = try values.decodeIfPresent(String.self, forKey: .language)
		model = try values.decodeIfPresent(String.self, forKey: .model)
		transcription_speed = try values.decodeIfPresent(String.self, forKey: .transcription_speed)
	}

}
