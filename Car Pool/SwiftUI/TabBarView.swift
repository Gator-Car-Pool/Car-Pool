//
//  TabBarView.swift
//  Car Pool
//
//  Created by Valerie Chery on 11/17/21.
//

import SwiftUI

struct TabBarView: View {
  
    var body: some View {
        
        
        TabView {
            
            MainView()
                .tabItem {
                    Image(systemName: "mappin.circle")
                    Text("Map")
                }
            
            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left")
                    Text("Chat")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            
        }

        
    }
}

