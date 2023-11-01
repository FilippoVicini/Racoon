
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
struct ProductCard: View {
    let product: String

    var body: some View {
        VStack {
            Text(product)
                .font(.title)
                .foregroundColor(.white)
        }
        .frame(width: 150, height: 150)
        .background(Color.blue)
        .cornerRadius(10)
    }
}


