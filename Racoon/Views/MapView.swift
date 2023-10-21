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

// Custom Equatable extension for MKCoordinateSpan
extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        return lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}

struct MapRegion: Equatable {
    var center: CLLocationCoordinate2D
    var span: MKCoordinateSpan

    static func == (lhs: MapRegion, rhs: MapRegion) -> Bool {
        return lhs.center == rhs.center && lhs.span == rhs.span
    }
}


struct MapView: View {
    @Binding var region: MapRegion
    @StateObject var locationManager = LocationManager()
    @State private var mapSelection: MKMapItem?
    @State private var selectedFountain: WaterFountain?
    @State private var userTrackingMode: MKUserTrackingMode = .follow
    @State private var isPopupVisible = false
    @State private var isLoadingData = true
    @State private var loadingCities: [String] = []
    
    @State private var waterFountains: [WaterFountain] = []
    @State private var fetchedForCity: String? // Track the city for which data has been fetched
    
    @State private var lastLocation: CLLocation? // Store the most recent location
    
    func locationManagerDidChangeLocation(_ location: CLLocation) {
        // Update the map region with the new location
        region.center = location.coordinate
        lastLocation = location // Store the most recent location
    }
    func getIndex(for fountain: WaterFountain) -> Int {
        if let index = waterFountains.firstIndex(where: { $0.id == fountain.id }) {
            return index
        }
        return 0
    }

    var body: some View {
        NavigationView {
            VStack {
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
                                // Smoothly animate back to user's location
                                if let location = lastLocation {
                                    withAnimation(Animation.easeInOut(duration: 1.0)) { // Adjust the duration for your desired speed
                                        region.center = location.coordinate
                                    }
                                }
                            }
                    }
                }
                
                // Display the list of water fountains
                List {
                    ForEach(waterFountains, id: \.id) { fountain in
                        NavigationLink(destination: FountainDetailView(fountain: $waterFountains[getIndex(for: fountain)])) {
                            Text(fountain.name ?? "No Name")
                        }
                    }
                }
            }
            
            .onAppear {
                locationManager.startUpdatingLocation()
                
                if let location = lastLocation, fetchedForCity == nil {
                    fetchWaterFountains(for: location)
                }
            }
            .onReceive(locationManager.$location) { location in
                if let location = location, fetchedForCity == nil {
                    fetchWaterFountains(for: location)
                }
            }
        }
    }
    private func fetchWaterFountains(for location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                isLoadingData = false // Mark loading as complete even on error
                return
            }
            
            if let city = placemarks?.first?.locality, fetchedForCity != city {
                fetchedForCity = city // Mark data as fetched for this city
                
                OverpassFetcher.fetchWaterFountains(forCities: [city]) { fetchedFountains in
                    if let fetchedFountains = fetchedFountains {
                        DispatchQueue.main.async {
                            waterFountains = fetchedFountains
                            print("Fountains fetched: \(fetchedFountains.count)")
                        }
                    } else {
                        print("Failed to fetch water fountains")
                    }
                }
            }
        }
    }
}


struct FountainDetailView: View {
    @Binding var fountain: WaterFountain
    @State private var name: String = ""
    @State private var review: String = ""
    @State private var description: String = ""

    var body: some View {
        VStack {
            Text("Fountain Details")

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Review", text: $review)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Description", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Save") {
                // Update the fountain with the entered data
                fountain.name = name
                fountain.reviews.append(review)
                fountain.description = description
            }
        }
    }
}
