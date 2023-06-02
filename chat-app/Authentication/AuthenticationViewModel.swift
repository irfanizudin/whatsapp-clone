//
//  AuthenticationViewModel.swift
//  chat-app
//
//  Created by Irfan Izudin on 25/03/23.
//

import Foundation
import SwiftUI
import GoogleSignIn
import AuthenticationServices
import Firebase
import FirebaseFirestore
import FirebaseStorage

class AuthenticationViewModel: ObservableObject {
    
    @Published var user: UserModel?
    @Published var isLoading: Bool = false

    @AppStorage("isSignedIn") var isSignedIn: Bool = false


    func signInWithGoogle() {
        
        self.isLoading = true
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let configuration = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = configuration
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController
        else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
            authenticateGoogleSignIn(user: result?.user, error: error)
            
        }
        
    }
    
    func authenticateGoogleSignIn(user: GIDGoogleUser?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            isLoading = false
            return
        }
        
        guard let idToken = user?.idToken?.tokenString,
              let accessToken = user?.accessToken.tokenString else {
            return
        }
        
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credential) { _, error in
            if let error = error {
                print(error.localizedDescription)

            } else {
                self.isLoading = false

                withAnimation(.easeInOut) {
                    self.isSignedIn = true
                }
                
                let uid = user?.userID
                let fullName = user?.profile?.name
                let email = user?.profile?.email
                let photoURL = user?.profile?.imageURL(withDimension: 200)?.absoluteString
                
                let user = UserModel(uid: uid, fullName: fullName, email: email, photoURL: photoURL, photoName: "")
                                
                self.saveUserSignIn(user: user)
            }
        }
    }
    
    func saveUserSignIn(user: UserModel) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                print("update data")
                
            } else {
                print("save data")
                
                if user.email == nil {
//                    self.updateAppleSignIn(user: user, userId: userId)

                } else {
                    
                    let data: [String: Any] = [
                        "uid": user.uid ?? "",
                        "fullName": user.fullName ?? "",
                        "email": user.email ?? "",
                        "photoURL": user.photoURL ?? "",
                        "photoName": "",
                        "createdAt": Timestamp(date: Date()),
                        "updatedAt": Timestamp(date: Date())
                    ]
                    
                    Firestore.firestore().collection("Users").document(userId).setData(data) { error in
                        if let error = error {
                            print("error saving data to firestore: ", error.localizedDescription)
                        } else {
                            print("successfully save data to firestore")
                        }
                    }

                }

                
            }
        }
        
    }
    
    func fetchUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Users").document(userId).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Failed to fetch data: ", error.localizedDescription)
                return
            }
            
            guard let document = snapshot?.data() else { return }
            
            let uid = document["uid"] as? String ?? ""
            let fullName = document["fullName"] as? String ?? ""
            let email = document["email"] as? String ?? ""
            let photoURL = document["photoURL"] as? String ?? ""
            let photoName = document["photoName"] as? String ?? ""
            
            let user = UserModel(uid: uid, fullName: fullName, email: email, photoURL: photoURL, photoName: photoName)
            self.user = user
            
            
        }
        
    }
    
    func signOut() {

        do {
            try Auth.auth().signOut()
            isSignedIn = false
//            self.image = UIImage(named: "")

        } catch {
            print(error.localizedDescription)
        }
    }

    
    
}
