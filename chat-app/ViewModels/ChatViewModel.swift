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
    @Published var moveToChatMessage: Bool = false
    @Published var recipientUser: Contact?
    @Published var currentUserId: String = ""
    @Published var showChatAlert: Bool = false
    @Published var chatAlertMessage: String = ""
    @Published var scrollToBottom: Bool = false
    
    @Published var chats: [Chat] = []
    
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
                    
                        let contact = Contact(documentId: documentId, data: data)
                        self.contacts.append(contact)
                    }

                }
                
            }
    }
    
    func createNewMessage(recipientUser: Contact) {
        
        guard let fromId = Auth.auth().currentUser?.uid,
              let toId = recipientUser.documentId
        else { return }
        

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
        
        chatText = ""
        self.scrollToBottom.toggle()
        
    }
    
    func fetchChatMessages(recipientUser: Contact) {
        
        guard let fromId = Auth.auth().currentUser?.uid,
              let toId = recipientUser.documentId
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
                print(self.chats)
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
    
}
