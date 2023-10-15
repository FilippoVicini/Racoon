import SwiftUI
import MapKit
import CoreLocation
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

// Custom Equatable struct for representing the map region
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


    @State private var waterFountains: [WaterFountain] = [] {
        didSet {
            isLoadingData = false
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

            if isLoadingData {
                LoadingPopup()
            }

            if isPopupVisible, let selectedFountain = selectedFountain {
                PopupView(fountain: selectedFountain, isPopupVisible: $isPopupVisible)
                    .onTapGesture {
                        isPopupVisible = false
                        self.selectedFountain = nil
                    }
            }
            
        }
        .onAppear {
            fetchWaterFountains(for: region)
        }
    }

    private func fetchWaterFountains(for region: MapRegion) {
        guard isLoadingData else { return }
        // Specify the list of cities for which you want to fetch water fountains
        let cities = ["London", "Milano", "Amsterdam", "Rome"]

        // Call the fetchWaterFountains function with the list of cities
        OverpassFetcher.fetchWaterFountains(forCities: cities) { fetchedFountains in
            if let fetchedFountains = fetchedFountains {
                waterFountains = fetchedFountains
            }
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
