//
//  LoginModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//

import Foundation
struct Transcription_settings : Codable {
	let input_language : String?
	let output_language : String?
	let model : String?
	let temperature : Double?
	let transcription_interval : Int?
	let auto_transcribe : Bool?
	let silence_threshold : Double?
	let sample_rate : Int?

	enum CodingKeys: String, CodingKey {

		case input_language = "input_language"
		case output_language = "output_language"
		case model = "model"
		case temperature = "temperature"
		case transcription_interval = "transcription_interval"
		case auto_transcribe = "auto_transcribe"
		case silence_threshold = "silence_threshold"
		case sample_rate = "sample_rate"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		input_language = try values.decodeIfPresent(String.self, forKey: .input_language)
		output_language = try values.decodeIfPresent(String.self, forKey: .output_language)
		model = try values.decodeIfPresent(String.self, forKey: .model)
		temperature = try values.decodeIfPresent(Double.self, forKey: .temperature)
		transcription_interval = try values.decodeIfPresent(Int.self, forKey: .transcription_interval)
		auto_transcribe = try values.decodeIfPresent(Bool.self, forKey: .auto_transcribe)
		silence_threshold = try values.decodeIfPresent(Double.self, forKey: .silence_threshold)
		sample_rate = try values.decodeIfPresent(Int.self, forKey: .sample_rate)
	}

}
