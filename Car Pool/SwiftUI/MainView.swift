import SwiftUI
import MapKit
import Combine
import Firebase

struct MainView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var showBar = Bar();
    @ObservedObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion.defaultRegion
    @State var count = 0;
    @State private var cancellable: AnyCancellable?
    @State var selection: Int? = nil
    @State var toPickScreen: Bool = false
    @State var isVisible: Bool = true;
    @State var pushActive: Bool = false;
    @State var refresh: Bool = false;
    @State var firstAppear: Bool = true;
    @State var firstLocationAction: Bool = true;
    @State var profile_pic = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
    @State var show = false
    @Binding var display : Bool;
    @StateObject var user = User();
    @ObservedObject var viewModel = ChatroomModel()
    private let db = Firestore.firestore()

    
    init( display: Binding<Bool> ) {
        self._display = display
    }
    private func setCurrentLocation() {
        cancellable = locationManager.$location.sink { location in
            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 2500, longitudinalMeters: 2500)
        }
    }
    
    @State var index = 0
    @State var showUserProfile = false;
    @State var showOtherUserProfile = false;
    @State var showDetails1 = false;
    @State var showDetails = false;
    @State var annontations: [Point] = [    Point(id: "", name: "test" , coordinate: CLLocationCoordinate2D(latitude: 0.00, longitude: 0.00), email: "", isUser: false)]
    @State var requestedRides: [Point] = [    Point(id: "", name: "test" , coordinate: CLLocationCoordinate2D(latitude: 0.00, longitude: 0.00), email: "", isUser: false)]
    @State var UserRideRequests: [String] = [""]
    @State var current = Point(id: "", name: "n/a", coordinate: CLLocationCoordinate2D(latitude: 0.00, longitude: 0.00), email: "", isUser: false)
    @State var showRides = false;
    @State var showLocationPicker = false;
    
    func fetchData() {
        annontations.removeAll()
        let db = Firestore.firestore()
        db.collection("shares").getDocuments() { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    for doc in snapshot.documents{
                        let location = doc.data()["LocationName"] as! String
                        let lat = doc.data()["Latitude"]
                        let lon = doc.data()["Longitude"]
                        let email = doc.data()["email"] as! String
                        let time_created = doc.data()["time_created"]
                        let id = doc.data()["uid"]
                        var isUser = true;
                        let list = doc.data()["requests"]
                        print(location, lat, lon);
                        if FirebaseManager.shared.auth.currentUser?.uid as? String == id as! String {
                            isUser = false;
                        }
                        let coordinate = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
                        annontations.append(Point(id: id as! String, name: location, coordinate: coordinate, email: email as! String, time_created: time_created as! String, isUser: isUser, list: list as! [String]))
                    }
                    print("Good")
                }
            }
            else {
                print("Not good")
            }
        }
    }
    
    func fetchUserData(){
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    for doc in snapshot.documents{
                        if doc.data()["uid"] as? String == FirebaseManager.shared.auth.currentUser?.uid as? String {
                            self.profile_pic =  (doc.data()["profilePicUrl"] as? String)!
                        }
                    }
                }
                else {
                    
                }
            }
        }
    }
        
    func postUpdate(curr: Point, action: String) {

    }
    
    func addOverlay(_ overlay: MKOverlay) -> some View {
        MKMapView.appearance().addOverlay(overlay)
        return self
    }
    
    var body: some View {
        
        NavigationView {
                        
            ZStack {
                
                VStack {
                    
                    if locationManager.location != nil {
                        
                        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil, annotationItems: annontations ) {
                            point in MapAnnotation(coordinate: point.coordinate) {
                                
                                Button(action: {
                                    self.showDetails.toggle()
                                    current = point
                                    
                                }) {
                                    
                                    HStack {
                                        
                                        Image("gator")
                                            .cornerRadius(40)
                                        if FirebaseManager.shared.auth.currentUser?.uid as? String != point.id {
                                            Text(point.name)
                                                .fixedSize()
                                        }
                                    }
                                }
                                .padding(10)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                                .shadow(radius: 2)
                                .overlay(
                                    Image(systemName: "arrowtriangle.left.fill")
                                        .rotationEffect(Angle(degrees: 270))
                                        .foregroundColor(.white)
                                        .offset(y: 10)
                                    , alignment: .bottom)
                            }
                        }
                    } else {
                        Text("Locating user location...")
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    
                    fetchUserData()
                    if firstAppear {
                        setCurrentLocation()
                        fetchData()
                    }
                    firstAppear = false;
                    
                }
                .onAppear {
                }
                .navigationBarHidden(true)
                
                if showUserProfile {
                    VStack{
                        
                        HStack(spacing: 15){
                            
                            Button(action: {
                                self.showUserProfile = false;
                                self.isVisible.toggle()
                                display.toggle()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 22))
                                    .foregroundColor(.black)
                            }
                            
                            Text("Profile")
                                .font(.title)
                            
                            Spacer(minLength: 0)
                            if current.isUser {
                                Button(action: {}) {
                                    Text("Chat")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 25)
                                        .background(Color.orange)
                                        .cornerRadius(10)
                                }
                            }
                            else {
                                
                                Button(action: {}) {
                                    Text("Messages")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 25)
                                        .background(Color.orange)
                                        .cornerRadius(10)
                                }
                            }
                            
                        }
                        .padding(50)
                        
                        HStack{
                            
                            VStack(spacing: 0){
                                
                                Rectangle()
                                    .fill(Color("Color"))
                                    .frame(width: 80, height: 3)
                                    .zIndex(1)
                                
                                let imageUrl = URL(string: profile_pic)!
                                let imageData = try! Data(contentsOf: imageUrl)
                                let image = UIImage(data: imageData)
                                
                                Image(uiImage: image!)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .padding(.top, 6)
                                    .padding(.bottom, 4)
                                    .padding(.horizontal, 8)
                                    .background(Color("Color1"))
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                                    .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                            }
                            
                            VStack(alignment: .leading, spacing: 12){
                                
                                // Hardcoded for presentation's sake
                                Text(FirebaseManager.shared.auth.currentUser?.email ?? "")
                                    .font(.title)
                                    .foregroundColor(Color.black.opacity(0.8))
                                
//                                Text(            FirebaseManager.shared.auth.currentUser?.email ?? "")
//                                    .foregroundColor(Color.black.opacity(0.7))
                            }
                            .padding(.leading, 20)
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .environmentObject(user)
                        
                        
                        // Tab Items...
                        
                        HStack{
                            
                            Text("Rides History")
                                .foregroundColor(self.index == 0 ? Color.white : .gray)
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(self.index == 0 ? Color("Color") : Color.clear)
                                .cornerRadius(10)
                            
                        }
                        .padding(.horizontal,8)
                        .padding(.vertical,5)
                        .background(Color("Color1"))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                        .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                        .padding(.horizontal)
                        .padding(.top,25)
                        
                        // Cards...
                        VStack {
                            List(annontations) {
                                Point in ZStack {
                                    NavigationLink(destination: RidesDetailView(current: Point)) {
                                        
                                        Text("🚙")
                                            .shadow(radius: 3)
                                            .font(.largeTitle)
                                            .frame(width: 75, height: 65)
                                            .overlay(
                                                Circle().stroke(Color.blue, lineWidth: 3))
                                        
                                        Text(Point.name)
                                            .font(.headline)
                                    }.padding(7);
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        HStack(spacing: 20){
                        }
                        Spacer(minLength: 0)
                    }
                    .background(Color("Color1").edgesIgnoringSafeArea(.all))
                }
                
                if showRides {
                    
                    if show == false {
                        
                        VStack{
                            HStack(spacing: 5){
                                
                                Button(action: {
                                    self.showRides.toggle();
                                    self.isVisible.toggle()
                                    display.toggle()
                                    
                                }) {
                             
                                    HStack {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 22))
                                            .foregroundColor(.black)
                                        
                                Text("Back")
                                    .font(.title)
                                    .foregroundColor(Color.black)
                                    }
                                }
                           
                                Spacer(minLength: 0)
                                
                                Button(action: {
                                    fetchData()
                                    
                                }) {
                                    
                                    Text("refresh")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 25)
                                        .background(Color("Color"))
                                        .cornerRadius(10)
                                }
                            }
                            .padding(50)
                            
                            HStack{
                                
                                VStack(alignment: .leading, spacing: 12){
                                    
                                    Text("Available Rides")
                                        .font(.title)
                                        .foregroundColor(Color.black.opacity(0.8))
                                }
                                .padding(.leading, 20)
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.top, -25)
                            
                            Spacer()
                            ToggleView(show: $show)
                            
                            List(annontations) {
                                Point in ZStack {
                                    NavigationLink(destination: RidesDetailView(current: Point)) {
                                        
                                        Text("🚙")
                                            .shadow(radius: 3)
                                            .font(.largeTitle)
                                            .frame(width: 75, height: 65)
                                            .overlay(
                                                Circle().stroke(Color.blue, lineWidth: 3))
                                        
                                        Text(Point.name)
                                            .font(.headline)
                                    }.padding(7);
                                }
                            }
                        }
                        .background(Color("Color1").edgesIgnoringSafeArea(.all))
                    } else {
                        VStack{
                            HStack(spacing: 5){
                                
                                Button(action: {
                                    self.showRides.toggle()
                                    self.isVisible.toggle()
                                    display.toggle()
                                    
                                }) {
                                    
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 22))
                                        .foregroundColor(.black)
                                }
                                
                                Text("Back")
                                    .font(.title)
                                
                                Spacer(minLength: 0)
                                
                                Button(action: {
                                    fetchData()
                                }) {
                                    
                                    Text("refresh")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 25)
                                        .background(Color("Color"))
                                        .cornerRadius(10)
                                }
                                
                            }
                            .padding(50)
                            
                            HStack{
                                
                                
                                VStack(alignment: .leading, spacing: 12){
                                    
                                    Text("Pending Requests")
                                        .font(.title)
                                        .foregroundColor(Color.black.opacity(0.8))
                                    
                                }
                                .padding(.leading, 20)
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.top, -25)
                            
                            Spacer()
                            ToggleView(show: $show)
                            
                            List(annontations) {
                                Point in ZStack {
                                    NavigationLink(destination: RidesRequestView(current: Point)) {
                                        
                                        Text("🚙")
                                            .shadow(radius: 3)
                                            .font(.largeTitle)
                                            .frame(width: 75, height: 65)
                                            .overlay(
                                                Circle().stroke(Color.orange, lineWidth: 3))
                                        
                                        Text("Pending Request: ")
                                            .font(.headline)
                                        
                                    }.padding(7);
                                }
                            }
                        }
                        .background(Color("Color1").edgesIgnoringSafeArea(.all))
                    }
                }
                
                if showLocationPicker {
                    if self.count == 0 {
                        NavigationLink(destination:
                                        PickScreen(),
                                       isActive: self.$pushActive) {
                            
                            EmptyView()
                            
                        }.hidden()
                        .simultaneousGesture(TapGesture().onEnded{
                            self.showLocationPicker.toggle();
                            self.pushActive.toggle();
                        })
                    }
                }
                
                if showDetails {
                    
                    ZStack(alignment: .topLeading) {
                        Color.white.opacity(0.8)
                            .frame(width: 300, height: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                            .blur(radius: 1)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                
                                Text("🐊")
                                    .shadow(radius: 3)
                                    .font(.largeTitle)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Circle().stroke(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.blue]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/),lineWidth: 3))
                                
                                if current.isUser  {
                                    Text(current.email)
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                    
                                    Button(action: {
                                        self.showUserProfile.toggle();
                                        self.showDetails = false;
                                        self.isVisible = false
                                        display.toggle()
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 22))
                                            .foregroundColor(.black)
                                    }
                                } else {
                                    Text("Your ride")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                }
                            }
                            
                            
                            Text("Destination: \(current.name) \nCreated: \(current.time_created)")
                                .font(.footnote)
                            
                            Button(action: {
                                if(current.isUser){
                                    var currentEmail = ""
                                    let user = Auth.auth().currentUser
                                    if let user = user {
                                        currentEmail = user.email!
                                    }
                                    let clickedEmail = current.email
                                    let usersArray = [currentEmail, clickedEmail]
                                    
                                    print(clickedEmail)
                                    print(currentEmail)
                                                                        
                                    viewModel.createNewChatroom(reciever: current.id, title: usersArray, handler: viewModel.fetchData)
                                }
                                else{
                                    let currentUser = Auth.auth().currentUser
                                    db.collection("shares").whereField("email", isEqualTo: currentUser?.email).whereField("time_created", isEqualTo: current.time_created).getDocuments() { (querySnapshot, err) in
                                      if let err = err {
                                        print("Error getting documents: \(err)")
                                      } else {
                                        for document in querySnapshot!.documents {
                                          document.reference.delete()
                                        }
                                      }
                                    }
                                }
                                self.showDetails.toggle()

                            }) {
                                if current.isUser  {
                                    Text("Send Message")
                                        
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .frame(width: UIScreen.main.bounds.width / 2)
                                } else {
                                    Text("Cancel Ride")
                                        
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .frame(width: UIScreen.main.bounds.width / 2)
                                }
                            }
                            .background(Color.orange.opacity(0.9))
                            .clipShape(Capsule())
                            
                            
                            Button(action: {
                                
                                self.showDetails.toggle()
                                
                            }) {
                                
                                Text("Cancel")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .frame(width: UIScreen.main.bounds.width / 2)
                            }
                            .background(Color.blue.opacity(0.9))
                            .clipShape(Capsule())
                        }
                        .padding()
                        .frame(width: 300, height: 400)
                        .foregroundColor(Color.black.opacity(0.8))
                        
                    }
                } else {
                    
                    if showDetails1 {
                        
                        ZStack(alignment: .topLeading) {
                            Color.white.opacity(0.8)
                                .frame(width: 300, height: 400)
                                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                                .blur(radius: 1)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    
                                    Text("🐊")
                                        .shadow(radius: 3)
                                        .font(.largeTitle)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle().stroke(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.blue]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/),lineWidth: 3))
                                    
                                    if current.isUser  {
                                        Text("Test")
                                            .font(.system(size: 24, weight: .bold, design: .rounded))
                                        
                                        Button(action: {
                                            self.showUserProfile.toggle();
                                            self.showDetails = false;
                                            self.isVisible = false
                                            display.toggle()
                                        }) {
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 22))
                                                .foregroundColor(.black)
                                        }
                                    } else {
                                        Text("Cannot Pick Ride")
                                            .font(.system(size: 24, weight: .bold, design: .rounded))
                                    }
                                }
                                Text(current.email)
                                    .font(.caption)
                                
                                Text("Pending Ride: Destination: \(current.name) \nCreated: \(current.time_created)")
                                    .font(.footnote)
                                
                                Button(action: {
                                    
                                    self.showDetails.toggle()
                                    
                                    
                                }) {
                                    Text("Cancel Ride")
                                        
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .frame(width: UIScreen.main.bounds.width / 2)
                                    
                                }
                                .background(Color.orange.opacity(0.9))
                                .clipShape(Capsule())
                                
                                
                                Button(action: {
                                    
                                    self.showDetails1.toggle()
                                    
                                }) {
                                    
                                    Text("Cancel")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .frame(width: UIScreen.main.bounds.width / 2)
                                }
                                .background(Color.blue.opacity(0.9))
                                .clipShape(Capsule())
                            }
                            .padding()
                            .frame(width: 300, height: 400)
                            .foregroundColor(Color.black.opacity(0.8))
                        }
                    }
                }
                //TO BE CONTINUED: new features coming soon!
                
//                Button(action: {
//                    print("See Driver list")
//                    self.showRides.toggle();
//                    self.isVisible.toggle()
//                    display.toggle()
//
//                }) {
//
//                    HStack{
//                        Image("car")
//                            .resizable()
//                            .frame(width: 20, height:20)
//
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(40)
//                    .frame(height: isVisible ? nil : 0)
//                    .disabled(!isVisible)
//
//                }
//                .position(x: UIScreen.main.bounds.size.width*0.9, y: UIScreen.main.bounds.size.height*0.1)
                
//                Button(action: {
//                    print("go to user profile")
//                    self.showUserProfile = true;
//                    self.isVisible.toggle()
//                    display.toggle()
//                }) {
//
//                    HStack{
//                        Image("user")
//                            .resizable()
//                            .frame(width: 20, height:20)
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(40)
//                    .frame(height: isVisible ? nil : 0)
//                    .disabled(!isVisible)
//                }
//                .position(x: UIScreen.main.bounds.size.width*0.9, y: UIScreen.main.bounds.size.height*0.2)
//
                Button(action: {
                    
                    self.fetchData()
                    print("refresh view")
                }) {
                    
                    HStack{
                        Image("refresh")
                            .resizable()
                            .frame(width: 20, height:20)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(40)
                    .frame(height: isVisible ? nil : 0)
                    .disabled(!isVisible)
                }
                .position(x: UIScreen.main.bounds.size.width*0.9, y: UIScreen.main.bounds.size.height*0.2)
                
                Button(action: {
                    print("Pick location")
                    self.show = true;
                    
                    for point in annontations {
                        if point.id == FirebaseManager.shared.auth.currentUser?.uid {
                            self.show = false;
                            self.showDetails1 = true;
                        }
                    }
                    
                    if self.show {
                        self.showLocationPicker = true;
                        
                        if firstLocationAction {
                            self.pushActive = true;
                            firstLocationAction = false;
                        } else {
                            self.selection = 2
                            refresh = true;
                            pushActive = true;
                            self.fetchData()
                            
                        }
                    }
                }) {
                    
                    HStack{
                        Image("gator")
                            .resizable()
                            .frame(width: 50, height:50)
                            .cornerRadius(40)
                            .frame(height: isVisible ? nil : 0)
                            .disabled(!isVisible)
                    }
                    .cornerRadius(40)
                }
                .position(x: UIScreen.main.bounds.size.width*0.9, y: UIScreen.main.bounds.size.height*0.1)
                
                Button(action: {
                    print("Pick location")
                    
                    setCurrentLocation();
                    
                }) {
                    
                    HStack{
                        Image("target")
                            .resizable()
                            .frame(width: 20, height:20)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(40)
                    .frame(height: isVisible ? nil : 0)
                    .disabled(!isVisible)
                }
                .position(x: UIScreen.main.bounds.size.width*0.9, y: UIScreen.main.bounds.size.height*0.8)
            }
            .edgesIgnoringSafeArea(.all)
            NavigationLink(destination: PickScreen(), isActive: self.$toPickScreen){
            }.disabled(true)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}


struct RidesDetailView: View {
    let current: Point
    @State private var region = MKCoordinateRegion.defaultRegion
    
    var body: some View {
        VStack() {
            
            // Meditation Image
            Text("Ride details")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Image("uf")
                .cornerRadius(30)
                
                .padding(10)
                .padding(.vertical, 10)
            
            // Title
            Text(current.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Description
            Text("This carpool started at \(current.time_created).")
            
            // GeometryReader for button width
            
            // Button stack
            Button(action: {}) {
                Text("Request to Ride")
                    .padding()
                    .foregroundColor(.blue)
                    .overlay(Capsule().stroke(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.blue]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/), lineWidth: 8))
                    .clipShape(Capsule())
            }
            .padding(.vertical,    100)
        }
        .padding()
    }
}


struct RidesRequestView: View {
    let current: Point
    @State private var region = MKCoordinateRegion.defaultRegion
    
    var body: some View {
        VStack() {
            
            // Meditation Image
            Text("User Name")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Image("uf")
                .cornerRadius(30)
                
                .padding(10)
                .padding(.vertical, 10)
            
            // Title
            Text("Wants to join your ride")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // GeometryReader for button width
            
            // Button stack
            HStack {
                Button(action: {}) {
                    Text("Accept")
                        .padding()
                        .foregroundColor(.blue)
                        .overlay(Capsule().stroke(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.blue]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/), lineWidth: 8))
                        .clipShape(Capsule())
                }
                .padding(.vertical,    100)
                
                Button(action: {}) {
                    Text("Declne")
                        .padding()
                        .foregroundColor(.blue)
                        .overlay(Capsule().stroke(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.blue]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/), lineWidth: 8))
                        .clipShape(Capsule())
                }
                .padding(.vertical,    100)
                
            }
        }
        .padding()
    }
}
