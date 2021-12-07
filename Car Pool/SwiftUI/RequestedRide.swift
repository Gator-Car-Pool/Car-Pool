import SwiftUI
import MapKit
import Combine
import Firebase

struct RequestedRide: Identifiable {

    var sender = ""
    var point = Point(id: "", name: "test" , coordinate: CLLocationCoordinate2D(latitude: 0.00, longitude: 0.00), email: "", isUser: false);
    var id = ""
    var pending = true;
    var accept = false;
    
}


