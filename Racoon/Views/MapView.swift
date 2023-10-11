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
    @State var waterFountains: [WaterFountain] = []
    @ObservedObject var locationManager = LocationManager()
    @State private var mapSelection: MKMapItem?
    @State private var selectedFountain: WaterFountain?
    @State private var userTrackingMode: MKUserTrackingMode = .follow
    @State private var isPopupVisible = false
    var body: some View {
        ZStack {
                MapRepresentable(region: $region, waterFountains: $waterFountains, mapSelection: $mapSelection, selectedFountain: $selectedFountain, userTrackingMode: $userTrackingMode, isPopupVisible: $isPopupVisible)

                if isPopupVisible && selectedFountain != nil {
                    PopupView(fountain: selectedFountain!, isPopupVisible: $isPopupVisible)
                        .background(Color.black.opacity(0.5))
                        .onTapGesture {
                            isPopupVisible = false
                            selectedFountain = nil
                        }
                }
            }
            .onAppear {
                fetchWaterFountains(for: region)
            }
            .onChange(of: region) { newRegion in
                fetchWaterFountains(for: newRegion)
            }
        }

        private func handleAnnotationSelection(_ fountain: WaterFountain) {
            selectedFountain = fountain
            isPopupVisible = true
        }

    private func fetchWaterFountains(for region: MapRegion) {
        // Specify the list of cities for which you want to fetch water fountains
        let cities = ["Madrid", "London", "Milano", "Amsterdam", "Barcelona", "Rome", "Budapest", "Berlin", "Copenhagen", "Istanbul", "Vienna", "Firenze", "Lisbon", "Naples", "Lyon", "Paris"]

        // Call the fetchWaterFountains function with the list of cities
        OverpassFetcher.fetchWaterFountains(forCities: cities) { fetchedFountains in
            if let fetchedFountains = fetchedFountains {
                // Update the waterFountains array on the main thread
                DispatchQueue.main.async {
                    self.waterFountains = fetchedFountains
                }
            }
        }

}
   }
