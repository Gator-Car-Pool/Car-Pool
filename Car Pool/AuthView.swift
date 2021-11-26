//
//  AuthView.swift
//  Car Pool
//
//  Created by James  Luberisse on 11/23/21.
//

import SwiftUI
class AppSettings: ObservableObject {
    @Published var authentication = false
}

struct AuthView: View {
    @EnvironmentObject var settings: AppSettings

    var body: some View {
        Text("")
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
