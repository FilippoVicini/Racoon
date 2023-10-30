import SwiftUI
import RealmSwift
import MapKit
import CoreLocation

struct TicketView: View {
    @ObservedRealmObject var ticket: Fountain
    @State private var coordinate: CLLocationCoordinate2D?
    
    
    
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
    }
    
}
