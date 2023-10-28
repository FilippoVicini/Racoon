import SwiftUI
import MapKit

struct ContentView: View {
    @State private var username = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @State private var waterFountains: [WaterFountain] = []
    @State private var isSidebarOpened = false
    @State private var isLoadingData = false
    @State private var email = ""
    @State private var isInfoPopupVisible = false
    @State private var mapRegion = MapRegion(
        center: CLLocationCoordinate2D(latitude: 53.0000, longitude: 9.0000),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    
    var body: some View {
        NavigationView {
            if !isLoggedIn {
                AuthView(username: $username, isLoggedIn: $isLoggedIn)
            } else {
                ZStack(alignment: .topLeading) {
                    Color.black.opacity(isSidebarOpened ? 0.5 : 0)
                        .onTapGesture {
                            isSidebarOpened = false
                        }
                        .ignoresSafeArea()
                    
                    MapView(region: $mapRegion)
                        .opacity(isSidebarOpened ? 0.5 : 1.0)
                        .ignoresSafeArea()
                    VStack {
                        HStack {
                            ActionButton(menuOpened: $isSidebarOpened)
                                .padding(.horizontal, 9)
                                .padding(.top, 4)
                        }
                        Spacer()
                        
                        HStack {
                            UserButton()
                                .opacity(isSidebarOpened ? 0.5 : 1.0)
                            LeftButton(isLoggedIn: $isLoggedIn)
                                .opacity(isSidebarOpened ? 0.5 : 1.0)
                        }
                    }
                    
                    // Sidebar
                    if isSidebarOpened {
                        SideBar(isLoggedIn: $isLoggedIn, menuClosed: $isSidebarOpened)
                            .frame(width: 300)
                            .background(Color.white)
                    }
                    if isInfoPopupVisible {
                        InfoPopup()
                            .background(Color.black.opacity(0.5))
                            .onTapGesture {
                                isInfoPopupVisible = false
                            }
                            .transition(.opacity)
                    }
                }
                
                
                .onAppear {
                    
                    isInfoPopupVisible = true
                }
                .onDisappear {
                    // Save the username and isLoggedIn to UserDefaults when the ContentView disappears
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
                }
            }
        }
    }
}
