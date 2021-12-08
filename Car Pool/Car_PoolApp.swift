//
//  Car_PoolApp.swift
//  Car Pool
//
//  Created by James  Luberisse on 11/3/21.
//

import SwiftUI
import Firebase

@main

struct Car_PoolApp: App {
    
    @StateObject var user = User();
    @State var show = false;
    init() {
      FirebaseApp.configure()
    }
    
    var body: some Scene {
            WindowGroup {

                ContentView()
                    .environmentObject(user)

        }
    }
}
