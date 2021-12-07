//
//  SettingsView.swift
//  SettingsView
//
//  Created by Brandon Tran on 2021-12-01.
//

import SwiftUI

struct SettingsView: View {
    //    @Environment(\.presentationMode) var presentationMode
    //    @AppStorage("isLogged") var isLogged = false
    //    @AppStorage("isLiteMode") var isLiteMode = false
    
    @Binding var darkModeEnabled: Bool
    @Binding var systemThemeEnabled: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    nameCard
                }
                
                Section {
                    // To profile view
                    NavigationLink { UserProfileViewV2() } label: {
                        Label("Profile", systemImage: "person.circle.fill")
                    }
                    
                    // Dark mode
                    Toggle(isOn: $darkModeEnabled) {
                        Label("Dark Mode", systemImage: darkModeEnabled ? "moon" : "sun.max")
                    }
                    .onChange(of: darkModeEnabled,
                              perform: {_ in
                        SystemThemeManager
                            .shared
                            .handleTheme(darkMode: darkModeEnabled, system: systemThemeEnabled)
                    })

                }
                //.navigationBarBackButtonHidden(false)
                .listRowSeparator(.automatic)
                
//                Toggle(isOn: $darkModeEnabled,
//                       label: {
//                    Text("Dark mode")
//                })
//                    .onChange(of: darkModeEnabled,
//                              perform: {_ in
//                        SystemThemeManager
//                            .shared
//                            .handleTheme(darkMode: darkModeEnabled, system: systemThemeEnabled)
//                    })
                
                links
                
                // Sign out button
                Button { } label: {
                    Text("Sign out")
                        .frame(maxWidth: .infinity)
                }
                .tint(.red)
                .onTapGesture {
                    // Sign out
                    signOutUser()
                    // Go back to SignInView()
                    presentationMode.wrappedValue.dismiss()
                }
                
                Section {
                    Label("Gator Carpool", systemImage: "car.fill")
                        .foregroundStyle(.linearGradient(colors: [.blue, .green, .orange], startPoint: .topLeading, endPoint: .topTrailing))
                    HStack {
                        Label("Version", systemImage: "info.circle.fill")
//                        Spacer()
                        Text("1.0")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var links: some View {
        Section {
            // Since we love our users
            Text("Got an issue? Feel free to post it on our GitHub!")
                .font(.footnote)
            
            Link(destination: URL(string: "https://github.com/Gator-Car-Pool/Car-Pool/issues")!) {
                HStack {
                    Label("GitHub", systemImage: "chevron.left.forwardslash.chevron.right")
                        .tint(.primary)
                    Spacer()
                    Image(systemName: "link")
                        .tint(.secondary)
                }
            }
        }
        .listRowSeparator(.hidden)
    }
    
    var nameCard: some View {
        VStack {
            Text("🐊")
                .font(.system(size: 32))
                .padding()
                .background(Circle().fill(.ultraThinMaterial))
                .background(AnimatedBlobView().frame(width: 500, height: 600).offset(x: 0)).scaleEffect(1)
            // Just a placeholder
            // Should be user's display name that was chosen at sign up
            Text("Kanye West")
                .font(.title.weight(.semibold))
            //.foregroundStyle(.linearGradient(colors: [.blue, .orange], startPoint: .topLeading, endPoint: .topTrailing))
                .foregroundColor(.primary)
                .lineLimit(1)
            Text("University Of Florida")
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    func signOutUser() {
        do {
            try FirebaseManager.shared.auth.signOut()
            print("User is signed out")
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        //        SettingsView()
        SettingsView(darkModeEnabled: .constant(false),
                     systemThemeEnabled: .constant(false))
        
        
    }
}
