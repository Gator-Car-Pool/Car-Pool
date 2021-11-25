//
//import SwiftUI
//import MapKit
//import CoreLocation
//import Firebase
//
//
//struct MainView: View {
//
//    @State var map = MKMapView()
//    @State var manager = CLLocationManager()
//    @State var alert = false
//    @State var source : CLLocationCoordinate2D!
//    @State var destination : CLLocationCoordinate2D!
//    @State var selection: Int? = nil
//
//    var body: some View {
//        NavigationView {
//        ZStack {
//
//            
//            
//            VStack(spacing: 0) {
//                
//        
//                MainMap(map: self.$map, manager: self.$manager, alert: self.$alert, source: self.$source, destination: self.$destination)
//            }         .onAppear {
//                
//                self.manager.requestAlwaysAuthorization()
//                    
//            }
//            .navigationBarHidden(true)
//
//
//            Button(action: {
//                print("Delete tapped!")
//            }) {
//                
//                HStack{
//                    Image("car")
//                        .resizable()
//                        .frame(width: 20, height:20)
//                      
//                }
//                .padding()
//                
//                .background(Color.white)
//                .cornerRadius(40)
//
//            }
//            .position(x: UIScreen.main.bounds.size.width*0.9, y: UIScreen.main.bounds.size.height*0.1)
//            
//            
//            Button(action: {
//                print("Delete tapped!")
//            }) {
//                
//                HStack{
//                    Image("user")
//                        .resizable()
//                        .frame(width: 20, height:20)
//
//                }
//                .padding()
//                
//                .background(Color.white)
//                .cornerRadius(40)
//
//            }
//            .position(x: UIScreen.main.bounds.size.width*0.9, y: UIScreen.main.bounds.size.height*0.2)
//            
//            Button(action: {
//                self.selection = 2
//                print("Delete tapped!")
//            }) {
//                
//                HStack{
//                    Image("refresh")
//                        .resizable()
//                        .frame(width: 20, height:20)
//
//                    
//                }
//                .padding()
//                
//                .background(Color.white)
//                .cornerRadius(40)
//
//            }
//            .position(x: UIScreen.main.bounds.size.width*0.9, y: UIScreen.main.bounds.size.height*0.3)
//            
//            //fix nav link
//            NavigationLink(destination: PickScreen(), tag: 1, selection: $selection) {
//
//            Button(action: {
//                print("Delete tapped!")
//                self.selection = 1
//            }) {
//                
//                HStack{
//                    Image("gator")
//                        .resizable()
//                        .frame(width: 50, height:50)
//                        .cornerRadius(40)
//
//                    
//                }
//                .cornerRadius(40)
//
//            }
//            .position(x: UIScreen.main.bounds.size.width*0.9, y: UIScreen.main.bounds.size.height*0.4)
//
//            }
//        }
//        .edgesIgnoringSafeArea(.all)
//        .alert(isPresented: self.$alert) { () -> Alert in
//
//            Alert(title: Text("Error"), message: Text("Please Enable Location In Settings"), dismissButton: .destructive(Text("Ok")))
//        }    }
//            .navigationBarTitle("", displayMode: .inline)
//                 .navigationBarHidden(true)
//            
//    }
//}
//
//
//
//struct MainMap : UIViewRepresentable {
//    
//    func makeCoordinator() -> Coordinator {
//        
//        return MainMap.Coordinator(parent1: self)
//    }
//    
//    @Binding var map : MKMapView
//    @Binding var manager : CLLocationManager
//    @Binding var alert : Bool
//    @Binding var source : CLLocationCoordinate2D!
//    @Binding var destination : CLLocationCoordinate2D!
//
//    func makeUIView(context: Context) ->  MKMapView {
//        
//        map.delegate = context.coordinator
//        manager.delegate = context.coordinator
//        map.showsUserLocation = true
//  
//        return map
//    }
//    
//
//
//    func updateUIView(_ uiView:  MKMapView, context: Context) {
//                func fetchData() {
//                    let db = Firestore.firestore()
//        
//                    db.collection("shares").getDocuments() { snapshot, error in
//                        if error == nil {
//                            if let snapshot = snapshot {
//                                for doc in snapshot.documents{
//                                    var location = doc.data()["LocationName"] as! String
//                                    var lat = doc.data()["Latitude"]
//                                    var lon = doc.data()["Longitude"]
//                                    print(location, lat, lon);
//        
//                                    let annotation = MKPointAnnotation();
//                                    let coordinate = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
//                                    annotation.coordinate = coordinate;
//                                    annotation.title = location;
//                                    annotation.subtitle = "James"
//                                    
//                           
//                                    map.addAnnotation(annotation);
//                                    map.showsBuildings = true
//                             
//                                }
//                            }
//                        }
//                        else {
//        
//                        }
//                    }
//                }
//        
//                fetchData();
//    }
//     
//    class Coordinator : NSObject,MKMapViewDelegate,CLLocationManagerDelegate{
//        
//        var parent : MainMap
//        
//        init(parent1 : MainMap) {
//            
//            parent = parent1
//        }
//        
//        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//            
//            if status == .denied{
//                
//                self.parent.alert.toggle()
//            }
//            else{
//                
//                self.parent.manager.startUpdatingLocation()
//            }
//        }
//        
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            
//            let region = MKCoordinateRegion(center: locations.last!.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
//            self.parent.source = locations.last!.coordinate
//            
//            self.parent.map.region = region
//        }
//       
//        
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//    
//            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "TESTING NOTE")
//                        annotationView.canShowCallout = true
//            if(annotationView.annotation?.title == "My Location") {
//                annotationView.image = Image("")
//                let size = CGSize(width: 20
//                                  , height: 20)
//                return annotationView
//            }
//                   annotationView.image = UIImage(systemName: "heart.fill")
//                   let size = CGSize(width: 20
//                                     , height: 20)
//            
//                   annotationView.image = UIGraphicsImageRenderer(size:size).image {
//                       _ in annotationView.image!.draw(in:CGRect(origin:.zero, size:size))
//                   }
//                return annotationView
//
//         
//    
//}
//
//    }
//}
//
////
////class SharedLocations : ObservableObject {
////
////    @Published var locations = [Location]()
////
////    private var db = Firestore.firestore();
////
////    func fetchData() {
////
////        db.collection("locations").addSnapshotListener{
////            (querySnaphot, error) in
////            guard let documents = querySnaphot?.documents else {
////                print("none")
////                return
////            }
////
////            documents.map { (queryDocumentSnapshot) -> Location in
////                let data = queryDocumentSnapshot.data()
////
////            let name =  data["locationName"] as? String ?? ""
////                let point = data["location"] as! GeoPoint
////            let location = Location(name: name, point: point)
////            return location;
////            }
////    }
////}
////}
//
