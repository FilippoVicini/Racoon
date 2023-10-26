//
//  TicketsView.swift
//  RTicket
//
//  Created by Andrew Morgan on 25/02/2022.
//

import SwiftUI
import RealmSwift

struct TicketsView: View {
    let product: String
    let username: String
    
    @ObservedResults(Fountain.self, sortDescriptor: SortDescriptor(keyPath: "status", ascending: false)) var tickets
    @Environment(\.realm) var realm
    
    @State private var title = ""
    @State private var description = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(tickets) { ticket in
                    TicketView(ticket: ticket)
                }
            }
            Spacer()
            VStack {
                TextField("Ticket title", text: $title)
                TextField("Ticket description", text: $description)
                Button(action: addTicket) {
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

    
    private func addTicket() {
        let fountain = Fountain(reportedBy: username, product: product, title: title, problemDescription: description != "" ? description : nil)
        
        try? realm.write {
            realm.add(fountain)
        }
        title = ""
        description = ""
    }
}

