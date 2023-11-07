import SwiftUI
import CoreLocation
struct GooglePlacesResponse: Codable {
    let results: [GooglePlace]
}

struct GooglePlace: Codable {
    let name: String
    let formatted_address: String
}

struct AddTicketView: View {
    @Environment(\.realm) var realm
    @Binding var isPresented: Bool
    var product: String
    var username: String
    @State private var type = ""
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var searchResults: [GooglePlace] = []
    var types = ["Fountain", "Bathroom", "Spot", "Food"]
    @State private var selectedLocation: GooglePlace?
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Ticket description", text: $description)
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) { type in
                            Text(type)
                        }
                    }
                    HStack {
                        TextField("Location", text: $location,
                                  onEditingChanged: { isEditing in
                            if !isEditing {
                                updateSearchResults()
                            }
                        },
                                  onCommit: {
                            updateSearchResults()
                        })
                        Button(action: {
                            fetchUserLocation()
                            
                        }) {
                            Image(systemName: "location")
                            
                        }
                    }
                }
                Section {
                    List(searchResults, id: \.name) { place in
                        Button(action: {
                            selectedLocation = place
                            location = place.formatted_address
                        }) {
                            VStack(alignment: .leading) {
                                Text(place.formatted_address)
                                    .font(.caption)
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                }
                Section {
                    Button(action: addTicket) {
                        Text("Add \(product)")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue) // Change the color to your preferred one
                            )
                    }
                }
            }
            .navigationTitle("Add \(product)")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
        .onAppear {
            locationManager.startUpdatingLocation()
        }
    }
    
    private func addTicket() {
        let fountain = Fountain(reportedBy: username, product: product, type: type, title: title, problemDescription: description != "" ? description : nil, address: location)
        
        try? realm.write {
            realm.add(fountain)
        }
        
        title = ""
        description = ""
        location = ""
        isPresented = false
    }
    
    private func fetchUserLocation() {
        if let userLocation = locationManager.location {
            CLGeocoder().reverseGeocodeLocation(userLocation) { placemarks, error in
                if let placemark = placemarks?.first {
                    let address = "\(placemark.name ?? "") \(placemark.locality ?? "") \(placemark.country ?? "")"
                    location = address
                }
            }
        }
    }
    
    
    
    private func updateSearchResults() {
        let apiKey = "AIzaSyBkHjBHZET-HmJBH6mwpW1BsZCTG9FqmXc"
        
        guard let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(encodedLocation)&key=\(apiKey)"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let placesResponse = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
                        DispatchQueue.main.async {
                            searchResults = placesResponse.results
                        }
                        print(placesResponse)
                    } catch {
                        print("Error decoding Google Places API response: \(error)")
                    }
                }
            }.resume()
        }
    }
    
}

