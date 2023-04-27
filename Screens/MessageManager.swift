//
//  MessageManager.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 27/4/2023.
//


import Foundation

class MessagesManager: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published private(set) var lastMessageId: String = ""
    
}
