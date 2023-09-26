import SwiftUI
import MapKit
struct ContentView: View {
    @State private var waterFountains: [WaterFountain] = []
    @State private var showLocationSearch = false
    @State private var isSidebarOpened = false
    @State private var isFilterBannerVisible = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background with lower opacity covering the entire screen
            Color.black.opacity(isSidebarOpened || isFilterBannerVisible ? 0.5 : 0)
                .onTapGesture {
                    isSidebarOpened = false // Close the sidebar on tap
                    isFilterBannerVisible = false // Hide the filter banner on tap
                }
                .ignoresSafeArea()
            
            MapView(waterFountains: waterFountains)
                
                .opacity(isSidebarOpened || isFilterBannerVisible ? 0.5 : 1.0) // Apply opacity to the content
            
            
            VStack {
                HStack {
                    // ActionButton with a sidebar toggle
                    ActionButton(menuOpened: $isSidebarOpened)
                        .padding(.horizontal, 9)
                        .padding(.top, 4)
                    
                }
                
                Spacer()
                
                HStack {
                    UserButton()
                    LeftButton()
                }
            }
            
            // Sidebar
            if isSidebarOpened {
                SideBar()
                    .frame(width: 300) // Adjust the width as needed
                    .background(Color.white) // Background color for the sidebar
            }
            
            // Filter Banner
            
        }
        .onAppear {
            // Fetch water fountain data when the ContentView appears
            OverpassFetcher.fetchWaterFountains { fetchedFountains in
                if let fetchedFountains = fetchedFountains {
                    waterFountains = fetchedFountains
                }
            }
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
