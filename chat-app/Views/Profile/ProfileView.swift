//
//  ProfileView.swift
//  chat-app
//
//  Created by Irfan Izudin on 04/06/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ImageProfileView(imageURL: vm.user?.photoURL ?? "", size: 100)
                    .padding(.top, 80)
                    .padding(.bottom, 5)
                
                Text(vm.user?.fullName ?? "")
                    .font(.title.bold())
                    .padding(.bottom, 2)
                
                Text("@\(vm.user?.username ?? "")")
                    .font(.callout)
                    .foregroundColor(.gray)
                
                VStack {
                    Button {
                        vm.signOut()
                    } label: {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(Pallete.Red.rawValue))
                            .cornerRadius(10)
                    }
                .padding(.top, 50)
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            vm.fetchUserData { _ in
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthenticationViewModel())
    }
}
