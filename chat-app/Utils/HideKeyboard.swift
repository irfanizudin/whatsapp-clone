//
//  HideKeyboard.swift
//  chat-app
//
//  Created by Irfan Izudin on 05/06/23.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
