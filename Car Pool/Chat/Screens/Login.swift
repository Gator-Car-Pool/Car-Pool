//
//  Login.swift
//  Car Pool
//
//  Created by Jesus Jurado on 11/15/21.
//
import SwiftUI

struct Login: View {
    @State var email = ""
    @State var password = ""
    @ObservedObject var sessionSession = SessionModel()


    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)

                Button(action: {
                    sessionSession.signIn(email: email, password: password)
                }, label: {
                    Text("Login")
                })

                Button(action: {
                    sessionSession.signUp(email: email, password: password)
                }, label: {
                    Text("Sign up")
                })
            }
            .padding(.horizontal)
            .navigationBarTitle("Welcome")
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
