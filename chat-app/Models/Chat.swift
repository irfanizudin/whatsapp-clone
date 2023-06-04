//
//  Chat.swift
//  chat-app
//
//  Created by Irfan Izudin on 04/06/23.
//

import Foundation

struct Contact {
    let imageURL: String?
    let username: String?
    let fullName: String?
}

struct Chat {
    let imageURL: String?
    let username: String?
    let lastMessage: String?
    let isUserMessage: Bool?
    let lastMessageDate: String?
}
