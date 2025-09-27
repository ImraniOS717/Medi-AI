import Foundation

struct PreferencesPayload : Codable {
	let language : String?
	let model : String?
	let transcription_speed : String?
}
