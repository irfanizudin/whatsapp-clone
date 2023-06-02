//
//  chat_appApp.swift
//  chat-app
//
//  Created by Irfan Izudin on 25/03/23.
//

import SwiftUI
import FirebaseCore

@main
struct chat_appApp: App {
    @StateObject var vm = AuthenticationViewModel()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

