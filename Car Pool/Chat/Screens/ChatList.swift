//
//  ChatList.swift
//  Car Pool
//
//  Created by Jesus Jurado on 11/15/21.
//

import SwiftUI
import FirebaseAuth

struct ChatList: View {
    @StateObject var viewModel = ChatroomModel()
    @State var joinModal = false
    @State var isFirstTime = true
    let user = Auth.auth().currentUser
    var chatTitle = ""
    
    var body: some View {
        NavigationView{
            List(viewModel.chatrooms) { chatroom in
                NavigationLink(destination: Messages(chatroom: chatroom)){
                    HStack{
                        Text(chatroom.title[0])
                        Spacer()
                    }
                }
                
            }.onAppear(){
                viewModel.fetchData()
            }
            .navigationTitle("Messages")
        }
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList()
    }
}
