//
//  SessionStore.swift
//  Car Pool
//
//  Created by Jesus Jurado on 11/15/21.
//
import Foundation
import FirebaseAuth

struct UserTest {
    var uid: String
    var email: String
}


class SessionStore: ObservableObject {
    @Published var session: UserTest?
    @Published var isAnon: Bool = false
    var handle: AuthStateDidChangeListenerHandle?
    let authRef = Auth.auth()
    
    func listen() {
        //Disables auto login each time
        try! authRef.signOut()
        handle = authRef.addStateDidChangeListener({(auth, user) in
            if let user = user {
                print("Sucessful User")
                print(user.uid)
                print(user.email)
                self.isAnon = false
                self.session =  UserTest(uid: user.uid, email: user.email!)
                
            } else {
                print("Unsucessful User")
                self.isAnon = true
                self.session = nil
            }
        })
    }
    
    func signIn(email: String, password: String) {
        authRef.signIn(withEmail: email, password: password)
        print("Signing in...")
    }
    
    
    func signUp(email: String, password: String) {
        authRef.createUser(withEmail: email, password: password)
        print("Signing up...")
    }
    
    func signOut () -> Bool {
        do {
            try authRef.signOut()
            self.session = nil
            self.isAnon = true
            return true
        } catch {
            return false
        }
    }
    
    func unbind () {
        if let handle = handle {
            authRef.removeStateDidChangeListener(handle)
        }
    }
    
}
