//
//  FirebaseManager.swift
//  Car Pool
//
//  Created by Brandon Tran on 11/23/21.
//
import Foundation
import Firebase

// Singleton obj to allow us to do stuff in the preview
class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    // Singleton obj
    static let shared = FirebaseManager()
    
    override init() {
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
