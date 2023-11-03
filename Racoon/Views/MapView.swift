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
    
    let products = ["Fountains", "Bathrooms", "Food", "Spots"]
    let username: String
    @State private var currentCity: String?
    @State private var waterFountains: [WaterFountain] = []
    @State private var fetchedForCity: String?
    @State private var lastLocation: CLLocation?
    @State private var shouldShowPopup = false

    // Add a state variable to track whether location updates should continue
    @State private var shouldContinueLocationUpdates = true
    
    func locationManagerDidChangeLocation(_ location: CLLocation) {
        region.center = location.coordinate
        lastLocation = location
        
        // Check if data has not been fetched yet
        if !waterFountains.isEmpty {
            fetchWaterFountains(for: location)
        }
        
        // Check if location updates should continue
        if shouldContinueLocationUpdates {
            locationManager.stopUpdatingLocation()
            shouldContinueLocationUpdates = false
        }
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
               // Start updating location if it's not already started
               if shouldContinueLocationUpdates {
                   locationManager.startUpdatingLocation()
               }
           }
           .onReceive(locationManager.$location) { location in
               if let location = location {
                   fetchWaterFountains(for: location)
               }
           }
       }
            private func fetchWaterFountains(for location: CLLocation) {
                let geocoder = CLGeocoder()
                
                geocoder.reverseGeocodeLocation(location) { placemarks, error in
                    if let error = error {
                        print("Reverse geocoding error: \(error.localizedDescription)")
                        isLoadingData = false
                        return
                    }
                    
                    if let city = placemarks?.first?.locality {
                        let localizedCityName = Locale.current.localizedString(forRegionCode: city) ?? city
                        currentCity = localizedCityName
                        
                        // Check if water fountains are already fetched for this city
                        if fetchedForCity != city {
                            OverpassFetcher.fetchWaterFountains(forCities: [city]) { fetchedFountains in
                                if let fetchedFountains = fetchedFountains {
                                    DispatchQueue.main.async {
                                        waterFountains = fetchedFountains
                                        fetchedForCity = city
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
        }

