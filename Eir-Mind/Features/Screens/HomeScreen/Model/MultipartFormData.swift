//
//  MultipartFormData.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 29/09/2025.
//

import Foundation

struct MultipartFormData {
    let name: String
    var fileName: String?
    var mimeType: String?
    var data: Data?
    var value: String?
    
    init(name: String, fileName: String, mimeType: String, data: Data) {
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
