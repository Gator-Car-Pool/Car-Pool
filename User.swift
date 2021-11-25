//
//  AuthView.swift
//  Car Pool
//
//  Created by James  Luberisse on 11/23/21.
//

import SwiftUI
class User: ObservableObject {
    @Published var user_name = "n/a"
    @Published var profile_pic = Image("gator")
    @Published var email = "n/a"
    @Published var mode = "rider"

}

