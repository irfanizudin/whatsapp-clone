//
//  ChatCardView.swift
//  chat-app
//
//  Created by Irfan Izudin on 04/06/23.
//

import SwiftUI

struct ChatCardView: View {
    
    let chat: Chat
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ImageProfileView(imageURL: chat.imageURL ?? "", size: 70)
                
                VStack(alignment: .leading) {
                    Text(chat.username ?? "")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .padding(.bottom, 1)
                    
                    HStack {
                        if let isUserMessage = chat.isUserMessage, isUserMessage {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.gray)
                        }
                        Text(chat.lastMessage ?? "")
                            .font(.callout)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading)
                
                Spacer()
                
                Text(chat.lastMessageDate ?? "")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            Divider()
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ChatCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ChatCardView(chat: Chat(imageURL: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80", username: "chika", lastMessage: "Hi What's up?", isUserMessage: false, lastMessageDate: "Today"))
            ChatCardView(chat: Chat(imageURL: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80", username: "james", lastMessage: "I'm busy right now", isUserMessage: true, lastMessageDate: "Yesterday"))
        }
        
    }
}
