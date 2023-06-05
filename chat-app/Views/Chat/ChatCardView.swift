//
//  ChatCardView.swift
//  chat-app
//
//  Created by Irfan Izudin on 04/06/23.
//

import SwiftUI

struct ChatCardView: View {
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ImageProfileView(imageURL: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80", size: 70)
                
                VStack(alignment: .leading) {
                    Text("asolole")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .padding(.bottom, 1)
                    
                    HStack {
//                        if let isUserMessage = chat.isUserMessage, isUserMessage {
//                            Image(systemName: "checkmark")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 12, height: 12)
//                                .foregroundColor(.gray)
//                        }
                        Text("Hi What's up?")
                            .font(.callout)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading)
                
                Spacer()
                
                Text("Today")
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
            ChatCardView()
        }
    }
}
