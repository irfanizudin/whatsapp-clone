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

        self.saveRecentMessage(recipientUser: recipientUser)
        
    }
    
    func fetchChatMessages(recipientUser: RecentChat) {
        
        guard let fromId = Auth.auth().currentUser?.uid
        else { return }

        let toId = recipientUser.documentId

        Firestore.firestore().collection("Messages").document(fromId).collection(toId).order(by: "createdAt").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Failed to fetch chat messages: ", error.localizedDescription)
            } else {
                
                snapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let documentId = change.document.documentID
                        let data = change.document.data()
                        
                        if let index = self.chats.firstIndex(where: { chat in
                            return chat.documentId == documentId
                        }) {
                            self.chats.remove(at: index)
                        }
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
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            dateFormatter.dateFormat = "'Yesterday' h:mm a"
            return dateFormatter.string(from: date)
        } else if calendar.isDateInWeekend(date) {
            dateFormatter.dateFormat = "EEEE h:mm a"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "dd/MM/yy h:mm a"
            return dateFormatter.string(from: date)
        }
    }
    
    func convertRecentChatTimestamp(timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if calendar.isDateInWeekend(date) {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "dd/MM/yy"
            return dateFormatter.string(from: date)
        }
    }
    
    func saveRecentMessage(recipientUser: RecentChat) {
        guard let fromId = Auth.auth().currentUser?.uid
        else { return }
        let text1: String = self.chatText
        let text2: String = self.chatText

        let toId = recipientUser.documentId
        var fullName: String = ""
        var username: String = ""
        var photoURL: String = ""
        
        Firestore.firestore().collection("Users").document(toId).getDocument { snapshot, error in
            if let error = error {
                print("Failed to get User data :", error.localizedDescription)
                return
            }
            
            guard let document = snapshot?.data() else { return }
            fullName = document["fullName"] as? String ?? ""
            username = document["username"] as? String ?? ""
            photoURL = document["photoURL"] as? String ?? ""
            print("Successfully get fullname, username and photoURL currentUser")
            
            let data: [String: Any] = [
                "fromId": fromId,
                "toId": toId,
                "text": text1,
                "createdAt": Timestamp(date: Date()),
                "photoURL": photoURL,
                "username": username,
                "fullName": fullName
            ]

            Firestore.firestore().collection("RecentMessages").document(fromId).collection("Messages").document(toId).setData(data) { error in
                if let error = error {
                    print("Failed to save recent message from currenUser: ", error.localizedDescription)
                } else {
                    print("Successfully current user save recent message")
                }
            }

            
        }

        
        
        var recipientFullName: String = ""
        var recipientUsername: String = ""
        var recipientPhotoURL: String = ""
        
        Firestore.firestore().collection("Users").document(fromId).getDocument { snapshot, error in
            if let error = error {
                print("Failed to get User data :", error.localizedDescription)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            recipientFullName = data["fullName"] as? String ?? ""
            recipientUsername = data["username"] as? String ?? ""
            recipientPhotoURL = data["photoURL"] as? String ?? ""
            print("Successfully get fullname, username and photoURL recipientUser")

            let dataRecipient: [String: Any] = [
                "fromId": toId,
                "toId": fromId,
                "text": text2,
                "createdAt": Timestamp(date: Date()),
                "photoURL": recipientPhotoURL,
                "username": recipientUsername,
                "fullName": recipientFullName
            ]

            Firestore.firestore().collection("RecentMessages").document(toId).collection("Messages").document(fromId).setData(dataRecipient) { error in
                if let error = error {
                    print("Failed to save recent message from recipient: ", error.localizedDescription)
                } else {
                    print("Successfully recipient save recent message")
                }

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
                    
                    if let index = self.recentChat.firstIndex(where: { chat in
                        return chat.documentId == documentId
                    }) {
                        self.recentChat.remove(at: index)
                    }
                    
                    let recentChat = RecentChat(documentId: documentId, data: data)
                    self.recentChat.append(recentChat)
                    
                })
                print("Successfully fetch recent chat messages")
            }
        }

    }
    
}
