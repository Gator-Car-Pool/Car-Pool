import SwiftUI

struct ContentView : View {

    @StateObject var settings = AppSettings()
    @StateObject var user = User()


  var body: some View {

    VStack{

        if settings.authentication == false {
            SignInView().environmentObject(user)
        }
     else{
        MainView().animation(Animation.spring().speed(1.0)).transition(.move(edge: .trailing))
        }
    }.onAppear(){
        if settings.authentication == false {
            print("false")
        }
     else{
        print("true")
        }

    }

  }
}


////
////  ContentView.swift
////  Car Pool
////
////  Created by Jesus Jurado on 11/15/21.
////
//import SwiftUI
//
//struct ContentView: View {
//
//    @ObservedObject var sessionStore = SessionStore()
//
//    init() {
//        sessionStore.listen()
//    }
//
//    var body: some View {
//        ChatList()
//            .fullScreenCover(isPresented: $sessionStore.isAnon, content: {
//                Login()
//            })
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
