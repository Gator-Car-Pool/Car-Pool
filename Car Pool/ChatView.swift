//
//  ChatView.swift
//  Car Pool
//
//  Created by Brandon Tran on 11/9/21.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
            Divider()
            Spacer()
        }
        .background(Color.purple)
         
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView().navigationBarBackButtonHidden(true)
    }
}
