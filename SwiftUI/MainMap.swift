//
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
