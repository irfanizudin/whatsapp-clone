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
        VStack(alignment: .leading) {
            HStack {
                ImageProfileView(imageURL: contact?.imageURL ?? "", size: contact?.size ?? 0)
                VStack(alignment: .leading) {
                    Text(contact?.username ?? "")
                        .bold()
                    Text(contact?.fullName ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Divider()
        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
}

struct ContactCardVIew_Previews: PreviewProvider {

    static var previews: some View {
        let imageURL: String = "https://firebasestorage.googleapis.com:443/v0/b/chat-app-41388.appspot.com/o/B1458DD0-44B1-473D-956A-2DB243DE225C?alt=media&token=db87fe33-628d-4001-8c04-8493fa0a60ed"
        let size: CGFloat = 50
        let username = "irfanizudin"
        let fullName = "Irfan Izudin"

        ContactCardVIew(contact: Contact(imageURL: imageURL, size: size, username: username, fullName: fullName))
    }
}
