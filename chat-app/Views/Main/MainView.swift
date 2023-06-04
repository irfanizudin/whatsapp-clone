//
//  MainView.swift
//  chat-app
//
//  Created by Irfan Izudin on 02/06/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var vmMain = MainViewModel()
    @EnvironmentObject var vm: AuthenticationViewModel
    
    var body: some View {
        VStack {
            TabView(selection: $vmMain.tabSelected) {
                
                ChatListView()
                    .environmentObject(vm)
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
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AuthenticationViewModel())
    }
}
