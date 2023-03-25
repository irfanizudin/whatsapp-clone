//
//  RegisterView.swift
//  chat-app
//
//  Created by Irfan Izudin on 25/03/23.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var vm = AuthenticationViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button {
                    print("change image")
                } label: {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color(Pallete.TealGreen.rawValue))
                        .font(.system(size: 100))
                        .overlay {
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color(Pallete.TealGreen.rawValue), lineWidth: 8)
                        }
                    
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    
                }
                .padding(.bottom, 50)
                
                TextField("Email", text: $vm.email)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(UIColor.systemFill))
                    .cornerRadius(10)
                
                SecureField("Password", text: $vm.password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(UIColor.systemFill))
                    .cornerRadius(10)
                
                Button {
                    print("submit")
                } label: {
                    Text("Create Account")
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(Pallete.TealGreen.rawValue))
                        .cornerRadius(10)
                }
                
                Text("Already have account?")
                    .padding(.bottom, -10)
                Text("Login")
                    .underline()
                    .foregroundColor(Color(Pallete.TealGreen.rawValue))
                    .onTapGesture {
                        print("move to login")
                        vm.isLoginMode = true
                    }
                
            }
            .padding(20)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Create Account")
            .fullScreenCover(isPresented: $vm.isLoginMode) {
                LoginView()
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
