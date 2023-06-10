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
    @Published var contacts: [RecentChat] = []
    @Published var usernameText: String = ""
    @Published var isLoading: Bool = false
    @Published var isContactListEmptyState: Bool = true
    @Published var chatText: String = ""
    @Published var moveToChatMessage: Bool = false
    @Published var recipientUser: RecentChat?
    @Published var currentUserId: String = ""
    @Published var showChatAlert: Bool = false
    @Published var chatAlertMessage: String = ""
    @Published var scrollToBottom: Bool = false
    
    @Published var chats: [Chat] = []
    @Published var recentChat: [RecentChat] = []
    
    func getCurrentUserId() {
        self.currentUserId = Auth.auth().currentUser?.uid ?? ""
    }
    
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
                        let documentId = document.documentID
                        let data = document.data()
                    
                        let contact = RecentChat(documentId: documentId, data: data)
                        self.contacts.append(contact)
//                        print(self.contacts)
                    }

                }
                
            }
    }
    
    func createNewMessage(recipientUser: RecentChat) {
        
        guard let fromId = Auth.auth().currentUser?.uid
        else { return }
        
        let toId = recipientUser.documentId

        let data: [String: Any] = [
            "fromId": fromId,
            "toId": toId,
            "text": chatText,
            "createdAt": Timestamp(date: Date()),
        ]

        Firestore.firestore().collection("Messages").document(fromId).collection(toId).document().setData(data) { error in
            if let error = error {
                print("Failed to send message from currenUser: ", error.localizedDescription)
            } else {
                print("Successfully current user send message")
            }
        }
        
        Firestore.firestore().collection("Messages").document(toId).collection(fromId).document().setData(data) { error in
            if let error = error {
                print("Failed to send message from recipient: ", error.localizedDescription)
            } else {
                print("Successfully recipient send message")
            }

        }
        
        DispatchQueue.main.async {
            self.chatText = ""
            self.scrollToBottom.toggle()
        }

        saveRecentMessage(recipientUser: recipientUser)
        
    }
    
    func fetchChatMessages(recipientUser: RecentChat) {
        
        self.chats.removeAll()

        guard let fromId = Auth.auth().currentUser?.uid,
              let toId = recipientUser.toId
        else { return }

        Firestore.firestore().collection("Messages").document(fromId).collection(toId).order(by: "createdAt").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Failed to fetch chat messages: ", error.localizedDescription)
            } else {
                
                snapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let documentId = change.document.documentID
                        let data = change.document.data()
                        let chat = Chat(documentId: documentId, data: data)
                        self.chats.append(chat)
                    }
                })
                print("Successfully fetch chat messages")
                DispatchQueue.main.async {
                    self.scrollToBottom.toggle()
                }
            }
        }
    }
    
    func convertBubbleChatTimeStamp(timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale.current
        let formattedTime = dateFormatter.string(from: date)

        return formattedTime
    }
    
    func saveRecentMessage(recipientUser: RecentChat) {
        guard let fromId = Auth.auth().currentUser?.uid,
              let toId = recipientUser.toId,
              let photoURL = recipientUser.photoURL,
              let username = recipientUser.username
        else { return }

        let data: [String: Any] = [
            "fromId": fromId,
            "toId": toId,
            "text": chatText,
            "createdAt": Timestamp(date: Date()),
            "photoURL": photoURL,
            "username": username
        ]

        Firestore.firestore().collection("RecentMessages").document(fromId).collection("Messages").document(toId).setData(data) { error in
            if let error = error {
                print("Failed to save recent message from currenUser: ", error.localizedDescription)
            } else {
                print("Successfully current user save recent message")
            }
        }
        
        Firestore.firestore().collection("RecentMessages").document(toId).collection("Messages").document(fromId).setData(data) { error in
            if let error = error {
                print("Failed to save recent message from recipient: ", error.localizedDescription)
            } else {
                print("Successfully recipient save recent message")
            }

        }

    }
    
    func fetchRecentMessages() {
        guard let fromId = Auth.auth().currentUser?.uid
        else { return }

        Firestore.firestore().collection("RecentMessages").document(fromId).collection("Messages").order(by: "createdAt").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Failed to fetch recent chat messages: ", error.localizedDescription)
            } else {
                
                snapshot?.documentChanges.forEach({ change in
                        let documentId = change.document.documentID
                        let data = change.document.data()
                        let recentChat = RecentChat(documentId: documentId, data: data)
                    self.recentChat.removeAll()
                    self.recentChat.append(recentChat)
                    
                })
//                print(self.recentChat)
                print("Successfully fetch recent chat messages")
            }
        }

    }
    
}
