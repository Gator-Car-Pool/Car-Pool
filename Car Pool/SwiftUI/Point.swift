import SwiftUI
import MapKit
import Combine
import Firebase



struct Point: Identifiable {
    let id : String
    let name : String
    let coordinate : CLLocationCoordinate2D
    let email: String
    var drawed = false;
    var time_created = ""
    var isUser : Bool;
    var list: [String] = [""]

}


