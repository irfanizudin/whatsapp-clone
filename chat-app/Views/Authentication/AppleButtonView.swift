//
//  AppleButtonView.swift
//  chat-app
//
//  Created by Irfan Izudin on 04/06/23.
//

import SwiftUI

struct AppleButtonView: View {
    @EnvironmentObject var vm: AuthenticationViewModel
    
    var body: some View {
        HStack {
           Image(systemName: "apple.logo")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 25, height: 25)
                .padding(.trailing)

            
            Text("Continue with Apple")
                .font(.callout.bold())
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.black)
        }
        .overlay {
            AppleSignInButton()
                .environmentObject(vm)
                .blendMode(.overlay)
        }
    }
}

struct AppleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AppleButtonView()
            .environmentObject(AuthenticationViewModel())
    }
}
