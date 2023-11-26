import SwiftUI
import MapKit
import CoreLocation
import Combine


extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        return lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}
struct MapRegion: Equatable {
    var center: CLLocationCoordinate2D
    var span: MKCoordinateSpan
    
    static func == (lhs: MapRegion, rhs: MapRegion) -> Bool {
        return lhs.center == rhs.center && lhs.span == rhs.span
    }
}

struct MapView: View {
    @Binding var region: MapRegion
    @StateObject var locationManager = LocationManager()
    @State private var mapSelection: MKMapItem?
    @State private var selectedFountain: WaterFountain?
    @State private var userTrackingMode: MKUserTrackingMode = .follow
    @State private var isPopupVisible = false
    @State private var isLoadingData = true
    @State private var loadingCities: [String] = []
    let products = ["Fountains", "Bathrooms", "Food", "Spots"]
    let username: String
    @State private var currentCity: String?
    @State private var waterFountains: [WaterFountain] = []
    @State private var fetchedForCity: String?
    @State private var lastLocation: CLLocation?
    @State private var shouldShowPopup = false
    @State private var shouldContinueLocationUpdates = true
    @State private var userLocationCity: String?

    func locationManagerDidChangeLocation(_ location: CLLocation) {
        region.center = location.coordinate
        lastLocation = location

        if !waterFountains.isEmpty {
            fetchWaterFountains(for: location)
            updateLocationCity(for: location)
        }

        if shouldContinueLocationUpdates {
            locationManager.stopUpdatingLocation()
            shouldContinueLocationUpdates = false
        }
    }

    var body: some View {
        ZStack {
            MapRepresentable(
                region: $region,
                waterFountains: $waterFountains,
                mapSelection: $mapSelection,
                selectedFountain: $selectedFountain,
                userTrackingMode: $userTrackingMode,
                isPopupVisible: $isPopupVisible
            )

            if isPopupVisible, let selectedFountain = selectedFountain {
                PopupView(fountain: selectedFountain, isPopupVisible: $isPopupVisible)
                    .onTapGesture {
                        isPopupVisible = false
                        self.selectedFountain = nil
                    }
            }


            VStack {
                Button(action: {
                    shouldShowPopup = true
                }) {
                    Text("Fetching in: \(currentCity ?? "Unknown City")")
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .foregroundColor(Color.main)
                        .padding()
                        .offset(y: 28)
                }
                .sheet(isPresented: $shouldShowPopup) {
                    CityChangePopupView(
                        currentCity: $currentCity,
                        shouldShowPopup: $shouldShowPopup,
                        waterFountains: $waterFountains
                    )
                }

                Spacer()
            }
            
        }
        .onAppear {
            if shouldContinueLocationUpdates {
                locationManager.startUpdatingLocation()
            }
        }
        .onReceive(locationManager.$location) { location in
            if let location = location {
                fetchWaterFountains(for: location)
                updateLocationCity(for: location)
            }
        }
    }

    private func fetchWaterFountains(for location: CLLocation) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                isLoadingData = false
                return
            }

            if let city = placemarks?.first?.locality {
                let localizedCityName = Locale.current.localizedString(forRegionCode: city) ?? city
                currentCity = localizedCityName

                if fetchedForCity != city {
                    OverpassFetcher.fetchWaterFountains(forCities: [city]) { fetchedFountains in
                        if let fetchedFountains = fetchedFountains {
                            DispatchQueue.main.async {
                                waterFountains = fetchedFountains
                                fetchedForCity = city
                                print("Fountains fetched for \(currentCity ?? ""): \(fetchedFountains.count)")
                            }
                        } else {
                            print("Failed to fetch water fountains")
                        }
                    }
                }
            }
        }
    }

    private func updateLocationCity(for location: CLLocation) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }

            if let city = placemarks?.first?.locality {
                let localizedCityName = Locale.current.localizedString(forRegionCode: city) ?? city
                userLocationCity = localizedCityName
            }
        }
    }
}

struct CityChangePopupView: View {
    @Binding var currentCity: String?
    @Binding var shouldShowPopup: Bool
    @Binding var waterFountains: [WaterFountain]
    @State private var newCity: String = ""
    @State private var isLoading = false
    @State private var lastFetchedCity: String?
    @State private var fetchedCities: [String] = []
    private var fetchWaterFountainsSubject = PassthroughSubject<String, Never>()

    init(currentCity: Binding<String?>, shouldShowPopup: Binding<Bool>, waterFountains: Binding<[WaterFountain]>) {
        _currentCity = currentCity
        _shouldShowPopup = shouldShowPopup
        _waterFountains = waterFountains
    }

    var body: some View {
        VStack {
            TextField("Enter new city", text: $newCity)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Display the last fetched city
            if let lastCity = lastFetchedCity {
                Text("Last Fetched City: \(lastCity)")
                    .font(.headline)
                    .padding(.top, 8)
            }

            // Display the fetching cities
            if !fetchedCities.isEmpty {
                Text("Fetching data for:")
                    .font(.headline)
                    .padding(.top, 8)

                ScrollView {
                    ForEach(fetchedCities, id: \.self) { city in
                        Text(city)
                            .padding(4)
                    }
                }
                .frame(height: 100)
            }

            HStack {
                Button("Change City") {
                    fetchWaterFountainsSubject.send(newCity)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.main)
                .cornerRadius(8)
                .disabled(newCity.isEmpty || isLoading)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding()
        .onReceive(fetchWaterFountainsSubject) { newCity in
            isLoading = true

            fetchedCities.append(newCity)

            OverpassFetcher.fetchWaterFountains(forCities: [newCity]) { fetchedFountains in
                if let fetchedFountains = fetchedFountains, !fetchedFountains.isEmpty {
                    DispatchQueue.main.async {
                        waterFountains = fetchedFountains
                        currentCity = newCity
                        lastFetchedCity = newCity
                        fetchedCities = []  // Reset fetched cities
                        shouldShowPopup = false
                        isLoading = false
                    }
                } else {
                    print("Failed to fetch water fountains")
                    if let index = fetchedCities.firstIndex(of: newCity) {
                        fetchedCities.remove(at: index)
                    }

                    isLoading = false
                }
            }
        }
    }
}
