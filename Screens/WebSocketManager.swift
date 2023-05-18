import Foundation

import SocketIO



class WebSocketManager {

    private let manager: SocketManager

    private let socket: SocketIOClient

    private(set) var connected: Bool = false



    init(socketURL: URL) {

        manager = SocketManager(socketURL: URL(string: "ws://127.0.0.1:3000")!, config: [.log(false), .compress])

        socket = manager.defaultSocket

        configureCallbacks()

        socket.connect()

        

    }


    

    func connect() {

        if connected {

            print("Already connected to the socket server")

            return

        }

        

        socket.connect()

    }

    func jsonStringFrom(dictionary: [String: Any]) -> NSArray? {

        if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {

            do {

                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray {

                    return array

                }

            } catch {

                print("Error in converting to NSArray: \(error.localizedDescription)")

            }

        }

        return nil

    }



    func disconnect() {

        socket.disconnect()

        connected = false

    }

    func subscribe(roomName: String, userName: String) {

        if connected {

            let roomData: [String: Any] = ["roomName": roomName, "userName": userName]

            socket.emit("subscribe", with: [roomData]) {

                print("Subscribed to room: \(roomName)")

            }

        } else {

            socket.once("connect") { [weak self] _, _ in

                let roomData: [String: Any] = ["roomName": roomName, "userName": userName]

                self?.socket.emit("subscribe", with: [roomData]) {

                    print("Subscribed to room: \(roomName)")

                }

            }

        }

    }



    func send(_ message: String, roomName: String, userName: String) {

        guard connected else {

            print("Cannot send message. Not connected to the server")

            return

        }



        let messageData: [String: Any] = ["messageContent": message, "roomName": roomName, "userName": userName]

        socket.emit("newMessage", with: [messageData]) {

            print("Sent message: \(message)")

        }

    }
//    func addMessage(id: String, roomName: String, map: [String: Any], completion: @escaping (Result<ChatMessage, Error>) -> Void) {
//        let url = URL(string: "http://127.0.0.1:3000/Message/addmessage/\(id)/\(roomName)")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            print("Response data:", data)
//
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
//                return
//            }
//
//            do {
//                let messages = try JSONDecoder().decode(ChatMessage.self, from: data)
//                completion(.success(messages))
//                         print("messages data:", messages)
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }

    func addMessage(user1Param1: String, roomName: String, messageUser1: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let defaults = UserDefaults.standard
        let url = URL(string: "http://127.0.0.1:3000/Message/addmessage/\(user1Param1)/\(roomName)")!
        let id = defaults.object(forKey: "id1")
        let id2=defaults.object(forKey: "id2")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody: [String: Any] = [
            "UserM1" : id ,
            "UserM2" : id2 ,
            "messageUser1" : messageUser1 ,
            "RommeName" : roomName
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
        }.resume()
    }

    private func configureCallbacks() {

        socket.on(clientEvent: .connect) { [weak self] data, _ in

            print("Connected to the socket server at \(Date())")

            self?.connected = true

        }

        socket.on(clientEvent: .disconnect) { [weak self] _, _ in

            print("Disconnected from the socket server at \(Date())")

            self?.connected = false

        }
        socket.on(clientEvent: .error) { data, _ in

            if let error = data.first as? String {

                // Check if the error string is actually the handshake data

                if error.contains("\"sid\"") && error.contains("\"upgrades\"") &&

                   error.contains("\"pingInterval\"") && error.contains("\"pingTimeout\"") {

                    print("Received initial handshake data from server, not an actual error.")

                } else {

                    print("Socket error: \(error)")

                }

            }

        }



        





        socket.on("newUserToChatRoom") { data, _ in

            if let userName = data[0] as? String {

                print("User \(userName) joined the room")

            }

        }



        socket.on("userLeftChatRoom") { data, _ in

            if let userName = data[0] as? String {

                print("User \(userName) left the room")

            }

        }

        socket.on(clientEvent: .error) { data, _ in

            if let error = data.first as? String {

                if error.hasPrefix("96:0") {

                    print("Received initial handshake data from server, not an actual error.")

                } else {

                    print("Socket error: \(error)")

                }

            }

        }



        socket.on("updateChat") { data, _ in

            if let chatData = data[0] as? [String: Any],

               let userName = chatData["userName"] as? String,

               let messageContent = chatData["messageContent"] as? String {

                print("[\(userName)] \(messageContent)")

            }

        }

    }

}

