//
//  MainView.swift
//  chat-app
//
//  Created by Irfan Izudin on 02/06/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var vmMain = MainViewModel()
    @StateObject var vmChat = ChatViewModel()
    @EnvironmentObject var vm: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            TabView(selection: $vmMain.tabSelected) {
                
                ChatListView()
                    .environmentObject(vmChat)
                    .tag(0)
                    .tabItem {
                        Image(systemName: "message")
                        Text("Chats")
                    }
                
                ProfileView()
                    .environmentObject(vm)
                    .tag(1)
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                
            }
            .navigationTitle(vmMain.tabSelected == 0 ? "Chats" : "Profile")
            .toolbar(content: {
                if vmMain.tabSelected == 0 {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            vmChat.showContactList.toggle()
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                        }
                        
                    }
                }

            })
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AuthenticationViewModel())
    }
}
