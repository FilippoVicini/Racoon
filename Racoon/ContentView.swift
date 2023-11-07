import SwiftUI
import MapKit
import RealmSwift

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
    @State private var isMapView = true // To toggle between MapView and ToiletMapView

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
                    
                    if isMapView {
                        MapView(region: $mapRegion, username: username)
                            .opacity(isSidebarOpened ? 0.5 : 1.0)
                            .ignoresSafeArea()
                    } else {
                        ToiletMapView(region: $mapRegion, username: username)
                            .opacity(isSidebarOpened ? 0.5 : 1.0)
                            .ignoresSafeArea()
                    }
                    
                    VStack {
                        HStack {
                            Spacer()
                            
                            ActionButton(menuOpened: $isSidebarOpened)
                                .padding(.horizontal, 9)
                            
                        }
                      
                        
                        Button(action: {
                            // Toggle between MapView and ToiletMapView
                            isMapView.toggle()
                        }) {
                            Text(isMapView ? "Fountains" : "Toilets")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.top, 4)
                        
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
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
                }
            }
        }
    }
}
