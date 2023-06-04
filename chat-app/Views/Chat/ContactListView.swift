//
//  ContactListView.swift
//  chat-app
//
//  Created by Irfan Izudin on 03/06/23.
//

import SwiftUI

struct ContactListView: View {

    @EnvironmentObject var vmChat: ChatViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Find a friends by username", text: $vmChat.usernameText)
                        .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                }
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 0.5)
                }
              
                ScrollView {
                    ForEach(vmChat.contacts, id: \.username) { contact in
                        ContactCardVIew(contact: contact)
                    }
                }

            }
            .padding(.horizontal, 20)
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }

                }
            }
        }
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
            .environmentObject(ChatViewModel())
    }
}
