//
//  ChatMessageVIew.swift
//  chat-app
//
//  Created by Irfan Izudin on 05/06/23.
//

import SwiftUI

struct ChatMessageVIew: View {
    @EnvironmentObject var vmChat: ChatViewModel
    @Environment(\.dismiss) var dismiss
    
    let recipientUser: RecentChat
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Image(systemName: "arrow.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundColor(.blue)
                    .padding(.trailing, 10)
                    .onTapGesture {
                        dismiss()
                    }
                
                ImageProfileView(imageURL: recipientUser.photoURL ?? "", size: 50)
            
                VStack(alignment: .leading) {
                    Text(recipientUser.username ?? "")
                        .font(.headline.bold())
                    Text(vmChat.isUserOnline ? "online" : "last seen \(vmChat.convertBubbleChatTimeStamp(timestamp: vmChat.lastSeen))")
                            .font(.caption)
                            .foregroundColor(.gray)
                }
                .padding(.leading, 10)
                
                Spacer()
                
                NavigationLink {
                    ContactDetailView(contact: recipientUser)
                } label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .foregroundColor(.blue)
                }


            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
                
            VStack {
                ScrollView {
                    ScrollViewReader { proxy in
                        VStack {
                            ForEach(vmChat.chats) { chat in
                                ChatBubbleView(chat: chat)
                                    .environmentObject(vmChat)
                            }
                            
                            HStack {
                                Spacer()
                            }
                            .id("bottom")
                            
                        }
                        .onReceive(vmChat.$scrollToBottom) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                proxy.scrollTo("bottom", anchor: .bottom)
                            }
                            
                        }
                        .padding()
                        
                    }
                    
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(Pallete.BackgroundChat.rawValue))
            .onTapGesture {
                hideKeyboard()
            }
            
            HStack(alignment: .center, spacing: 0) {
                Image(systemName: "photo.on.rectangle.angled")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .foregroundColor(.blue)
                    .padding(.trailing, 10)
                    .onTapGesture {
                        
                    }
                
                TextField("Write here...", text: $vmChat.chatText, axis: .vertical)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.sentences)
                    .frame(minHeight: 30)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 0.5)
                    }
            
                Button {
                    vmChat.createNewMessage(recipientUser: recipientUser)
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(45))
                        .frame(width: 25)
                        .foregroundColor(vmChat.chatText.isEmpty ? .gray : .blue)
                        .padding(.leading, 10)
                }
                .disabled(vmChat.chatText.isEmpty ? true : false)


            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)

            
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            vmChat.fetchChatMessages(recipientUser: recipientUser)
            vmChat.getCurrentUserId()
            vmChat.getOnlineStatus(userId: recipientUser.toId ?? "")
        }
        .onDisappear {
            vmChat.onlineStatusListener?.remove()
            print("remove online status listener")
        }
    }
}

struct ChatMessageVIew_Previews: PreviewProvider {
    static var previews: some View {
        let imageURL: String = "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80"
        let username = "irfanizudin"
        let fullName = "Irfan Izudin"

        let data: [String: Any] = [
            "photoURL": imageURL,
            "username": username,
            "fullName": fullName
        ]

        NavigationView {
            ChatMessageVIew(recipientUser: RecentChat(documentId: "", data: data))
                .environmentObject(ChatViewModel())
        }
    }
}
