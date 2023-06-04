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
                    TextField("Start a chat by type their username", text: $vmChat.usernameText, onCommit: {
                        vmChat.findContact()
                    })
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        
                }
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 0.5)
                }
                .padding(.bottom)
                
                if vmChat.isLoading {
                    ProgressView()
                        .frame(maxHeight: .infinity)
                } else {
                    if vmChat.isContactListEmptyState {
                        VStack {
                            EmptyView()
                        }
                        .frame(maxHeight: .infinity)

                    } else if vmChat.contacts.isEmpty {
                        VStack {
                            Text("Username not found")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            ForEach(vmChat.contacts, id: \.username) { contact in
                                ContactCardVIew(contact: contact)
                            }
                        }

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
                        vmChat.usernameText = ""
                        vmChat.isContactListEmptyState = true
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
