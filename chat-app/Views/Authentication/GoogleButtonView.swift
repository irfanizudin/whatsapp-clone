//
//  GoogleButtonView.swift
//  chat-app
//
//  Created by Irfan Izudin on 04/06/23.
//

import SwiftUI

struct GoogleButtonView: View {
    @EnvironmentObject var vm: AuthenticationViewModel
    
    var body: some View {
        HStack {
           Image("google-logo")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 25, height: 25)
                .padding(.trailing)
            
            Text("Continue with Google")
                .font(.callout.bold())
                .foregroundColor(.black)
                
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.white)
        }
        .overlay {
            GoogleSignInButton()
                .onTapGesture {
                    vm.signInWithGoogle()
                }
                .blendMode(.overlay)
        }
    }
}

struct GoogleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleButtonView()
            .environmentObject(AuthenticationViewModel())
    }
}
