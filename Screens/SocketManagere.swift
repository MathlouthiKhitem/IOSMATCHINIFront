import Foundation
import SwiftUI
import Starscream

class SocketManagere: ObservableObject, WebSocketDelegate {
    var socket: WebSocket!

    init() {
        guard let socketURL = URL(string: "ws://127.0.0.1:3000") else {
            print("Invalid socket URL")
            return
        }

        let request = URLRequest(url: socketURL)
        socket = WebSocket(request: request)
      
        socket.delegate = self
        socket.connect()
        print("request",socket.connect())

    }

    func connect() {
        socket.connect()
    }

    func websocketDidConnect(socket: WebSocketClient) {
        print("Socket connected")

        // Subscribe event
        let subscribeEvent = [
            "userName": "YourUserName",
            "roomName": "YourRoomName"
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: subscribeEvent),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            socket.write(string: jsonString)
        }
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Socket disconnected")
        if let error = error {
            print(error)
        }
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Received message: \(text)")
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data")
    }

}
