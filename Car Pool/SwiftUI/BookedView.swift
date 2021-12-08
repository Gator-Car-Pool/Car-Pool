//
//  BookedView.swift
//

import SwiftUI
import Firebase

struct Booked : View {
    
    @Binding var data : Data
    @Binding var doc : String
    @Binding var loading : Bool
    @Binding var book : Bool
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack(spacing: 25){
                
                    Text("Done")
                        .padding(.vertical,25)
                        .frame(width: UIScreen.main.bounds.width / 4)

                Button(action: {
                    
                    self.loading.toggle()
                    self.book.toggle()
                    
                    let db = Firestore.firestore()
                    
                    db.collection("Booking").document(self.doc).delete { (err) in
                        
                        if err != nil{
                            
                            print((err?.localizedDescription)!)
                            return
                        }
                        
                        self.loading.toggle()
                    }
                    
                }) {
                    
                    Text("Ok")
                        .foregroundColor(.white)
                        .padding(.vertical,20)
                        .frame(width: UIScreen.main.bounds.width / 2)
                    
                }
                .background(Color.red)
                .clipShape(Capsule())
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(.vertical, 300)
            .padding(.horizontal, 100)
            .cornerRadius(12)
        }
        .background(Color.black.opacity(0.25).edgesIgnoringSafeArea(.all))
    }
}
