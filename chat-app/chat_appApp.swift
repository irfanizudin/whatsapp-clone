//
//  chat_appApp.swift
//  chat-app
//
//  Created by Irfan Izudin on 25/03/23.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import UserNotifications

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
                .onAppear {
                    delegate.app = self
                }
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
    
    var app: chat_appApp?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    -> UIBackgroundFetchResult {
        
        return UIBackgroundFetchResult.newData
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }

}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let deviceToken = fcmToken else { return }
        print("Firebase registration token: \(deviceToken)")
        app?.vm.deviceToken = deviceToken

    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // receive foreground push notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        
        print("Foreground push")
        
        return [[.banner, .badge, .sound]]
    }
    
    // handle tap push notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        print("Background push")
        print(userInfo["chat"] as Any)
        guard let urlString = userInfo["link"] as? String,
            let url = URL(string: urlString)
        else { return }
        
        print(url)
//        ChatMessageVIew(recipientUser: RecentChat(documentId: "", data: ["sas": "sas"]))
//        app?.vm.checkDeepLink(url: url)
        
    }
}
