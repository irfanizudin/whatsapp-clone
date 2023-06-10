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
                ForEach(vmChat.recentChat) { recentChat in
                    VStack {
                        NavigationLink {
                            ChatMessageVIew(recipientUser: recentChat)
                                .environmentObject(vmChat)
                        } label: {
                            ChatCardView(recentChat: recentChat)
                                .environmentObject(vmChat)
                        }
                    }

                }
            }
            
            NavigationLink(isActive: $vmChat.moveToChatMessage) {
                if let recipientUser = vmChat.recipientUser {
                    ChatMessageVIew(recipientUser: recipientUser)
                        .environmentObject(vmChat)
                }
            } label: {
                EmptyView()
            }

            
        }
        .padding(.horizontal, 20)
        .onAppear {
            vmChat.fetchRecentMessages()
        }
        .sheet(isPresented: $vmChat.showContactList, onDismiss: {
            vmChat.usernameText = ""
            vmChat.isContactListEmptyState = true
        }) {
            ContactListView(didSelectUser: { contact in
                vmChat.recipientUser = contact
            })
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
