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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        vmAuth.signOut()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(Color(Pallete.Red.rawValue))
                    }
                    
                }
            })
            .sheet(isPresented: $vmChat.showContactList) {
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
