import SwiftUI
import MapKit
import CoreLocation
import Combine

// Custom Equatable extension for CLLocationCoordinate2D
extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

// Define a custom MapMarker struct to hold information about each marker.
struct MapMarker: Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
    // Add more properties as needed, e.g., title, description, etc.
}

struct MapRegion: Equatable {
    var center: CLLocationCoordinate2D
    var span: MKCoordinateSpan

    static func == (lhs: MapRegion, rhs: MapRegion) -> Bool {
        return lhs.center == rhs.center && lhs.span == rhs.span
    }
}

// Custom Equatable extension for MKCoordinateSpan
extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        return lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}

// Your LocationManager class (if not already defined)

// Your OverpassFetcher class (if not already defined)

struct MapView: View {
    @Binding var region: MapRegion
    @StateObject var locationManager = LocationManager()
    @State private var mapSelection: MKMapItem?
    @State private var selectedFountain: WaterFountain?
    @State private var userTrackingMode: MKUserTrackingMode = .none
    @State private var isPopupVisible = false
    @State private var previousRegion: MapRegion?
    @State private var loadingCities: [String] = []
    
    @State private var markers: [MapMarker] = []
    private let maxMarkersToDisplay = 500
    @State private var waterFountains: [WaterFountain] = []
    
    // Use an initializer for MapView
    init(region: Binding<MapRegion>, waterFountains: [WaterFountain]) {
        _region = region
        _waterFountains = State(initialValue: waterFountains)
    }
    
    var body: some View {
        ZStack {
            MapRepresentable(
                region: $region,
                waterFountains: $waterFountains,
                mapSelection: $mapSelection,
                selectedFountain: $selectedFountain,
                userTrackingMode: $userTrackingMode,
                isPopupVisible: $isPopupVisible
            )
            
            if isPopupVisible, let selectedFountain = selectedFountain {
                PopupView(fountain: selectedFountain, isPopupVisible: $isPopupVisible)
                    .onTapGesture {
                        isPopupVisible = false
                        self.selectedFountain = nil
                    }
            }
        }
        .onAppear {
            fetchWaterFountains(for: $region)
        }
        .onReceive(Just(region)) { newRegion in
            if let previousRegion = previousRegion {
                // Calculate the distance between the new and previous regions
                let distanceMoved = CLLocation(
                    latitude: previousRegion.center.latitude,
                    longitude: previousRegion.center.longitude
                ).distance(from: CLLocation(
                    latitude: newRegion.center.latitude,
                    longitude: newRegion.center.longitude
                ))
                
                // Set a threshold for redrawing markers (e.g., 5 km)
                let redrawThreshold: Double = 50000 // meters
                if distanceMoved >= redrawThreshold {
                    // Update the previous region and redraw markers
                    self.previousRegion = newRegion
                    updateMarkers()
                }
            } else {
                // If it's the first region, initialize the previousRegion
                self.previousRegion = newRegion
            }
        }
    }
    
    private func fetchWaterFountains(for region: Binding<MapRegion>) {
        // Replace this with your actual data fetching code
        // For this example, we'll use dummy data.
        waterFountains = createDummyData()
    }
    
    private func createDummyData() -> [WaterFountain] {
        var dummyData: [WaterFountain] = []
        
        for _ in 0..<maxMarkersToDisplay {
            let fountain = WaterFountain(
                id: 1, latitude: Double.random(in: 51.4...51.6),
                longitude: Double.random(in: -0.2...0.2)
            )
            dummyData.append(fountain)
        }
        
        return dummyData
    }
    
    private func updateMarkers() {
        // Limit the number of markers to display
        markers = Array(waterFountains.prefix(maxMarkersToDisplay)).map { fountain in
            MapMarker(id: UUID(), coordinate: CLLocationCoordinate2D(latitude: fountain.latitude, longitude: fountain.longitude))
        }
    }

}

struct LoadingPopup: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            VStack {
                ProgressView("Loading Data")
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Color.black)
                    .cornerRadius(10)
            }
        }
    }
}
