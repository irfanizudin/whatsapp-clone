//
//  LoginView.swift
//  chat-app
//
//  Created by Irfan Izudin on 25/03/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var vm: AuthenticationViewModel

    var body: some View {
        ZStack {
            Color(Pallete.BackgroundChat.rawValue).ignoresSafeArea()
           
            VStack {
                Text("Welcome to")
                    .font(.title2)
                    .padding(.top, 50)
                    .padding(.bottom, 5)
                Text("WhatsChat")
                    .font(.largeTitle.bold())
                    
                Spacer()
                
                Image(systemName: "message.badge.filled.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                Spacer()
                Text("Login to start a chat")
                    .font(.body)
                    .padding(.bottom)
                
                VStack {
                    HStack {
                       Image("google-logo")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(.trailing)
                        
                        Text("Continue with Google")
                            .font(.callout.bold())
                            .foregroundColor(.black)
                            
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    }
                    .overlay {
                        GoogleSignInButton()
                            .onTapGesture {
                                vm.signInWithGoogle()
                            }
                            .blendMode(.overlay)
                    }
                    
                    HStack {
                       Image(systemName: "apple.logo")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(.trailing)

                        
                        Text("Continue with Apple")
                            .font(.callout.bold())
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.black)
                    }
                    .overlay {
                        SignInWithAppleButton { request in
                            
//                            vm.signInWithAppleRequest(request: request)
                            
                        } onCompletion: { result in
                            
//                            vm.signInWithAppleCompletion(result: result)
                        }
                        .signInWithAppleButtonStyle(.white)
                        .blendMode(.overlay)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 50)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationViewModel())
    }
}
