////
////  MainView.swift
////  Uber Clone
////
////  Created by James  Luberisse on 11/17/21.
////  Copyright © 2021 Balaji. All rights reserved.
////
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
//    func updateUIView(_ uiView:  MKMapView, context: Context) {
//
//
//        func fetchData() {
//            let db = Firestore.firestore()
//
//            db.collection("shares").getDocuments() { snapshot, error in
//                if error == nil {
//                    if let snapshot = snapshot {
//                        for doc in snapshot.documents{
//                            var location = doc.data()["LocationName"] as! String
//                            var lat = doc.data()["Latitude"]
//                            var lon = doc.data()["Longitude"]
//                            print(location, lat, lon);
//
//                            let annotation = MKPointAnnotation();
//                            let coordinate = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
//                            annotation.coordinate = coordinate;
//                            map.addAnnotation(annotation);
//                            map.showsBuildings = true
//                        }
//                    }
//                }
//                else {
//
//                }
//            }
//        }
//
//        fetchData();
//
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
//        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//
//            let over = MKPolylineRenderer(overlay: overlay)
//            over.strokeColor = .orange
//            over.lineWidth = 3
//            return over
//        }
//    }
//
//}
//
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

//
//
//
//import SwiftUI
//import MapKit
//import Combine
//import Firebase
//
//struct MainView: View {
//    
//    @ObservedObject private var locationManager = LocationManager()
//    @State private var region = MKCoordinateRegion.defaultRegion
//    @State private var cancellable: AnyCancellable?
//    
//    private func setCurrentLocation() {
//        cancellable = locationManager.$location.sink { location in
//            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 2500, longitudinalMeters: 2500)
//        }
//    }
//    
//    
//    
//            func fetchData() {
//                let db = Firestore.firestore()
//    
//                db.collection("shares").getDocuments() { snapshot, error in
//                    if error == nil {
//                        if let snapshot = snapshot {
//                            for doc in snapshot.documents{
//                                var location = doc.data()["LocationName"] as! String
//                                var lat = doc.data()["Latitude"]
//                                var lon = doc.data()["Longitude"]
//                                print(location, lat, lon);
//    
//                                let annotation = MKPointAnnotation();
//                                let coordinate = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
//                                annotation.coordinate = coordinate;
//                     
//                            }
//                        }
//                    }
//                    else {
//    
//                    }
//                }
//            }
//    
//    let annotations =  fetchData(self.MainView)
//    
//    
//            
//    
//   
//    var body: some View {
//        
//        
//        VStack {
//            if locationManager.location != nil {
//                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil )
////                Map(coordinateRegion: $region,annotationItems interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)
//            } else {
//                Text("Locating user location...")
//            }
//        }            .edgesIgnoringSafeArea(.all)
//
//        
//        .onAppear {
//            setCurrentLocation()
//        }
//    }
//}
//






//
//import SwiftUI
//import MapKit
//import Combine
//import Firebase
//
//struct Point: Identifiable {
//    let id = UUID();
//    let name : String
//    let coordinate : CLLocationCoordinate2D
//}
//struct MainView: View {
//    
//    @ObservedObject private var locationManager = LocationManager()
//    @State private var region = MKCoordinateRegion.defaultRegion
//    @State private var cancellable: AnyCancellable?
//    @State private var annotations: [Point]
//    
//    private func setCurrentLocation() {
//        cancellable = locationManager.$location.sink { location in
//            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 2500, longitudinalMeters: 2500)
//        }
//    }
//    
//    
//    
//            func fetchData() {
//                let db = Firestore.firestore()
//    
//                db.collection("shares").getDocuments() { snapshot, error in
//                    if error == nil {
//                        if let snapshot = snapshot {
//                            for doc in snapshot.documents{
//                                var location = doc.data()["LocationName"] as! String
//                                var lat = doc.data()["Latitude"]
//                                var lon = doc.data()["Longitude"]
//                                print(location, lat, lon);
//    
////                                let annotation = MKPointAnnotation();
//                                let coordinate = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
////                                annotation.coordinate =
//                                annotations.append(Point(name: location, coordinate: coordinate))
//                     
//                            }
//                        }
//                    }
//                    else {
//    
//                    }
//                }
//            }
//    
//
//    
//            
//    
//   
//    var body: some View {
//        
//        
//        VStack {
//            if locationManager.location != nil {
//                Map(coordinateRegion: $region, annotationItems: annotations) {
//                    point in MapPin(coordinate: point.coordinate)
//                }
//                
////                Map(coordinateRegion: $region,annotationItems interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)
//            } else {
//                Text("Locating user location...")
//            }
//        }            .edgesIgnoringSafeArea(.all)
//
//        
//        .onAppear {
//            fetchData()
//            setCurrentLocation()
//        }
//    }
//}
//
//
//
//
//
//
//
//
