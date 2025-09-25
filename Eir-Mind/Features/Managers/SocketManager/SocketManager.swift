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
    
    private let socketURL = URL(string: "http://medai-django.fly.dev/api/docs/ws/diagnose/")!
    
    var socketConnected: (() -> Void)?
    
    private init() {
        manager = SocketManager(socketURL: socketURL, config: [.log(true), .compress])
        socket = manager.defaultSocket
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
