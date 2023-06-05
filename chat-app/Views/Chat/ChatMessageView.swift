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
                
                ImageProfileView(imageURL: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80", size: 50)
            
                Text("chika")
                    .font(.headline.bold())
                    .padding(.leading, 10)
                
                Spacer()
                
                Image(systemName: "info.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundColor(.blue)

            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
                
            VStack {
                ScrollView {
                    ForEach(0..<10) { _ in
                        Text("Chat Message")
                            .font(.title)
                            .padding()
                            .frame(maxWidth: .infinity)
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
            
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(45))
                    .frame(width: 25)
                    .foregroundColor(.blue)
                    .padding(.leading, 10)

            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)

            
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct ChatMessageVIew_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatMessageVIew()
                .environmentObject(ChatViewModel())
        }
    }
}
