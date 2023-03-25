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
}
