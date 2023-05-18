import Foundation

import Combine


//
//struct ChatMessage: Identifiable, Decodable {
//
//    let id = UUID()
//
//    let message: String
//
//    let isCurrentUser: Bool
//
//}


//
//class ChatViewModel: ObservableObject {
//
//
//    @Published var messages: [ChatMessage] = []
//
//    private let webSocketManager: WebSocketManager
//
//
//    private var roomName: String
//
//    private var userName: String
//
//
//
//    init(webSocketManager: WebSocketManager, roomName: String, userName: String) {
//
//        self.webSocketManager = webSocketManager
//
//        self.roomName = roomName
//
//        self.userName = userName
//
//    }
//
//
//
//    func subscribe(roomName: String, userName: String) {
//
//        webSocketManager.subscribe(roomName: roomName, userName: userName)
//
//    }
//
//
//
//    func sendMessage(_ message: String, roomName: String, userName: String) {
//
//        webSocketManager.send(message, roomName: roomName, userName: userName)
//
//        let chatMessage = ChatMessage(message: message, isCurrentUser: true)
//
//        messages.append(chatMessage)
//        let id = "646536dc56566f5a4fbfe936"
//        let id2="642eed2e07b2caf7c7fdf2e9"// Replace with your actual ID
//        var map: [String: Any] = [:]
//         map["UserM1"] = id
//        map["UserM2"] = id2
//        map["messageUser1"] = message
//        map["RommeName"] = roomName
//        print (roomName)
//        webSocketManager.addMessage(user1Param1: id, roomName: roomName, messageUser1:message) { result in
//                   switch result {
//                   case .success(let messages):
//                       // Handle successful response
//                       print("Added message:", messages)
//                   case .failure(let error):
//                       // Handle error
//                       print("Error:", error)
//                   }
//               }
//
//    }
//
//
//
//}
struct ChatMessage: Identifiable , Decodable {

    let id = UUID()

    let userName: String

    let message: String

    let isCurrentUser: Bool

}



struct UserJoined: Identifiable {

    var id = UUID()

    var userName: String

}



struct UserLeft: Identifiable {

    let id = UUID()

    let userName: String

}



class ChatViewModel: ObservableObject {

    @Published var userLeft: UserLeft?

    @Published var messages: [ChatMessage] = []

    let webSocketManager: WebSocketManager

    var roomName: String

    var userName: String

    @Published var userJoined: UserJoined?



    init(webSocketManager: WebSocketManager, roomName: String, userName: String) {

        self.webSocketManager = webSocketManager

        self.roomName = roomName

        self.userName = userName




        self.webSocketManager.onNewMessageReceived = { [weak self] (userName, message) in

            let isCurrentUser = userName == self?.userName

            let chatMessage = ChatMessage(userName: userName, message: message, isCurrentUser: isCurrentUser)

            DispatchQueue.main.async {

                self?.messages.append(chatMessage)

            }

        }



        self.webSocketManager.onUserJoined = { [weak self] userName in

            print("\(userName) joined the chat")

            DispatchQueue.main.async {

                self?.userJoined = UserJoined(userName: userName)

            }

        }



        self.webSocketManager.onUserLeft = { [weak self] userName in

            print("\(userName) left the chat")

            DispatchQueue.main.async {

                self?.userLeft = UserLeft(userName: userName)

            }

        }

    }



        func subscribe(roomName: String, userName: String) {
    
            webSocketManager.subscribe(roomName: roomName, userName: userName)
    
        }


//    func sendMessage(_ message: String) {
//
//        webSocketManager.send(message, roomName: roomName, userName: userName)
//
//        let chatMessage = ChatMessage(userName: userName, message: message, isCurrentUser: true)
//
//        messages.append(chatMessage)
//
//    }
    func sendMessage(_ message: String, roomName: String, userName: String) {

        webSocketManager.send(message, roomName: roomName, userName: userName)

        let chatMessage = ChatMessage(userName: userName, message: message, isCurrentUser: true)
        

        messages.append(chatMessage)
        let defaults = UserDefaults.standard
        let id = defaults.object(forKey: "id1")
       
        print ("[[[[",roomName)
        webSocketManager.addMessage(user1Param1: id as! String, roomName: roomName, messageUser1:message) { result in
                   switch result {
                   case .success(let messages):
                       // Handle successful response
                       print("Added message:", messages)
                   case .failure(let error):
                       // Handle error
                       print("Error:", error)
                   }
               }

    }




}

