//
//  ChatList.swift
//  Car Pool
//
//  Created by Jesus Jurado on 11/15/21.
//

import SwiftUI

struct ChatList: View {
    @ObservedObject var viewModel = ChatroomViewModel()
    
    init() {
        viewModel.fetchData()
    }
    
    var body: some View {
        NavigationView{
            List(viewModel.chatrooms) { chatroom in
                HStack{
                    Text(chatroom.title)
                    Spacer()
                }
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
