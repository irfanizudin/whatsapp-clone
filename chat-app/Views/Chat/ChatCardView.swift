//
//  ChatCardView.swift
//  chat-app
//
//  Created by Irfan Izudin on 04/06/23.
//

import SwiftUI
import Firebase

struct ChatCardView: View {
    
    @EnvironmentObject var vmChat: ChatViewModel
    
    let recentChat: RecentChat
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ImageProfileView(imageURL: recentChat.photoURL ?? "", size: 70)
                
                VStack(alignment: .leading) {
                    Text(recentChat.username ?? "")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .padding(.bottom, 1)
                    
                    HStack {
                        if let fromId = vmChat.chats.last?.fromId {
                            if fromId == vmChat.currentUserId {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.gray)
                            }
                        }
                        Text(recentChat.text ?? "")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.leading)
                
                Spacer()
                
                if let timestamp = recentChat.createdAt {
                    Text(vmChat.convertRecentChatTimestamp(timestamp: timestamp))
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }
            Divider()
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
        }
    }
}

struct ChatCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ChatCardView(recentChat: RecentChat(documentId: "", data: ["data": 1 ]))
        }
    }
}
