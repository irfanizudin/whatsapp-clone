//
//  ChatViewModel.swift
//  chat-app
//
//  Created by Irfan Izudin on 03/06/23.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var showContactList: Bool = false
    @Published var contacts: [Contact] = [
        Contact(imageURL: "https://firebasestorage.googleapis.com:443/v0/b/chat-app-41388.appspot.com/o/B1458DD0-44B1-473D-956A-2DB243DE225C?alt=media&token=db87fe33-628d-4001-8c04-8493fa0a60ed"
, size: 50, username: "irfanizudin", fullName: "Irfan Izudin"),
        Contact(imageURL: "https://firebasestorage.googleapis.com:443/v0/b/chat-app-41388.appspot.com/o/B1458DD0-44B1-473D-956A-2DB243DE225C?alt=media&token=db87fe33-628d-4001-8c04-8493fa0a60ed"
, size: 50, username: "irfanizudin", fullName: "Irfan Izudin"),
        Contact(imageURL: "https://firebasestorage.googleapis.com:443/v0/b/chat-app-41388.appspot.com/o/B1458DD0-44B1-473D-956A-2DB243DE225C?alt=media&token=db87fe33-628d-4001-8c04-8493fa0a60ed"
, size: 50, username: "irfanizudin", fullName: "Irfan Izudin"),
    ]
    @Published var usernameText: String = ""
}
