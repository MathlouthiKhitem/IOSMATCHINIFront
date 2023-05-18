import SwiftUI



import SwiftUI



struct chats: View {

    @StateObject private var viewModel: ChatViewModel

    @State private var message: String = ""

   // @State private var roomName: String = ""
    let roomName: String ;

    @State private var userName: String = ""



    init(webSocketManager: WebSocketManager, userName: String, roomName: String) {

        _viewModel = StateObject(wrappedValue: ChatViewModel(webSocketManager: webSocketManager, roomName: roomName, userName: userName))
        self.roomName = roomName
    

        _userName = State(initialValue: userName)

    }

 

    var body: some View {
       // Text("romeName: \(roomName)")
        VStack {

            List(viewModel.messages) { chatMessage in

                HStack {

                    if chatMessage.isCurrentUser {

                        Spacer()

                        Text(chatMessage.message)

                            .padding()

                            .background(Color.blue)

                            .foregroundColor(.white)

                            .clipShape(RoundedRectangle(cornerRadius: 10))

                    } else {

                        Text(chatMessage.message)

                            .padding()

                            .background(Color.gray)

                            .foregroundColor(.white)

                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        Spacer()

                    }

                }

            }



            HStack {

                TextField("Type your message...", text: $message)

                    .textFieldStyle(RoundedBorderTextFieldStyle())



                Button("Send") {

                    viewModel.sendMessage(message, roomName: roomName, userName: userName)

                    message = ""

                }

            }

            .padding()

        }

        .onAppear {

            print("test hamma")

            viewModel.subscribe(roomName: roomName, userName: userName)

        }

    }

}
