//
//  DataManager.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//


import Foundation

final class DataManager {
    static let shared: DataManager = DataManager()
    private let defaults = UserDefaults.standard
    
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
    
    // MARK: - Remove
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
