import SwiftUI
import RealmSwift
import MapKit
import CoreLocation

struct TicketView: View {
    @ObservedRealmObject var ticket: Fountain
    @State private var coordinate: CLLocationCoordinate2D?
    @State private var showingSheet = false // Control whether the sheet is shown

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(ticket.title)
                .font(.headline)
                .foregroundColor(Color.black)

            Text(ticket.address ?? "Location not identified")
                .font(.caption)
                .foregroundColor(.gray)

            Text(ticket.problemDescription ?? "Item has no description")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .onTapGesture {
            // When the user taps on the view, initiate geocoding and show the sheet
            geocodeAddress()
            showingSheet = true
        }
        .sheet(isPresented: $showingSheet) {
            // This is the sheet content, showing the coordinates and map
            if let coordinate = coordinate {
                VStack {
                    Text("Latitude: \(coordinate.latitude)")
                    Text("Longitude: \(coordinate.longitude)")

                    DisableInteractionMapView(
                        coordinate: coordinate,
                        zoomEnabled: false, // Disable zooming
                        scrollEnabled: false // Disable scrolling
                    )
                    .frame(height: 500)
                    .overlay(
                        ZStack {
                            Image(systemName: "drop.fill")
                                .resizable()
                                .frame(width: 20, height: 30)
                                .foregroundColor(.blue)
                        }
                    )
                    Text(ticket.address ?? "Location not identified")
                }
            } else {
                Text("Coordinates not available")
            }
        }
    }

    private func geocodeAddress() {
        guard let address = ticket.address else { return }

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemark = placemarks?.first, let location = placemark.location {
                coordinate = location.coordinate

                // Print the coordinates to the console
                print("Latitude: \(coordinate?.latitude ?? 0.0)")
                print("Longitude: \(coordinate?.longitude ?? 0.0)")
            }
        }
    }
}

struct DisableInteractionMapView: UIViewRepresentable {
    let coordinate: CLLocationCoordinate2D
    let zoomEnabled: Bool
    let scrollEnabled: Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
        mapView.isZoomEnabled = zoomEnabled
        mapView.isScrollEnabled = scrollEnabled
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the view if needed
    }


    class TicketAnnotation: NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        
        init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
        }
    }

}
