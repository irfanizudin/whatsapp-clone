//
//  LoginView.swift
//  chat-app
//
//  Created by Irfan Izudin on 25/03/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject var vm = AuthenticationViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Email", text: $vm.email)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(UIColor.systemFill))
                    .cornerRadius(10)
                    .padding(.top, 30)
                
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
                    Text("Login")
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(Pallete.TealGreen.rawValue))
                        .cornerRadius(10)
                }
                
                Spacer()
                
            }
            .padding(20)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Login")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(Color(UIColor.label))
                    }

                }
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
