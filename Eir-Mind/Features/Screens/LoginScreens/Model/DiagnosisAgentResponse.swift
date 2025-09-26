//
//  DiagnosisAgentModel.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 26/09/2025.
//

import Foundation

struct DiagnosisAgentResponse: Codable {
    
    let _id: String
    let agentName: String
    let description: String
    let modelType: String
    let temperature: Double
    let prompt: String
    
}
