//
//  ImageProfileView.swift
//  chat-app
//
//  Created by Irfan Izudin on 04/06/23.
//

import SwiftUI

struct ImageProfileView: View {
    let imageURL: String
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
        } placeholder: {
            ProgressView()
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}

struct ImageProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ImageProfileView(imageURL: "", size: 100)
    }
}
