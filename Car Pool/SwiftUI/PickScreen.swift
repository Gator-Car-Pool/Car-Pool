//
//  Home.swift
//  Uber Clone
//
//  Created by Balaji on 29/04/20.
//  Copyright © 2020 Balaji. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation
import Firebase

struct PickScreen : View {
    
    @State var map = MKMapView()
    @State var manager = CLLocationManager()
    @State var alert = false
    @State var source : CLLocationCoordinate2D!
    @State var destination : CLLocationCoordinate2D!
    @State var name = ""
    @State var distance = ""
    @State var time = ""
    @State var show = false
    @State var loading = false
    @State var book = false
    @State var doc = ""
    @State var data : Data = .init(count: 0)
    @State var search = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    func getTime()->String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        let dateString = formatter.string(from: Date())
        return dateString
          
        
   }
    
    var btnBack : some View { Button(action: {
         self.presentationMode.wrappedValue.dismiss()
         }) {
             HStack {
             Image(systemName: "chevron.left") // set image here
             }
         }
     }
    
    var body: some View{
        

        ZStack{
            
            ZStack(alignment: .bottom){
                
                VStack(spacing: 0){
                    
                    HStack{
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text(self.destination != nil ? "Destination" : "Pick a Location")
                                .font(.title)
                            
                            if self.destination != nil{
                                
                                Text(self.name)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        

                    }
                    .padding()
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .background(Color.white)
                    
                    

                    MapView(map: self.$map, manager: self.$manager, alert: self.$alert, source: self.$source, destination: self.$destination, name: self.$name,distance: self.$distance,time: self.$time, show: self.$show)
                    
                    
                    
                }
                
                if self.destination != nil && self.show{
                    
                    ZStack(alignment: .topTrailing){
                        
                        VStack(spacing: 20){
                            

                         
                            HStack{
                                
                                VStack(alignment: .leading,spacing: 15){
                                    
                                    Text("Destination")
                                        .fontWeight(.bold)
                                    Text(self.name)
                                    
                                    Text("Distance - "+self.distance+" Miles")
                                    
                                    Text("Expexted Time - "+self.time + "Min")
                                }
                                
                                Spacer()
                            }
                            
                            Button(action: {
                                
                                self.loading.toggle()
                                
                                self.Book()
                                
                            }) {
                                
                                Text("Start Carpool")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .frame(width: UIScreen.main.bounds.width / 2)
                            }
                            .background(Color.blue)
                            .clipShape(Capsule())
                            .padding(.vertical, 50)

                        
                        }
                        
                        Button(action: {
                            
                            self.map.removeOverlays(self.map.overlays)
                            self.map.removeAnnotations(self.map.annotations)
                            self.destination = nil
                            
                            self.show.toggle()
                            
                        }) {
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                    .background(Color.white)
                    
                    
                } else {
                    
                    Button(action: {
                        self.search.toggle()

                    }) {
                        
                        HStack{
                            Image("search")
                                .resizable()
                                .frame(width: 20, height:20)

                            
                        }
                        .padding()
                        
                        .background(Color.white)
                        .cornerRadius(40)
                    }
                    .position(x: UIScreen.main.bounds.size.width*0.9, y: UIScreen.main.bounds.size.height*0.4)
                    
                }
            }
            
            if self.loading{
                
                Loader()
            }
            
            if self.book{
                
                Booked(data: self.$data, doc: self.$doc, loading: self.$loading, book: self.$book)
            }
            
            if self.search{
                
                SearchView(show: self.$search, map: self.$map, source: self.$source, destination: self.$destination, name: self.$name, distance: self.$distance, time: self.$time,detail: self.$show)
                    .cornerRadius(10)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: self.$alert) { () -> Alert in
            
            Alert(title: Text("Error"), message: Text("Please Enable Location In Settings"), dismissButton: .destructive(Text("Ok")))
            
            
        
        }
        .navigationBarBackButtonHidden(true)
           .navigationBarItems(leading: btnBack)
        

        
    }
    
    func Book(){
        
        let db = Firestore.firestore()
        let doc = db.collection("Rides").document()
        self.doc = doc.documentID
        
        let from = GeoPoint(latitude: self.source.latitude, longitude: self.source.longitude)
        let to = GeoPoint(latitude: self.destination.latitude, longitude: self.destination.longitude)
        let time = getTime()
        doc.setData(["name":"User","from":from,"to":to,"distance":self.distance,"fair": (self.distance as NSString).floatValue * 1.2]) { (err) in
            db.collection("shares").document().setData(["email":FirebaseManager.shared.auth.currentUser?.email ?? "","LocationName":self.name,"Latitude":self.destination.latitude,"Longitude": self.destination.longitude, "time_created":time ] )

            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            
//            let filter = CIFilter(name: "CIQRCodeGenerator")
//            filter?.setValue(self.doc.data(using: .ascii), forKey: "inputMessage")
//
//            let image = UIImage(ciImage: (filter?.outputImage?.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))!)
//
//            self.data = image.pngData()!
            
            
            self.loading.toggle()
            self.book.toggle()
            
        }
    }
}
