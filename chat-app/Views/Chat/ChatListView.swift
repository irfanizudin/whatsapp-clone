//
//  ChatListView.swift
//  chat-app
//
//  Created by Irfan Izudin on 03/06/23.
//

import SwiftUI

struct ChatListView: View {
    
    @EnvironmentObject var vmChat: ChatViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(vmChat.chats, id: \.username) { chat in
                    NavigationLink {
                        ChatMessageVIew()
                            .environmentObject(vmChat)
                    } label: {
                        ChatCardView(chat: chat)
                    }
                    
                }
            }
            
        }
        .padding(.horizontal, 20)
        .onAppear {
            
        }
        .sheet(isPresented: $vmChat.showContactList, onDismiss: {
            vmChat.usernameText = ""
            vmChat.isContactListEmptyState = true
        }) {
            ContactListView()
                .environmentObject(vmChat)
        }
    }
    
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
            .environmentObject(ChatViewModel())
    }
}
