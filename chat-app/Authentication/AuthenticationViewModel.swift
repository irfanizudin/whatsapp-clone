//
//  AuthenticationViewModel.swift
//  chat-app
//
//  Created by Irfan Izudin on 25/03/23.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoginMode: Bool = false
    
    func createNewUser() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("failed to create user", error)
            }
            print("successfully create user:", result?.user.uid as Any)
            
        }
    }
    
    func signIn() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("failed to login", error)
            }
            print("succesfully login:", result?.user.uid as Any)
        }
    }
}
