//
//  User.swift
//  chat-app
//
//  Created by Irfan Izudin on 02/06/23.
//

import Foundation

struct UserModel {
    let uid: String?
    let fullName: String?
    let username: String?
    let email: String?
    let photoURL: String?
    let photoName: String?
}

struct UpdatePhoto {
    let photoURL: String?
    let photoName: String?
}
