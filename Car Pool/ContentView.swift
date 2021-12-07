import SwiftUI

struct ContentView : View {

    @StateObject var settings = AppSettings()
    @StateObject var user = User()

  var body: some View {

    VStack{
        SignInView().environmentObject(user)
    }
  }
}
