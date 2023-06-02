//
//  MainView.swift
//  chat-app
//
//  Created by Irfan Izudin on 02/06/23.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var vm: AuthenticationViewModel

    var body: some View {
        VStack {
            Text(vm.user?.fullName ?? "")
            
            Button {
                vm.signOut()
            } label: {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.red)
                    .cornerRadius(10)
                
            }
            .padding(.top, 10)

        }
        .padding(.horizontal, 20)
        .onAppear {
            vm.fetchUserData()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AuthenticationViewModel())
    }
}
