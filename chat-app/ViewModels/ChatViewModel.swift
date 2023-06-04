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
                        let contact = Contact(imageURL: imageURL, size: 40, username: username, fullName: fullName)
                        self.contacts.append(contact)
                        print(self.contacts)
                    }

                }
                
            }
    }
    
}
