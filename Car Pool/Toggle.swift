import SwiftUI

struct ToggleView : View {

    @Binding var show : Bool
  var body: some View {

    ZStack{
        Capsule().fill(Color.gray.opacity(0.6)).frame(width: 100, height: 45)
        HStack {
            if show {
                Spacer()
                Text("driver").foregroundColor(.black)
            }
        ZStack{
            Capsule().fill(Color.white).frame(width: 60, height: 48)
            if show {
            Image("mode")
                .resizable()
                .frame(width: 20, height: 20).foregroundColor(.green)
            } else {
                Image("passenger")
                    .resizable()
                    .frame(width: 20, height: 20).foregroundColor(.green)
            }
        }.onTapGesture {
            self.show.toggle()
        }
            if !show {
                    Text("rider  ").foregroundColor(.black)
                Spacer()
            }
        }.frame(width:135, height: 45)
    }
  }
}
