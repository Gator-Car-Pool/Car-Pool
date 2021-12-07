//
//  Messages.swift
//  Car Pool
//
//  Created by Jesus Jurado on 11/23/21.
//

import SwiftUI

struct Messages: View {
    let chatroom: Chatroom
    @ObservedObject var viewModel = MessageModel()
    @State var messageField = ""
    
    
    init(chatroom: Chatroom) {
        self.chatroom = chatroom
        viewModel.fetchData(docId: chatroom.id)
    }
    
    var body: some View {
        VStack {
            List(viewModel.messages) { message in
                HStack {
                    VStack(alignment: .leading){
                        Text(message.name)
                            .font(Font.footnote.weight(.light))
                        Text(message.content)
                    }
                    Spacer()
                }
            }
            HStack {
                TextField("Enter message...", text: $messageField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    viewModel.sendMessage(messageContent: messageField, docId: chatroom.id)
                }, label: {
                    Text("Send")
                })
            }
        }
            .navigationBarTitle(chatroom.title[0])
    }
}

struct Messages_Previews: PreviewProvider {
    
    static var previews: some View {
        Messages(chatroom: Chatroom(id: "10101", title: [""], joinCode: 10))
    }
}
