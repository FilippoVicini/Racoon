//
//  ProductsView.swift
//  RTicket
//
//  Created by Andrew Morgan on 25/02/2022.
//

import SwiftUI

struct ProductsView: View {
    let username: String
    let products = ["Fountains", "Bathrooms", "Food", "Spots"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(products, id: \.self) { product in
                    NavigationLink(destination: TicketsView(product: product, username: username)
                        .environment(\.realmConfiguration, realmApp.currentUser!.flexibleSyncConfiguration())) {
                            Text(product)
                        }
                }
            }
            
            .navigationBarTitle("Amenities", displayMode: .inline)
            
        }
    }
}

