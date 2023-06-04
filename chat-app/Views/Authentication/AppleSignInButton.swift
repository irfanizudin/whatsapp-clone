//
//  AppleSignInButton.swift
//  chat-app
//
//  Created by Irfan Izudin on 04/06/23.
//

import SwiftUI
import AuthenticationServices

struct AppleSignInButton: View {
    @EnvironmentObject var vm: AuthenticationViewModel
    
    var body: some View {
            SignInWithAppleButton { request in
                
                vm.signInWithAppleRequest(request: request)
                
            } onCompletion: { result in
                
                vm.signInWithAppleCompletion(result: result)
            }
            .signInWithAppleButtonStyle(.white)
    }
}
