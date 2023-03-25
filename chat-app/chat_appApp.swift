//
//  chat_appApp.swift
//  chat-app
//
//  Created by Irfan Izudin on 25/03/23.
//

import SwiftUI

@main
struct chat_appApp: App {
    @StateObject var vm = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            if vm.isLoginMode {
                LoginView()
            } else {
                RegisterView()
            }
        }
    }
}
