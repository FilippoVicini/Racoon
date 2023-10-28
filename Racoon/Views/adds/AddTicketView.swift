import SwiftUI

struct GooglePlacesResponse: Codable {
    let results: [GooglePlace]
}

struct GooglePlace: Codable {
    let name: String
    let formatted_address: String
    // Add other properties you want to extract from the API response.
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
    @State private var searchResults: [GooglePlace] = [] // Update the data model to GooglePlace
    var types = ["Bug", "Feature Request", "Other"]

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
                    TextField("Location", text: $location)
                        .onChange(of: location, perform: { newLocation in
                            // Call the searchForLocation function when the location text changes
                            updateSearchResults()
                        })

                }

                Section {
                    Button(action: addTicket) {
                        Text("Add Ticket")
                    }
                    .buttonStyle(.borderedProminent)
                }

                Section {
                    List(searchResults, id: \.name) { place in
                        Text(place.name)
                        Text(place.formatted_address)
                    }
                }
            }
            .navigationTitle("Add Ticket")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
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

    private func updateSearchResults() {
        let apiKey = "AIzaSyBkHjBHZET-HmJBH6mwpW1BsZCTG9FqmXc" // Replace with your actual Google API key

        guard let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }

        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(encodedLocation)&key=\(apiKey)"

        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let placesResponse = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
                        // Update the searchResults property with the results from the Google Places API
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
