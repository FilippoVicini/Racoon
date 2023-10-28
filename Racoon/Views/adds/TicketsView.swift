import SwiftUI
import RealmSwift

struct TicketsView: View {
    let product: String
    let username: String

    @ObservedResults(Fountain.self, sortDescriptor: SortDescriptor(keyPath: "status", ascending: false)) var tickets
    @Environment(\.realm) var realm

    @State private var title = ""
    @State private var description = ""

    @State private var isAddTicketViewPresented = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(tickets) { ticket in
                        TicketView(ticket: ticket)
                    }
                }
                .listStyle(InsetGroupedListStyle())

                VStack {
                    Button(action: {
                        isAddTicketViewPresented.toggle()
                    }) {
                        Text("Add Ticket")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationBarTitle("\(product) Tickets", displayMode: .inline)
            .onAppear(perform: setSubscriptions)
            .onDisappear(perform: clearSubscriptions)
        }
        .sheet(isPresented: $isAddTicketViewPresented) {
            AddTicketView(isPresented: $isAddTicketViewPresented, product: product, username: username)
        }
    }

    private func setSubscriptions() {
        let subscriptions = realm.subscriptions
        if subscriptions.first(named: product) == nil {
            subscriptions.update {
                subscriptions.append(QuerySubscription<Fountain>(name: product) { ticket in
                    ticket.product == product
                })
            }
        }
    }

    private func clearSubscriptions() {
        let subscriptions = realm.subscriptions
        subscriptions.update {
            subscriptions.remove(named: product)
        }
    }
}
