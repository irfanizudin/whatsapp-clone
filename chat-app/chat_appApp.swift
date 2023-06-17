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
    @Environment(\.scenePhase) var scenePhase
    @StateObject var vm = AuthenticationViewModel()
    @StateObject var vmChat = ChatViewModel()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .environmentObject(vmChat)
                .preferredColorScheme(.light)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                vmChat.updateOnlineStatus(userId: vmChat.currentUserId, isOnline: true)
            case .inactive:
                vmChat.updateOnlineStatus(userId: vmChat.currentUserId, isOnline: false)
            case .background:
                print("app is in the background")
            @unknown default:
                break
            }
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

