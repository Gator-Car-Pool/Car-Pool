//
//  join.swift
//  Car Pool
//
//  Created by Jesus Jurado on 11/22/21.
//
import SwiftUI

struct join: View {
    
    @Binding var isOpen: Bool
    @State var joinCode = ""
    @State var newTitle = ""
    @ObservedObject var viewModel = ChatroomModel()
    
    var body: some View {
        NavigationView {
            VStack{
                VStack{
                    Text("Join a chatroom")
                        .font(.title)
                    TextField("Enter your join code", text: $joinCode)
                    Button(action: {
                        viewModel.joinChatroom(code: joinCode) {
                            self.isOpen = false
                        }
//                        viewModel.createNewChatroom(reciever: "bK8IRCucpRhacDDPrTxbGUe3uMM2", title: "New Chat") {
//                            self.isOpen = false
//                        }
                    }, label: {
                        Text("Join")
                    })
                }
                .padding(.bottom)
                VStack{
                    Text("Create a chatroom")
                        .font(.title)
                    TextField("Enter a new title", text: $newTitle)
                    Button(action: {
                        viewModel.createChatroom(title: newTitle) {
                            self.isOpen = false
                        }
                    }, label: {
                        Text("Create")
                    })
                }
            }
                .navigationBarTitle("Join or Create")
            
        }
    }
}

struct join_Previews: PreviewProvider {
    static var previews: some View {
        join(isOpen: .constant(true))
    }
}
