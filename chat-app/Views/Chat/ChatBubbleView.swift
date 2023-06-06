//
//  ChatBubbleView.swift
//  chat-app
//
//  Created by Irfan Izudin on 06/06/23.
//

import SwiftUI

struct ChatBubbleView: View {
    
    @EnvironmentObject var vmChat: ChatViewModel

    let chat: Chat
    
    var body: some View {
        VStack(spacing: 0) {
            if chat.fromId == vmChat.currentUserId {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(chat.text ?? "")
                            .foregroundColor(.black)
                        
                        Text("11:33 AM")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, -5)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color(Pallete.BubbleGreen.rawValue))
                    .cornerRadius(10)
                }
                .padding(.vertical, 2)

            } else {
                HStack {
                    VStack(alignment: .trailing) {
                        Text(chat.text ?? "")
                            .foregroundColor(.black)
                        
                        Text("11:33 AM")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, -5)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .background(.white)
                    .cornerRadius(10)
                    Spacer()
                }
                .padding(.vertical, 2)

            }

        }
    }
}

struct ChatBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        let imageURL: String = "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80"
        let username = "irfanizudin"
        let fullName = "Irfan Izudin"

        let data: [String: Any] = [
            "photoURL": imageURL,
            "username": username,
            "fullName": fullName
        ]

        ChatBubbleView(chat: Chat(documentId: "", data: data))
            .environmentObject(ChatViewModel())
    }
}
