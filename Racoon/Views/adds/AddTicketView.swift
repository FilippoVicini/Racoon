import SwiftUI

struct AddTicketView: View {
    @Environment(\.realm) var realm
    @Binding var isPresented: Bool
    var product: String
    var username: String

    @State private var title = ""
    @State private var description = ""
    @State private var location = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Ticket title", text: $title)
                    TextField("Ticket description", text: $description)
                    TextField("Location", text: $location)
                }

                Section {
                    Button(action: addTicket) {
                        Text("Add Ticket")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Add Ticket")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }

    private func addTicket() {
        let fountain = Fountain(reportedBy: username, product: product, title: title, problemDescription: description != "" ? description : nil)

        try? realm.write {
            realm.add(fountain)
        }

        title = ""
        description = ""
        location = ""
        isPresented = false
    }
}
