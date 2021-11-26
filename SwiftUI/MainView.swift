



import SwiftUI
import MapKit
import Combine
import Firebase

struct Point: Identifiable {
    let id = UUID();
    let name : String
    let coordinate : CLLocationCoordinate2D
    let email: String
    var drawed = false;
    var time_created = ""
    
    mutating func drawedToggle() {
        self.drawed = true;
    }
}
struct MainView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject private var locationManager = LocationManager()
    
    @State private var region = MKCoordinateRegion.defaultRegion
    
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

    @StateObject var user = User();

    
    private func setCurrentLocation() {
        cancellable = locationManager.$location.sink { location in
            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 2500, longitudinalMeters: 2500)
          

        }

    }

    


    
    @State var index = 0
    @State var showUserProfile = false;
    @State var showDetails = false;
    @State var annontations = [    Point(name: "test" , coordinate: CLLocationCoordinate2D(latitude: 0.00, longitude: 0.00), email: "")]
    @State var current = Point(name: "n/a", coordinate: CLLocationCoordinate2D(latitude: 0.00, longitude: 0.00), email: "")
    @State var showRides = false;
    @State var showLocationPicker = false;



            func fetchData() {
                annontations.removeAll()
                let db = Firestore.firestore()
                db.collection("shares").getDocuments() { snapshot, error in
                    if error == nil {
                        if let snapshot = snapshot {
                            for doc in snapshot.documents{
                                var location = doc.data()["LocationName"] as! String
                                var lat = doc.data()["Latitude"]
                                var lon = doc.data()["Longitude"]
                                var email = doc.data()["email"]
                                var time_created = doc.data()["time_created"]
                                
                                print(location, lat, lon);

//                                let annotation = MKPointAnnotation();
                                let coordinate = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
//                                annotation.coordinate =
                                annontations.append(Point(name: location, coordinate: coordinate, email: email as! String, time_created: time_created as! String))

                            }
                            print("good")
                        }
                    }
                    else {

                    }
                }
                
                
            }
    
    func fetchUserData(){
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    for doc in snapshot.documents{
                        print(FirebaseManager.shared.auth.currentUser?.uid as? String)
                        if doc.data()["uid"] as? String == FirebaseManager.shared.auth.currentUser?.uid as? String {
                        
                            self.profile_pic =  (doc.data()["profilePicUrl"] as? String)!

                            print("found")
                            
//                                let annotation = MKPointAnnotation();
        
                    }
                    print("good")
                }
            }
            else {

            }
        }

    }
    }
    
    
    func addOverlay(_ overlay: MKOverlay) -> some View {
          MKMapView.appearance().addOverlay(overlay)
          return self
      }

//let annotationsTEST = [
//    Point(name: "Location 1" , coordinate: CLLocationCoordinate2D(latitude: 29.6436, longitude: -82.3600)),
//    Point(name: "Location 2" , coordinate: CLLocationCoordinate2D(latitude: 29.6436, longitude: -82.3589)),
//    Point(name: "Location 3" , coordinate: CLLocationCoordinate2D(latitude: 29.6436, longitude: -82.3590)),
//    Point(name: "Location 1" , coordinate: CLLocationCoordinate2D(latitude: 29.6456, longitude: -82.3600)),
//    Point(name: "Location 2" , coordinate: CLLocationCoordinate2D(latitude: 29.6431, longitude: -82.3589)),
//    Point(name: "Location 3" , coordinate: CLLocationCoordinate2D(latitude: 29.6430, longitude: -82.3590)),
//]
//
//


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
                                Text(point.name)
                                    .fixedSize()
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

    //                Map(coordinateRegion: $region,annotationItems interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)
                } else {
                    Text("Locating user location...")
                }
                
                
            }            .edgesIgnoringSafeArea(.all)


            .onAppear {
              
                fetchUserData()
                if firstAppear {
                    setCurrentLocation()
                fetchData()
                }
                firstAppear = false;

            }       .onAppear {


            }
            .navigationBarHidden(true)
            
            
            if showUserProfile {
                VStack{
                    
                    HStack(spacing: 15){
                        
                        Button(action: {
                            self.showUserProfile = false;
                            self.isVisible.toggle()

                        }) {
                            
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22))
                                .foregroundColor(.black)
                        }
                        
                        Text("Profile")
                            .font(.title)
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {
                            
                        }) {
                            
                            Text("Friends")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 25)
                                .background(Color("Color"))
                                .cornerRadius(10)
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
                            
                            Text("User")
                                .font(.title)
                                .foregroundColor(Color.black.opacity(0.8))
                            
                            
                            Text(            FirebaseManager.shared.auth.currentUser?.email ?? "")
                                .foregroundColor(Color.black.opacity(0.7))
                        }
                        .padding(.leading, 20)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .environmentObject(user)

                    
                    // Tab Items...
                    
                    HStack{
                        
                        Button(action: {
                            
                            self.index = 0;
                            
                        }) {
                            
                            Text("Rider")
                                .foregroundColor(self.index == 0 ? Color.white : .gray)
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(self.index == 0 ? Color("Color") : Color.clear)
                                .cornerRadius(10)
                        }
                        
              
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
                    
                    HStack(spacing: 20){
                        Button(action: {
                            print("go to user profile")
                        }) {
                        VStack(spacing: 12){
                            
                            Image("message")
                            .resizable()
                            .frame(width: 80, height: 80)
                            
                
                            
                            Text("Messages")
                                .foregroundColor(Color("Color"))

                        }
                        .padding(.vertical)
                        // half screen - spacing - two side paddings = 60
                        .frame(width: (UIScreen.main.bounds.width - 60) / 2)
                        .background(Color("Color1"))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                        .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                        // shadows...
                        }
                        Button(action: {
                            print("go to user profile")
                        })  {
                        
                        VStack(spacing: 12){
                            
                            Image("mode")
                            .resizable()
                            .frame(width: 80, height: 80)
                            
                     
                            Text("Mode")
                                .foregroundColor(Color("Color"))

                        }
                        .padding(.vertical)
                        // half screen - spacing - two side paddings = 60
                        .frame(width: (UIScreen.main.bounds.width - 60) / 2)
                        .background(Color("Color1"))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                        .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                        // shadows...
                        }
                        
                    }
                    .padding(.top,20)
                    
                    HStack(spacing: 20){
                
                   
                        
                       
                  
                    }
                    Spacer(minLength: 0)
                }
                .background(Color("Color1").edgesIgnoringSafeArea(.all))


            }

            if showRides {
                
       
                VStack{
                    HStack(spacing: 5){
                        
                        Button(action: {
                            self.showRides.toggle();
                            self.isVisible.toggle()

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
                            
                            Text("Rides")
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
                                    Circle().stroke(Color.green, lineWidth: 3))
                        
                    Text(Point.name)
                        .font(.headline)
                    }.padding(7);
                        }
                    }
                }
                .background(Color("Color1").edgesIgnoringSafeArea(.all))

                
                
            }
            
            
            if showLocationPicker {
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
  
            if showDetails {
                
            
            
            
                ZStack(alignment: .topLeading) {
                    Color.white.opacity(0.8)
                        .frame(width: 300, height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                        .blur(radius: 1)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            
                            Text("👩🏾‍🦳")
                                .shadow(radius: 3)
                                .font(.largeTitle)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle().stroke(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.blue]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/),lineWidth: 3))
              
                            Text("User")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                            Button(action: {
                                self.showUserProfile.toggle();
                                self.showDetails = false;
                                self.isVisible = false
                            }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                            }
                        
                        }
                        Text(current.email)
                            .font(.caption)
                        
                        Text("Destination: \(current.name) \nCreated: \(current.time_created)")
                            .font(.footnote)
                        
                        Button(action: {
                            
                            self.showDetails.toggle()
                            
                            
                        }) {
                            
                            Text("Send Request")
        
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .frame(width: UIScreen.main.bounds.width / 2)
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
            }
                
            Button(action: {
                print("See Driver list")
                self.showRides.toggle();
                self.isVisible.toggle()
            }) {

                HStack{
                    Image("car")
                        .resizable()
                        .frame(width: 20, height:20)

                }
                .padding()

                .background(Color.white)
                .cornerRadius(40)
                .frame(height: isVisible ? nil : 0)
                 .disabled(!isVisible)

            }
            .position(x: UIScreen.main.bounds.size.width*0.9, y: UIScreen.main.bounds.size.height*0.1)


            Button(action: {
                print("go to user profile")
                self.showUserProfile = true
                self.isVisible.toggle()
//

            }) {

                HStack{
                    Image("user")
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
            .position(x: UIScreen.main.bounds.size.width*0.9, y: UIScreen.main.bounds.size.height*0.3)

            //fix nav link
           
            
            Button(action: {
                print("Pick location")
                
                if firstLocationAction {
                self.showLocationPicker = true;
                self.pushActive = true;
                    firstLocationAction = false;
                } else {
                    self.selection = 2
                    refresh = true;
                    pushActive = true;
                    self.fetchData()

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
            .position(x: UIScreen.main.bounds.size.width*0.9, y: UIScreen.main.bounds.size.height*0.4)

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
