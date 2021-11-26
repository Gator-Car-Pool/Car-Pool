import SwiftUI

struct ToggleView : View {

 
    @Binding var show : Bool
  var body: some View {

    ZStack{
        Capsule().fill(Color.gray).frame(width: 100, height: 45)
        
        
        
        HStack {
            
            if show {
                Spacer()
                Text("rider").foregroundColor(.white)
            }
        ZStack{
            
            
            Capsule().fill(Color.orange).frame(width: 60, height: 48)
            if show {
            Image("passenger")
                .resizable()
                .frame(width: 20, height: 20).foregroundColor(.green)
            } else {
                Image("mode")
                    .resizable()
                    .frame(width: 20, height: 20).foregroundColor(.green)
            }
        }.onTapGesture {
            self.show.toggle()
        }
            
            if !show {
              
                    Text("driver  ").foregroundColor(.white)
                Spacer()
            }
        }.frame(width:135, height: 45)    }
  }
}
