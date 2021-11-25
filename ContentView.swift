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
