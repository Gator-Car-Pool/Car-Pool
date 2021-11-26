import SwiftUI
import MapKit
import CoreLocation
import Firebase

struct FloatingTabBar: View {
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = false
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
    
    var tabs = ["map", "chat", "settings"]
    
    @State var selectedTab = "map"
    
    // Location of each curve
    @State var xAxis: CGFloat = 0
    @Namespace var animation
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $selectedTab) {
                MainView()
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("map")
                
                ChatView()
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("chat")
                
                
                SettingsView(darkModeEnabled: $darkModeEnabled,
                             systemThemeEnabled: $systemThemeEnabled)
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("settings")
                
      
            }    .onAppear {
                SystemThemeManager
                    .shared
                    .handleTheme(darkMode: darkModeEnabled, system: systemThemeEnabled)
            }
            
            
            // custom tab bar
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { image in
                    GeometryReader { reader in
                        Button(action: {
                            withAnimation {
                                selectedTab = image
                                xAxis = reader.frame(in: .global).minX
                            }
                        }, label: {
                            Image(image)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22.0, height: 22.0)
                                .foregroundColor(selectedTab == image ? .blue : .orange)
                                .padding(selectedTab == image ? 15 : 0)
                                .background(Color.white.opacity(selectedTab == image ? 1 : 0).clipShape(Circle()))
                                .matchedGeometryEffect(id: image, in: animation)
                                .offset(x: selectedTab == image ? -10 : 0, y: selectedTab == image ? -50 : 0)
                        })
                        .onAppear(perform: {
                            if image == tabs.first {
                                xAxis = reader.frame(in: .global).minX
                            }
                        })
                    }
                    .frame(width: 25.0, height: 30.0)
                    if image != tabs.last { Spacer() }
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical)
            .background(Color.white.clipShape(CustomShape(xAxis: xAxis)).cornerRadius(12.0))
            .padding(.horizontal)
            
            // Bottom edge....
            .padding(.bottom , UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        
        }
      
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct FloatingTabBar_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTabBar()
    }
}

struct CustomShape: Shape {
    
    var xAxis: CGFloat
    
    // Animate Path
    var animatableData: CGFloat {
        get { return xAxis }
        set { xAxis = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let center = xAxis
            
            path.move(to: CGPoint(x: center - 50, y: 0))
            
            let to1 = CGPoint(x: center, y: 35)
            let control1 = CGPoint(x: center - 25, y: 0)
            let control2 = CGPoint(x: center - 25, y: 35)
            
            let to2 = CGPoint(x: center + 50, y: 0)
            let control3 = CGPoint(x: center + 25, y: 35)
            let control4 = CGPoint(x: center + 25, y: 0)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}
