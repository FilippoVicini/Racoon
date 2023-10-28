
import SwiftUI
import RealmSwift

struct TicketView: View {
    @ObservedRealmObject var ticket: Fountain
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(ticket.title)
                .font(.headline) // Making the title larger
                .foregroundColor(Color.black)
            
            Text(ticket.address ?? "Location not identified")
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(ticket.problemDescription ?? "Item has no description")
                .font(.caption)
                .foregroundColor(.gray)
        }

        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            if ticket.status == .inProgress {
                Button(action: { $ticket.status.wrappedValue = .notStarted }) {
                    Label("Not Started", systemImage: "stop.circle.fill")
                }
                .tint(.red)
            }
            if ticket.status == .complete {
                Button(action: { $ticket.status.wrappedValue = .inProgress }) {
                    Label("In Progress", systemImage: "bolt.fill")
                }
                .tint(.yellow)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            if ticket.status == .inProgress {
                Button(action: { $ticket.status.wrappedValue = .complete }) {
                    Label("Complete", systemImage: "checkmark.rectangle")
                }
                .tint(.green)
            }
            if ticket.status == .notStarted {
                Button(action: { $ticket.status.wrappedValue = .inProgress }) {
                    Label("In Progress", systemImage: "bolt.fill")
                }
                .tint(.yellow)
            }
        }
    }
}

