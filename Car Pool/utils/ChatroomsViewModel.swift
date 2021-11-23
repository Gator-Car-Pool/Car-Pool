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
            print(user!.uid)
            
            
            db.collection("chats").whereField("users", arrayContains: user!.uid).addSnapshotListener({(snapshot, error) in
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
    
    func createChatroom(title: String, handler: @escaping () -> Void) {
        if (user != nil) {
            db.collection("chats").addDocument(data: [
                                                "title": title,
                                                "joinCode": Int.random(in:10000..<99999),
                                                "users": [user!.uid]]) { err in
                if let err = err {
                    print("error adding document! \(err)")
                }
                else {
                    handler()
                }
            }
        }
    }
    
    //Creates chatroom with choser user *USE THIS ONE FOR MAP*
    func createNewChatroom(reciever: String, title: String, handler: @escaping () -> Void) {
        if (user != nil) {
            db.collection("chats").addDocument(data: [
                                                "title": title,
                                                "joinCode": Int.random(in:10000..<99999),
                                                "users": [user!.uid, reciever]]) { err in
                if let err = err {
                    print("error adding document! \(err)")
                }
                else {
                    handler()
                }
            }
        }
    }
    
    func joinChatroom(code: String, handler: @escaping () -> Void) {
        if (user != nil) {
            db.collection("chats").whereField("joinCode", isEqualTo: Int(code)).getDocuments() { (snapshot, error) in
                if let error = error {
                    print("error getting documents! \(error)")
                
                }
                else {
                    for document in snapshot!.documents {
                        self.db.collection("chats").document(document.documentID).updateData([
                                                                                                "users": FieldValue.arrayUnion([self.user!.uid])])
                        handler()
                    }
                }
            }
        }
    }
}
