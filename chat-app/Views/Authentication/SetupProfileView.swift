//
//  SetupProfileView.swift
//  chat-app
//
//  Created by Irfan Izudin on 03/06/23.
//

import SwiftUI

struct SetupProfileView: View {
    @EnvironmentObject var vm: AuthenticationViewModel

    var body: some View {
        VStack {
            Text("Hello, ")
                .font(.title2) +
            Text(vm.user?.fullName ?? "Irfan")
                .font(.title2.bold())
            
            Text("Setup your username and photo profile to start a chat")
                .multilineTextAlignment(.center)
                .padding()
            
            Group {
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    if vm.user?.photoURL == "" {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        AsyncImage(url: URL(string: vm.user?.photoURL ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        }
                        
                    }

                }
            }
            .padding(.top)
            .onTapGesture {
                vm.showImagePicker = true
            }
            
            Text("Change photo")
                .font(.subheadline.bold())
                .foregroundColor(.blue)
                .padding(.bottom)
                .onTapGesture {
                    vm.showImagePicker = true
                }
            
            TextField("Type your username", text: $vm.usernameText)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .multilineTextAlignment(.center)
            
            Button {
                vm.updateSetupProfile()
            } label: {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(vm.image == nil || vm.usernameText.isEmpty ? .gray : .blue)
                    .cornerRadius(10)
                
            }
            .padding(.top, 200)
            .disabled(vm.image == nil || vm.usernameText.isEmpty ? true : false)

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
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 20)
        .onAppear {
            vm.fetchUserData()
        }
        .sheet(isPresented: $vm.showImagePicker) {
            ImagePickerView(image: $vm.image)
        }
        .alert(vm.alertMessage, isPresented: $vm.showSetupProfileAlert) {
            Button("OK", action: {})
        }
        .overlay {
            LoadingView(isShowing: $vm.isShowLoading)
        }

    }
}

struct SetupProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SetupProfileView()
            .environmentObject(AuthenticationViewModel())
    }
}
