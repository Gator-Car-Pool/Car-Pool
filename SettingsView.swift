//
//  SettingsView.swift
//  Car Pool
//
//  Created by Valerie Chery on 11/17/21.
//

import SwiftUI

struct SettingsView: View {
    
    @State var password = ""
    
    @Binding var darkModeEnabled: Bool
    @Binding var systemThemeEnabled: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var btnBack : some View { Button(action: {
         self.presentationMode.wrappedValue.dismiss()
         }) {
             HStack {
             Image(systemName: "chevron.right")
             Text("Log out")// set image here
             }
         }
     }
    

    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Profile"),
                        footer: Text("Edit your user profile info.")) {
                    SecureField("New password", text: $password)
                }
                
                Section(header: Text("Display"),
                        footer: Text("Change the look of the app! Switch to dark mode or make changes based on your system settings.")) {
                    Toggle(isOn: $darkModeEnabled,
                           label: {
                        Text("Dark mode")
                })
                        .onChange(of: darkModeEnabled,
                                  perform: {_ in
                            SystemThemeManager
                                .shared
                                .handleTheme(darkMode: darkModeEnabled, system: systemThemeEnabled)
                        })
                    Toggle(isOn: $systemThemeEnabled,
                           label: {
                        Text("Use system settings")
                })
                        .onChange(of: systemThemeEnabled,
                                  perform: {_ in
                            SystemThemeManager
                                .shared
                                .handleTheme(darkMode: darkModeEnabled, system: systemThemeEnabled)
                        })
                
            }
                
                Section(header: Text("About")) {
                    Label("Gator Carpool", systemImage: "car.fill")
                    HStack {
                        Label("Version", systemImage: "info.circle.fill")
                        Spacer()
                        Text("1.0")
                    }
                }
            
        }
            .navigationTitle("Settings")
           
            
        
    } .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
}

    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView(darkModeEnabled: .constant(false),
                         systemThemeEnabled: .constant(false))
        }
    }
}
