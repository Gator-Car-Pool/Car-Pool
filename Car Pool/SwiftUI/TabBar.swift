import SwiftUI
import MapKit
import CoreLocation
import Firebase

class Bar: ObservableObject {

    /* PROTOCOL PROPERTIES */
    var showBar = true;

}

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
    @State var display = true
    @EnvironmentObject var bar : Bar;
    @StateObject var showBar = Bar()

    var tabs = ["map", "message", "settings"]
    
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
                MainView(display: self.$display)
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("map")
                    .environmentObject(showBar)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
                
                ChatList()
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("message")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
                
                SettingsView(darkModeEnabled: $darkModeEnabled,
                             systemThemeEnabled: $systemThemeEnabled)
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("settings")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
      
            }    .onAppear {
                SystemThemeManager
                    .shared
                    .handleTheme(darkMode: darkModeEnabled, system: systemThemeEnabled)
            }
            
            
            // custom tab bar
            if display {
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { image in
                    GeometryReader { reader in
                        Button(action: {
                            withAnimation {
                                selectedTab = image
                            }
                        }, label: {
                            Image(image)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22.0, height: 22.0)
                                .foregroundColor(selectedTab == image ? .blue : .orange)
                                .padding(selectedTab == image ? 0 : 0)
                                .background(Color(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)).opacity(selectedTab == image ? 0 : 0))
                                .offset(x: selectedTab == image ? 0 : 0, y: selectedTab == image ? 0 : 0)
                        })
                        .onAppear(perform: {
                            if image == tabs.first {
                            }
                        })
                    }
                    .frame(width: 25.0, height: 30.0)
                    if image != tabs.last { Spacer() }
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical)
            .background(Color(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)).cornerRadius(12.0))
            .padding(.horizontal)
            
            // Bottom edge....
            .padding(.bottom , UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        }
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}
