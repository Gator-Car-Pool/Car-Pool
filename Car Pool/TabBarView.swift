//
//  TabBarView.swift
//  Car Pool
//
//  Created by Valerie Chery on 11/17/21.
//

import SwiftUI

struct TabBarView: View {
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = false
    
    var body: some View {
        
        SignInView()
        
        TabView {
            
            MapView()
                .tabItem {
                    Image(systemName: "mappin.circle")
                    Text("Map")
                }
            
            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left")
                    Text("Chat")
                }
            
            SettingsView(darkModeEnabled: $darkModeEnabled,
                         systemThemeEnabled: $systemThemeEnabled)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            
        }
        .onAppear {
            SystemThemeManager
                .shared
                .handleTheme(darkMode: darkModeEnabled, system: systemThemeEnabled)
        }
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
