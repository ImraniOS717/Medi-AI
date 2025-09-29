//
//  TranscriptionResponse.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 29/09/2025.
//

import Foundation

struct TranscriptionResponse: Codable {
    let text: String
    let language: String
    let duration: Int
    let error: String
}
