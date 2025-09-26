//
//  UserDefaultDataManager.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//


import Foundation
import SwiftUI


extension UserDefaults {
    
    private enum Keys {
        static let tokenSave = "tokenSave"
    }

    /// Read-only computed property to get saved token
    var tokenSave: String? {
        return string(forKey: Keys.tokenSave)
    }

    /// Read-write computed property to get or set token
    var savedToken: String {
        get {
            return string(forKey: Keys.tokenSave) ?? ""
        }
        set {
            set(newValue, forKey: Keys.tokenSave)
        }
    }
}


final class UserDefaultDataManager {
    static let shared: UserDefaultDataManager = UserDefaultDataManager()
    private let defaults = UserDefaults.standard
    
    @AppStorage("tokenSave") var token: String = ""
    
    private init() {}
    
    // MARK: - Save
    func save<T: Codable>(_ object: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            defaults.set(data, forKey: key)
        }
    }
    
    // MARK: - Load
    func load<T: Codable>(forKey key: String, type: T.Type) -> T? {
        guard let data = defaults.data(forKey: key),
              let object = try? JSONDecoder().decode(type, from: data) else {
            return nil
        }
        return object
    }
    
    
    func saved<T: Codable>(_ object: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            defaults.set(data, forKey: key)
        }
    }
    
    func getObject<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    
    // MARK: - Remove
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
