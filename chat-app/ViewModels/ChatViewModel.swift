//
//  ChatViewModel.swift
//  chat-app
//
//  Created by Irfan Izudin on 03/06/23.
//

import Foundation
import Firebase
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var showContactList: Bool = false
    @Published var contacts: [Contact] = []
    @Published var usernameText: String = ""
    @Published var isLoading: Bool = false
    @Published var isContactListEmptyState: Bool = true
    @Published var chatText: String = ""
    
    @Published var chats: [Chat] = [
        Chat(imageURL: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80", username: "chika", lastMessage: "Hi What's up?", isUserMessage: false, lastMessageDate: "Today"),
        Chat(imageURL: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80", username: "james", lastMessage: "I'm busy right now", isUserMessage: true, lastMessageDate: "Yesterday"),
    ]
    
    func findContact() {
        
        self.contacts.removeAll()
        
        self.isLoading = true
        self.isContactListEmptyState = false
        
        Firestore.firestore().collection("Users").whereField("username", isEqualTo: usernameText)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Failed to get document: ", error.localizedDescription)
                    
                } else {
                    self.isLoading = false

                    for document in snapshot!.documents {
                        let document = document.data()
                        
                        let imageURL = document["photoURL"] as? String
                        let username = document["username"] as? String
                        let fullName = document["fullName"] as? String
                        let contact = Contact(imageURL: imageURL, username: username, fullName: fullName)
                        self.contacts.append(contact)
                    }

                }
                
            }
    }
    
    func createNewMessage(toUserId: String, chat: Chat) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let data: [String: Any] = [
            "toUserId": toUserId,
            "photoURL": chat.imageURL ?? "",
            "username": chat.username ?? "",
            "lastMessage": "",
            "isUserMessage": "",
            "lastMessageDate": "",
            "createdAt": Timestamp(date: Date()),
            "updatedAt": Timestamp(date: Date())
        ]

        Firestore.firestore().collection("Users").document(userId).collection("Messages").document(toUserId).setData(data) { error in
            if let error = error {
                print("Failed to create new message: ", error.localizedDescription)
            } else {
                print("Successfully create new message")
            }
        }
        
    }
    
}
