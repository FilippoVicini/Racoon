import SwiftUI
import MapKit

struct BikeRepairMapView: View {
    let username: String
    @Binding var region: MapRegion
    @StateObject var locationManager = LocationManager()
    @State private var mapSelection: MKMapItem?
    @State private var selectedBikeRepair: BicycleRepairStation?
    @State private var userTrackingMode: MKUserTrackingMode = .follow
    @State private var isPopupVisible = false
    @State private var isLoadingData = true
    @State private var currentCity: String?
    @State private var bikeRepairStations: [BicycleRepairStation] = []
    @State private var fetchedForCity: String?
    @State private var lastLocation: CLLocation?
    @State private var shouldContinueLocationUpdates = true
    
    func locationManagerDidChangeLocation(_ location: CLLocation) {
        region.center = location.coordinate
        lastLocation = location
        
        if !bikeRepairStations.isEmpty {
            fetchBikeRepairStations(for: location)
        }
        
        if shouldContinueLocationUpdates {
            locationManager.stopUpdatingLocation()
            shouldContinueLocationUpdates = false
        }
    }
    
    var body: some View {
        ZStack {
            BikeRepairMapRepresentable(
                region: $region,
                bikeRepairStations: $bikeRepairStations,
                mapSelection: $mapSelection,
                selectedBikeRepair: $selectedBikeRepair,
                userTrackingMode: $userTrackingMode,
                isPopupVisible: $isPopupVisible
            )
            
        }
        .onAppear {
            if shouldContinueLocationUpdates {
                locationManager.startUpdatingLocation()
            }
        }
        .onReceive(locationManager.$location) { location in
            if let location = location {
                fetchBikeRepairStations(for: location)
            }
        }
    }
    
    private func fetchBikeRepairStations(for location: CLLocation) {
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
                
                if fetchedForCity != city {
                    OverpassFetcher.fetchBicycleRepairStations(forCities: [city]) { fetchedStations in
                        if let fetchedStations = fetchedStations {
                            DispatchQueue.main.async {
                                bikeRepairStations = fetchedStations
                                fetchedForCity = city
                                print("Bike Repair Stations fetched: \(fetchedStations.count)")
                            }
                        } else {
                            print("Failed to fetch bike repair stations")
                        }
                    }
                }
            }
        }
    }
}
