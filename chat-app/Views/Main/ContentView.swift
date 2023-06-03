//
//  ContentView.swift
//  chat-app
//
//  Created by Irfan Izudin on 02/06/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm: AuthenticationViewModel
    @AppStorage("isSignedIn") var isSignedIn: Bool = false
    @AppStorage("isCompletedSetup") var isCompletedSetup: Bool = false

    var body: some View {
        Group {
            if isSignedIn {
                if isCompletedSetup {
                    MainView()
                        .environmentObject(vm)
                } else {
                    SetupProfileView()
                        .environmentObject(vm)
                }
            } else {
                LoginView()
                    .environmentObject(vm)
            }

        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel())
    }
}
