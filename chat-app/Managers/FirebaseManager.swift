//
//  FirebaseManager.swift
//  chat-app
//
//  Created by Irfan Izudin on 25/03/23.
//

import Foundation
import Firebase

class FirebaseManager: NSObject {
    
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
    }
}
