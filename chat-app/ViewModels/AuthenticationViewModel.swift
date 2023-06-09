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
    @Published var image: UIImage?
    @Published var showImagePicker: Bool = false
    @Published var usernameText: String = ""
    @Published var showSetupProfileAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isShowLoading: Bool = false
    @Published var nonce: String = ""
    @Published var deviceToken: String = ""

    @AppStorage("isSignedIn") var isSignedIn: Bool = false
    @AppStorage("isCompletedSetup") var isCompletedSetup: Bool = false

    let vmChat = ChatViewModel()

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
                
                let user = UserModel(uid: uid, fullName: fullName, username: "", email: email, photoURL: photoURL, photoName: "")
                                
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
                
                let data: [String: Any] = [
                    "uid": user.uid ?? "",
                    "fullName": user.fullName ?? "",
                    "username": "",
                    "email": user.email ?? "",
                    "photoURL": user.photoURL ?? "",
                    "photoName": "",
                    "isOnline": true,
                    "deviceToken": self.deviceToken,
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
    
    func fetchUserData(completion: @escaping(Result<UserModel, Error>) -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Users").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch data: ", error.localizedDescription)
                return
            }

            guard let document = snapshot?.data() else { return }
            
            let uid = document["uid"] as? String ?? ""
            let fullName = document["fullName"] as? String ?? ""
            let username = document["username"] as? String ?? ""
            let email = document["email"] as? String ?? ""
            let photoURL = document["photoURL"] as? String ?? ""
            let photoName = document["photoName"] as? String ?? ""
            
            let user = UserModel(uid: uid, fullName: fullName, username: username, email: email, photoURL: photoURL, photoName: photoName)
            self.user = user
            completion(.success(user))
            print("Successfully fetch user data")

        }
    }
    
    func signOut() {

        do {
            try Auth.auth().signOut()
            self.isSignedIn = false
            self.isCompletedSetup = false
            self.image = UIImage(named: "")
            self.usernameText = ""
            vmChat.fetchChatMessagesListener?.remove()

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateSetupProfile() {

        let containSpacing = usernameText.contains { $0.isWhitespace }
        
        if containSpacing {
            print("text contain spacing")
            self.showSetupProfileAlert = true
            self.alertMessage = "Username must not contain spaces"
            return
        }
        
        
        self.isUsernameExist { result in
            switch result {
            case .success(let isExist):
                if isExist {
                    print("username exist")
                    self.showSetupProfileAlert = true
                    self.alertMessage = "Username is already taken"

                } else {
                    
                    print("username not exist")
                    self.saveImageToStorage { result in
                        switch result {
                        case .success(let photo):
                            self.saveSetupProfileToFirestore(photoURL: photo.photoURL ?? "", photoName: photo.photoName ?? "", username: self.usernameText)
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
             

    }
    
    func isUsernameExist(completion: @escaping(Result<Bool, Error>) -> () )  {
        
        var isExistArr: [Bool] = []

        Firestore.firestore().collection("Users").whereField("username", isEqualTo: usernameText)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Failed to get document: ", error.localizedDescription)
                    
                } else {
                    
                    for document in snapshot!.documents {
                        isExistArr.append(document.exists)
                    }
                    completion(.success(isExistArr.first ?? false))
                }
                
            }
        
    }

    func saveImageToStorage(completion: @escaping(Result<UpdatePhoto, Error>) -> ()) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Users").document(userId).getDocument { document, error in
            if let error = error {
                print("Failed to get document :", error.localizedDescription)
                return
            }
            
            guard let document = document?.data() else { return }
            let photoURL = document["photoURL"] as? String ?? ""
            let photoName = document["photoName"] as? String ?? ""

            
            if !photoURL.isEmpty && self.image == nil {
                print("photo url exist and not change image")
                let photo = UpdatePhoto(photoURL: photoURL, photoName: photoName)
                completion(.success(photo))
                
            } else {
                print("photo url empty or change image")
                
                self.deleteImageFromStorage()
                
                self.isShowLoading = true
                let filename = UUID().uuidString
                let ref = Storage.storage().reference(withPath: filename)
                
                guard let imageData = self.image?.jpegData(compressionQuality: 0.8) else {
                    print("Image not found")
                    return
                    
                }
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                ref.putData(imageData, metadata: metadata) { metadata, error in
                    if let error = error {
                        print("Failed to save image: ", error.localizedDescription)
                        return
                    }
                    
                    ref.downloadURL { url, error in
                        if let error = error {
                            print("Failed to download URL: ", error.localizedDescription)
                            return
                        }

                        print("Successfully download photo")
                        let photo = UpdatePhoto(photoURL: url?.absoluteString ?? "", photoName: filename)
                        completion(.success(photo))
                        
                    }
                }

            }
        }
        
        
    }
    
    func saveSetupProfileToFirestore(photoURL: String, photoName: String, username: String) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "username": username,
            "photoURL": photoURL,
            "photoName": photoName,
            "updatedAt": Timestamp(date: Date())
        ]
        
        Firestore.firestore().collection("Users").document(userId).updateData(data) { error in
            if let error = error {
                print("Failed setup profile: ", error.localizedDescription)
                self.alertMessage = "Failed setup profile"
                self.isShowLoading = false
                self.image = UIImage(named: "")
                self.showSetupProfileAlert = true


            } else {
                self.alertMessage = "Successfully setup profile"
                print("Successfully setup profile")
                self.isShowLoading = false
                self.image = UIImage(named: "")
                self.showSetupProfileAlert = true

                withAnimation(.easeInOut) {
                    self.isCompletedSetup = true
                }

            }
            

        }

    }
    
    func deleteImageFromStorage() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("Users").document(userId).getDocument { document, error in
            if let error = error {
                print("Failed to get document :", error.localizedDescription)
                return
            }
            
            guard let document = document?.data() else { return }
            let photoName = document["photoName"] as? String ?? ""
            if !photoName.isEmpty {
                print("photo name exist")
                
                let ref = Storage.storage().reference().child(photoName)
                
                ref.delete { error in
                    if let error = error {
                        print("Failed to delete image", error.localizedDescription)
                    } else {
                        print("Successfully delete image")
                    }
                }
            } else {
                print("photo name empty")
            }
            

        }
        
    }
    
    func signInWithAppleRequest(request: ASAuthorizationAppleIDRequest) {
        nonce = randomNonceString()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
    }

    func signInWithAppleCompletion(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let user):
            
            guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                print("error to get credential")
                return
            }
            
            authenticateAppleSignIn(credential: credential)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func authenticateAppleSignIn(credential: ASAuthorizationAppleIDCredential) {
        
        guard let token = credential.identityToken else {
            print("error get token")
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error convert token to string")
            return
        }
        
        let appleCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        
        Auth.auth().signIn(with: appleCredential) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("Login Apple success")
            self.isSignedIn = true
            
            let uid = credential.user
            let firstName = credential.fullName?.givenName ?? ""
            let lastName = credential.fullName?.familyName ?? ""
            let fullName = "\(firstName) \(lastName)"
            let email = credential.email
            
            let user = UserModel(uid: uid, fullName: fullName, username: "", email: email, photoURL: "", photoName: "")
            
            self.saveUserSignIn(user: user)
        }
        
    }

    
}
