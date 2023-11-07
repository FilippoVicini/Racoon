import SwiftUI
import MapKit

struct ToiletMapView: View {
    @Binding var region: MapRegion
    
    @StateObject var locationManager = LocationManager()
    @State private var mapSelection: MKMapItem?
    @State private var selectedToilet: Toilet?
    @State private var userTrackingMode: MKUserTrackingMode = .follow
    @State private var isPopupVisible = false
    @State private var isLoadingData = true
    @State private var loadingCities: [String] = []
    let username: String
    @State private var currentCity: String?
    @State private var toilets: [Toilet] = []
    @State private var fetchedForCity: String?
    @State private var lastLocation: CLLocation?
    @State private var shouldShowPopup = false
    @State private var shouldContinueLocationUpdates = true
    
    func locationManagerDidChangeLocation(_ location: CLLocation) {
        region.center = location.coordinate
        lastLocation = location
        
        if !toilets.isEmpty {
            fetchToilets(for: location)
        }
        
        if shouldContinueLocationUpdates {
            locationManager.stopUpdatingLocation()
            shouldContinueLocationUpdates = false
        }
    }
    
    var body: some View {
        ZStack {
            ToiletMapRepresentable(
                region: $region,
                toilets: $toilets,
                mapSelection: $mapSelection,
                selectedToilet: $selectedToilet,
                userTrackingMode: $userTrackingMode,
                isPopupVisible: $isPopupVisible
            )
            if isPopupVisible, let selectedToilet = selectedToilet {
                PopupView2(toilet: selectedToilet, isPopupVisible: $isPopupVisible)
                    .onTapGesture {
                        isPopupVisible = false
                        self.selectedToilet = nil
                    }
            }
            
        }
        .onAppear {
            if shouldContinueLocationUpdates {
                locationManager.startUpdatingLocation()
            }
        }
        .onReceive(locationManager.$location) { location in
            if let location = location {
                fetchToilets(for: location)
            }
        }
    }
    
    private func fetchToilets(for location: CLLocation) {
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
                    OverpassToiletFetcher.fetchToilets(forCities: [city]) { fetchedToilets in
                        if let fetchedToilets = fetchedToilets {
                            DispatchQueue.main.async {
                                toilets = fetchedToilets
                                fetchedForCity = city
                                print("Toilets fetched: \(fetchedToilets.count)")
                            }
                        } else {
                            print("Failed to fetch toilets")
                        }
                    }
                }
            }
        }
    }
}
