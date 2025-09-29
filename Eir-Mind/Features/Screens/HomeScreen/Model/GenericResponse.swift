//
//  GenericResponse.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 26/09/2025.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    let type: String
    let msg: String
    let data: T?
}

struct EmptyData: Codable {}
