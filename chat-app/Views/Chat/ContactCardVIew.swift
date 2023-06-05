//
//  ContactCardVIew.swift
//  chat-app
//
//  Created by Irfan Izudin on 04/06/23.
//

import SwiftUI

struct ContactCardVIew: View {
        
    let contact: Contact?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                ImageProfileView(imageURL: contact?.imageURL ?? "", size: 60)
                VStack(alignment: .leading) {
                    Text(contact?.username ?? "")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .padding(.bottom, 1)
                    Text(contact?.fullName ?? "")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 10)
            }
            .padding(.vertical, 10)
            Divider()
        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
}

struct ContactCardVIew_Previews: PreviewProvider {

    static var previews: some View {
        let imageURL: String = "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80"
        let username = "irfanizudin"
        let fullName = "Irfan Izudin"

        ContactCardVIew(contact: Contact(imageURL: imageURL, username: username, fullName: fullName))
    }
}
