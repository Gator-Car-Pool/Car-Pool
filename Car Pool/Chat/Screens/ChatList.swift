//
//  ChatList.swift
//  Car Pool
//
//  Created by Jesus Jurado on 11/15/21.
//
import SwiftUI
import FirebaseAuth

struct ChatList: View {
    //@ObservedObject var viewModel = ChatroomModel()
    @StateObject var viewModel = ChatroomModel()
    //@State var viewModel = ChatroomModel()
    //@EnvironmentObject var viewModel = ChatroomModel()
    @State var joinModal = false
    @State var isFirstTime = true
    let user = Auth.auth().currentUser
    var chatTitle = ""
//    var chatTitle = ""
//    if(chatroom.title[0] == Auth.auth().currentUser?.email){
//        chatTitle = chatroom.title[0]
//    }
//    else{
//        chatTitle = chatroom.title[1]
//    }
//    init() {
//        viewModel.fetchData()
//    }
    
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
            .navigationBarItems(trailing: Button(action: {
                self.joinModal = true
            }, label: {
                Image(systemName: "plus.circle")
            }))
            .sheet(isPresented: $joinModal, content:{
                join(isOpen: $joinModal)
            })
        }
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList()
    }
}
