



import SwiftUI
import MapKit
import Combine
import Firebase

struct Point: Identifiable {
    let id = UUID();
    let name : String
    let coordinate : CLLocationCoordinate2D
}
struct MainView: View {

    @ObservedObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion.defaultRegion
    @State private var cancellable: AnyCancellable?
    @State var selection: Int? = nil
    @State var toPickScreen: Bool = false
    @State var isVisible: Bool = true;
    
    
    private func setCurrentLocation() {
        cancellable = locationManager.$location.sink { location in
            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 2500, longitudinalMeters: 2500)
        }
    }

    
    
    @State var index = 0
    @State var showUserProfile = false;
    @State var showDetails = false;
    @State var annontations = [    Point(name: "test" , coordinate: CLLocationCoordinate2D(latitude: 0.00, longitude: 0.00))]
    @State var current = Point(name: "n/a", coordinate: CLLocationCoordinate2D(latitude: 0.00, longitude: 0.00))
    @State var showRides = false;



            func fetchData() {
                let db = Firestore.firestore()

                db.collection("shares").getDocuments() { snapshot, error in
                    if error == nil {
                        if let snapshot = snapshot {
                            for doc in snapshot.documents{
                                var location = doc.data()["LocationName"] as! String
                                var lat = doc.data()["Latitude"]
                                var lon = doc.data()["Longitude"]
                                print(location, lat, lon);

//                                let annotation = MKPointAnnotation();
                                let coordinate = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
//                                annotation.coordinate =
                                annontations.append(Point(name: location, coordinate: coordinate))

                            }
                            print("good")
                        }
                    }
                    else {

                    }
                }
            }
    
    struct EmojiItem: Identifiable {
        let id = UUID();
        let emoji: String;
        let name: String;
        let description: String;
    }
    private let emojiList: [EmojiItem] = [
        EmojiItem(
          emoji: "👾",
          name: "Alien Monster",
          description: "A friendly-looking, tentacled space creature with two eyes."),
        EmojiItem(
          emoji: "🥑",
          name: "Avocado",
          description: "A pear-shaped avocado, sliced in half to show its yellow-green flesh and "
            + "large brown pit."),
        EmojiItem(
          emoji: "🍟",
          name: "French Fries",
          description: "Thin-cut, golden-brown French fries, served in a red carton, as at "
            + "McDonald’s."),
        EmojiItem(
          emoji: "🍕",
          name: "Pizza",
          description: "A slice of pepperoni pizza, topped with black olives on Google. WhatsApp "
            + "adds green pepper, Samsung white onion."),
        EmojiItem(
          emoji: "🧩",
          name: "Puzzle Piece",
          description: "Puzzle Piece was approved as part of Unicode 11.0 in 2018 under the name "
            + "“Jigsaw Puzzle Piece” and added to Emoji 11.0 in 2018."),
        EmojiItem(
          emoji: "🚀",
          name: "Rocket",
          description: "A rocket being propelled into space."),
        EmojiItem(
          emoji: "🗽",
          name: "Statue of Liberty",
          description: "The Statue of Liberty, often used as a depiction of New York City."),
        EmojiItem(
          emoji: "🧸",
          name: "Teddy Bear",
          description: "A classic teddy bear, as snuggled by a child when going to sleep."),
        EmojiItem(
          emoji: "🦄",
          name: "Unicorn",
          description: "The face of a unicorn, a mythical creature in the form of a white horse with "
            + "a single, long horn on its forehead."),
        EmojiItem(
          emoji: "👩🏽‍💻",
          name: "Woman Technologist",
          description: "A woman behind a computer screen, working in the field of technology."),
        EmojiItem(
          emoji: "🗺",
          name: "World Map",
          description: "A rectangular map of the world. Generally depicted as a paper map creased at "
            + "its folds, Earth’s surface shown in green on blue ocean."),
      ]




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
                    
                    
                    
                    }

    //                Map(coordinateRegion: $region,annotationItems interactionModes: .all, showsUserLocation: true, userTrackingMode: nil)
                } else {
                    Text("Locating user location...")
                }
                
                
            }            .edgesIgnoringSafeArea(.all)


            .onAppear {
                setCurrentLocation()
                fetchData()
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
                            
                            
                            // going to apply shadows to look like neuromorphic feel...
                            
                            Image("gator")
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
                            
                            Text("Kanye West")
                                .font(.title)
                                .foregroundColor(Color.black.opacity(0.8))
                            
                            Text("kanyewest@ufl.edu")
                                .foregroundColor(Color.black.opacity(0.7))
                        }
                        .padding(.leading, 20)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Tab Items...
                    
                    HStack{
                        
                        Button(action: {
                            
                            self.index = 0
                            
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
                            
                            Image("passenger")
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
                            
                        }) {
                            
                            Text("Requests")
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
                    
                    List(annontations) {
                        
                        Point in ZStack {
                            Text("🚙")
                                .shadow(radius: 3)
                                .font(.largeTitle)
                                .frame(width: 75, height: 65)
                                .overlay(
                                    Circle().stroke(Color.green, lineWidth: 3))
                        }
                    Text(Point.name)
                        .font(.headline)
                    }.padding(7);
                }
                .background(Color("Color1").edgesIgnoringSafeArea(.all))

                
                
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
                        Text("Kanye West")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                            Button(action: {
                                self.showUserProfile.toggle();
                                self.showDetails.toggle()
                            }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                            }
                        
                        }
                        Text("Kanyewest@ufl.edu".uppercased())
                            .font(.caption)
                        
                        Text("Destination: \(current.name) \nStarted at: 6:30AM")
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
                self.selection = 2
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
                self.toPickScreen = true
                
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

        }
        .edgesIgnoringSafeArea(.all)
            NavigationLink(destination: PickScreen(), isActive: self.$toPickScreen){
            }.disabled(true)
            

    }
            .navigationBarTitle("", displayMode: .inline)
                 .navigationBarHidden(true)

    }
}
