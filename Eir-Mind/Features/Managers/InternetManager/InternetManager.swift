//
//  InternetManager.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 26/09/2025.
//

import Foundation
import Network

/// this class responsible for internet connectivity

protocol InternetConnectivity {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

final class InternetManager: InternetConnectivity {
    
    static let shared: InternetManager = InternetManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetMonitorQueue")
    
    private(set) var isConnected: Bool = true {
        didSet {
            if oldValue != isConnected {
                MAIN_THREAD.async {
                    NotificationCenter.default.post(name: .internetStatusChanged, object: self.isConnected)
                    NotificationCenter.default.post(name: .internetResumed, object: self.isConnected)
                }
            }
        }
    }
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

