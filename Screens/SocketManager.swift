//
//  SocketManager.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 18/5/2023.
//
import SwiftUI
import Starscream

class SocketManager: ObservableObject, WebSocketDelegate {
    func websocketDidReceiveMessage(socket: Starscream.WebSocketClient, text: String) {
        print("websocketDidReceiveMessage")
    }
    
    func websocketDidReceiveData(socket: Starscream.WebSocketClient, data: Data) {
        print("websocketDidReceiveData")
    }
    
    @Published var isConnected = false
    var socket: WebSocket!

    init() {
        guard let socketURL = URL(string: "http://localhost:3000/") else {
            print("Invalid socket URL")
            return
        }

        let request = URLRequest(url: socketURL)
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }

    func websocketDidConnect(socket: WebSocketClient) {
        print("Socket connected")
        DispatchQueue.main.async {
            self.isConnected = true
        }
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Socket disconnected")
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }
}

