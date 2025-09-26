//
//  SocketManager.swift
//  Eir-Mind
//
//  Created by Ibtidah MacMini on 25/09/2025.
//

import Foundation
import SocketIO

final class SocketManagerService {
    
    static let shared: SocketManagerService = SocketManagerService()
    
    private var manager: SocketManager
    private var socket: SocketIOClient
    
    private let socketURL = URL(string: "http://medai-django.fly.dev")!
    
    var socketConnected: (() -> Void)?
    private let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODgwZTVmODc3OTUxYmQ5ZTc3ODdkOTMiLCJyb2xlIjoidXNlciIsImVtYWlsIjoiZWlybWluZC50ZXN0QGdtYWlsLmNvbSIsImlzX2FjdGl2ZSI6dHJ1ZSwiZXhwIjoxNzU4OTU1OTQ0fQ.-vGZ8Pny053m08Xzx_cRR-kI8E5hKPs1yJr2RB3Zly0"

    
    private init() {
        manager = SocketManager(socketURL: socketURL,
                                config: [.log(true),
                                .compress,
                                .extraHeaders(["Authorization": "Bearer \(token)"])
])
        socket = manager.defaultSocket
        socket = manager.socket(forNamespace: "/diagnose")
    }
    
    // MARK: - Connection
    func connect() {
        addHandlers()
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    var isConnected: Bool {
        return socket.status == .connected
    }
    
    // MARK: - Emit Events
    func emit(event: String, data: [String: Any]) {
        socket.emit(event, data)
    }
    
    // MARK: - Listen to Events
    func on(event: String, callback: @escaping ([Any], SocketAckEmitter) -> Void) {
        socket.on(event, callback: callback)
    }
    
    func off(event: String) {
        socket.off(event)
    }
    
    // MARK: - Handlers
    private func addHandlers() {
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("Socket disconnected")
        }
        
        socket.on(clientEvent: .error) { data, ack in
            print("Socket error: \(data)")
        }
        
        socket.on(clientEvent: .statusChange) { data, ack in
            print("Socket status changed: \(data)")
        }
    }
}
