//
//  Navigation.swift
//  chat-app
//
//  Created by Irfan Izudin on 05/06/23.
//

import Foundation
import UIKit

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
