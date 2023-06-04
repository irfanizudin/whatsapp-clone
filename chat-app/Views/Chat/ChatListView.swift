//
//  ChatListView.swift
//  chat-app
//
//  Created by Irfan Izudin on 03/06/23.
//

import SwiftUI

struct ChatListView: View {
    @StateObject var vmChat = ChatViewModel()
    @EnvironmentObject var vmAuth: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                
            }
            .onAppear {
                
            }
            .navigationTitle("Chats")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vmChat.showContactList.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .scaledToFit()
                    }
                    
                }
            })
            .sheet(isPresented: $vmChat.showContactList, onDismiss: {
                vmChat.usernameText = ""
                vmChat.isContactListEmptyState = true
            }) {
                ContactListView()
                    .environmentObject(vmChat)
            }
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
            .environmentObject(AuthenticationViewModel())
    }
}
