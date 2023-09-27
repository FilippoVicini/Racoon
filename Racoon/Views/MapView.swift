import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    let waterFountains: [WaterFountain]

    @State var region = MKCoordinateRegion()
    @ObservedObject var locationManager = LocationManager()
    @State private var mapSelection: MKMapItem?
    @State private var selectedFountain: WaterFountain?  // Track the selected fountain

    var body: some View {
        Map(selection: $mapSelection) {
            ForEach(waterFountains, id: \.id) { fountain in
                Annotation("fountain", coordinate: CLLocationCoordinate2D(latitude: fountain.latitude, longitude: fountain.longitude)) {
                    // Display a custom view for the marker
                    MarkerView(fountain: fountain)
                        .onTapGesture {
                            // Set the selected fountain when the marker is tapped
                            selectedFountain = fountain
                        }
                }
            }
            UserAnnotation()
        }
        .mapStyle(.standard)
        .mapControls {
            MapUserLocationButton()
        }
        .overlay(
            // Display a custom popup when a marker is selected
            PopupView(selectedFountain: $selectedFountain)
        )
    }
}

struct MarkerView: View {
    let fountain: WaterFountain

    var body: some View {
        Image(systemName: "drop.fill")
            .foregroundColor(.blue)
    }
}

struct PopupView: View {
    @Binding var selectedFountain: WaterFountain?

    var body: some View {
        if let fountain = selectedFountain {
            ZStack {
                Color.white.opacity(0.8)
                    .frame(width: 200, height: 150) // Increased height to accommodate the button
                
                VStack {
                    Text("Water Fountain")
                        .font(.headline)
                    Text("Latitude: \(fountain.latitude)")
                    Text("Longitude: \(fountain.longitude)")
                    Button("Close") {
                        // Close the popup
                        selectedFountain = nil
                    }
                    Button("Navigate") {
                        // Open the location in Apple Maps for navigation
                        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: fountain.latitude, longitude: fountain.longitude))
                        let mapItem = MKMapItem(placemark: placemark)
                        mapItem.name = "Destination"
                        mapItem.openInMaps(launchOptions: nil)
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
        }
    }
}
