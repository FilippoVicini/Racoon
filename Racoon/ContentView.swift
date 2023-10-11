import MapKit
import SwiftUI

struct ContentView: View {
    @State private var username = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @State private var waterFountains: [WaterFountain] = []
    @State private var isSidebarOpened = false
    @State private var mapRegion = MapRegion(
        center: CLLocationCoordinate2D(latitude: 53.0000, longitude: 9.0000), // Set an initial center coordinate
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Set an initial span
    )
    
    init() {
        // Fetch water fountain data when ContentView is created
        fetchWaterFountains()
    }

    var body: some View {
        if !isLoggedIn {
            LoginView(username: $username, isLoggedIn: $isLoggedIn)
        } else {
            ZStack(alignment: .topLeading) {
                Color.black.opacity(isSidebarOpened ? 0.5 : 0)
                    .onTapGesture {
                        isSidebarOpened = false
                    }
                    .ignoresSafeArea()

                MapView(region: $mapRegion, waterFountains: isSidebarOpened ? [] : waterFountains)
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
                        LeftButton(isLoggedIn: $isLoggedIn)
                    }
                }

                // Sidebar
                if isSidebarOpened {
                    SideBar(isLoggedIn: $isLoggedIn, menuClosed: $isSidebarOpened)
                        .frame(width: 300)  // Adjust the width as needed
                        .background(Color.white)  // Background color for the sidebar
                }

            }
            .onDisappear {
                // Save the username and isLoggedIn to UserDefaults when the ContentView disappears
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
            }
        }
    }


    // Function to fetch the latest water fountain data
    // Function to fetch the latest water fountain data
    private func fetchWaterFountains() {
        // Specify the list of cities for which you want to fetch water fountains
        let cities = ["Madrid", "London", "Milano", "Amsterdam", "Barcelona", "Roma"]
        
        // Call the fetchWaterFountains function with the list of cities
        OverpassFetcher.fetchWaterFountains(forCities: cities) { fetchedFountains in
            if let fetchedFountains = fetchedFountains {
                waterFountains = fetchedFountains
            }
        }
    }


    // Function to manually refresh the map data
    private func refreshMapData() {
        fetchWaterFountains()
    }
}
