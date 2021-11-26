//
//  ChatList.swift
//  Car Pool
//
//  Created by Jesus Jurado on 11/15/21.
//
import SwiftUI

struct ChatList: View {
    @ObservedObject var viewModel = ChatroomViewModel()
    @State var joinModal = false
    
    init() {
        viewModel.fetchData()
    }
    
    var body: some View {
        NavigationView{
            List(viewModel.chatrooms) { chatroom in
                NavigationLink(destination: Messages(chatroom: chatroom)){
                    HStack{
                        Text(chatroom.title)
                        Spacer()
                    }
                }
                
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
