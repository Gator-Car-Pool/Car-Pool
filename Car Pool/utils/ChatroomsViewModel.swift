//
//  ChatroomsViewModel.swift
//  Car Pool
//
//  Created by Jesus Jurado on 11/22/21.
//

import Foundation
import Firebase

struct Chatroom: Codable, Identifiable{
    var id: String
    var title: String
    var joinCode: Int
}

class ChatroomViewModel: ObservableObject{
    
    @Published var chatrooms = [Chatroom]()
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    func fetchData(){
        if (user == nil){
            print("USER IS NIL")
        }
        if (user != nil){
            print("USER IS NOT NIL")
            
            
            
            
            
            db.collection("chats").whereField("users", arrayContains: user!.uid as String).addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else{
                    print("no docs returned")
                    return
                }
                self.chatrooms = documents.map({docSnapshot -> Chatroom in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let title = data["title"] as? String ?? ""
                    let joinCode = data["joinCode"] as? Int ?? -1
                    return Chatroom(id: docId, title: title, joinCode: joinCode)
                })
            })
        }
    }
}
