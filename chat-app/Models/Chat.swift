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

struct Chat: Identifiable {
    var id: String { documentId }
    let documentId: String
    let fromId: String?
    let toId: String?
    let text: String?
    let createdAt: Date?
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data["fromId"] as? String
        self.toId = data["toId"] as? String
        self.text = data["text"] as? String
        self.createdAt = data["createdAt"] as? Date
    }

}
