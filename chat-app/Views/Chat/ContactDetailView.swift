//
//  ContactDetailView.swift
//  chat-app
//
//  Created by Irfan Izudin on 11/06/23.
//

import SwiftUI

struct ContactDetailView: View {
    let contact: RecentChat
    
    var body: some View {
        VStack {
            ImageProfileView(imageURL: contact.photoURL ?? "", size: 100)
                .padding(.top, 80)
                .padding(.bottom, 5)
            
            Text(contact.fullName ?? "")
                .font(.title.bold())
                .padding(.bottom, 2)
            
            Text("@\(contact.username ?? "")")
                .font(.callout)
                .foregroundColor(.gray)
                        
            Spacer()
        }
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailView(contact: RecentChat(documentId: "", data: ["data": 0]))
    }
}
