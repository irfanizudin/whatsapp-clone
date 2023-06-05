//
//  Chat.swift
//  chat-app
//
//  Created by Irfan Izudin on 04/06/23.
//

import Foundation

struct Contact {
    let documentId: String?
    let imageURL: String?
    let username: String?
    let fullName: String?
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.imageURL = data["photoURL"] as? String
        self.username = data["username"] as? String
        self.fullName = data["fullName"] as? String
    }
}

struct Chat {
    let imageURL: String?
    let username: String?
    let lastMessage: String?
    let isUserMessage: Bool?
    let lastMessageDate: String?
}
