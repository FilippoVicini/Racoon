import SwiftUI
import RealmSwift
import MapKit
import CoreLocation

struct TicketView: View {
    @ObservedRealmObject var ticket: Fountain
    @State private var coordinate: CLLocationCoordinate2D?
    @State private var ticketMarkers: [TicketMarker] = [] // Initialize the array

    
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
        .onAppear {
            geocodeAddress()
        }
    }

    func geocodeAddress() {
        let geocoder = CLGeocoder()
        if let address = ticket.address {
            geocoder.geocodeAddressString(address) { placemarks, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Geocoding error: \(error)")
                        coordinate = nil
                    } else if let placemarks = placemarks {
                        // Iterate through all placemarks and add a marker for each one
                        for placemark in placemarks {
                            if let location = placemark.location?.coordinate {
                                coordinate = location
                                let marker = TicketMarker(
                                    coordinate: location,
                                    title: ticket.title,
                                    subtitle: ticket.problemDescription ?? "No description"
                                )
                                ticketMarkers.append(marker)
                            }
                        }
                    } else {
                        coordinate = nil
                    }
                    
                    // Print the ticketMarkers array to the console
                    print("Ticket Markers:")
                    for marker in ticketMarkers {
                        print("Title: \(marker.title), Subtitle: \(marker.subtitle), \(marker.coordinate)")
                    }
                }
            }
        }
    }

}

struct TicketMarker {
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

class Geocoder: ObservableObject {
    @Published var ticketMarkers: [TicketMarker] = []

    func geocodeAddress(_ address: String, title: String, description: String? = nil) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Geocoding error: \(error)")
                } else if let placemarks = placemarks {
                    for placemark in placemarks {
                        if let location = placemark.location?.coordinate {
                            let marker = TicketMarker(
                                coordinate: location,
                                title: title,
                                subtitle: description ?? "No description"
                            )
                            self.ticketMarkers.append(marker)
                        }
                    }
                }
            }
        }
    }
}
