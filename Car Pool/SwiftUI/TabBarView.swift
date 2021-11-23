//
//  TabBarView.swift
//  Car Pool
//
//  Created by Valerie Chery on 11/17/21.
//

import SwiftUI
import MapKit
import CoreLocation
import Firebase

struct TabBarView: View {
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = false
    @State var map = MKMapView()
    @State var manager = CLLocationManager()
    @State var alert = false
    @State var source : CLLocationCoordinate2D!
    @State var destination : CLLocationCoordinate2D!
    @State var name = ""
    @State var distance = ""
    @State var time = ""
    @State var show = false
    @State var loading = false
    @State var book = false
    @State var doc = ""
    @State var data : Data = .init(count: 0)
    @State var search = false
    var body: some View {
        
//            SignInView()
        
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
