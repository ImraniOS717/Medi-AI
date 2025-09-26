//
//  SocketResponse.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 26/09/2025.
//

import Foundation

struct SocketResponse : Codable {
    let event : String?
    let payload : Payload?
    
    enum CodingKeys: String, CodingKey {
        
        case event = "event"
        case payload = "payload"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        event = try values.decodeIfPresent(String.self, forKey: .event)
        payload = try values.decodeIfPresent(Payload.self, forKey: .payload)
    }
    
}

struct Payload : Codable {
    let token : String?
    let query : String?
    let session_id : String?
    let responses : [String]?
    let agents : [String]?
    let context_docs : [String]?
    let temperature : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case token = "token"
        case query = "query"
        case session_id = "session_id"
        case responses = "responses"
        case agents = "agents"
        case context_docs = "context_docs"
        case temperature = "temperature"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        query = try values.decodeIfPresent(String.self, forKey: .query)
        session_id = try values.decodeIfPresent(String.self, forKey: .session_id)
        responses = try values.decodeIfPresent([String].self, forKey: .responses)
        agents = try values.decodeIfPresent([String].self, forKey: .agents)
        context_docs = try values.decodeIfPresent([String].self, forKey: .context_docs)
        temperature = try values.decodeIfPresent(Double.self, forKey: .temperature)
    }
}
