import SwiftUI
import MapKit
import CoreLocation
import Combine

struct ToiletMapView: View {
    let username: String
    @Binding var region: MapRegion
    @StateObject var locationManager = LocationManager()
    @State private var userLocationCity: String?
    @State private var mapSelection: MKMapItem?
    @State private var selectedToilet: Toilet?
    @State private var userTrackingMode: MKUserTrackingMode = .follow
    @State private var isPopupVisible = false
    @State private var isLoadingData = true
    @State private var currentCity: String?
    @State private var toilets: [Toilet] = []
    @State private var fetchedForCity: String?
    @State private var lastLocation: CLLocation?
    @State private var shouldShowPopup = false
    @State private var shouldContinueLocationUpdates = true

    func locationManagerDidChangeLocation(_ location: CLLocation) {
        region.center = location.coordinate
        lastLocation = location

        if !toilets.isEmpty {
            fetchToilets(for: location)
            fetchUserCity(for: location)
        }

        if shouldContinueLocationUpdates {
            locationManager.stopUpdatingLocation()
            shouldContinueLocationUpdates = false
        }
    }

    var body: some View {
        ZStack {
            ToiletMapRepresentable(
                region: $region,
                toilets: $toilets,
                mapSelection: $mapSelection,
                selectedToilet: $selectedToilet,
                userTrackingMode: $userTrackingMode,
                isPopupVisible: $isPopupVisible
            )

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
                    CityChangePopupViewToilet(
                        currentCity: $currentCity,
                        shouldShowPopup: $shouldShowPopup,
                        toilets: $toilets
                    )
                }

                Spacer()
            }

            if isPopupVisible, let selectedToilet = selectedToilet {
                PopupView2(toilet: selectedToilet, isPopupVisible: $isPopupVisible)
                    .onTapGesture {
                        isPopupVisible = false
                        self.selectedToilet = nil
                    }
            }
        }
        .onAppear {
            if shouldContinueLocationUpdates {
                locationManager.startUpdatingLocation()
            }
        }
        .onReceive(locationManager.$location) { location in
            if let location = location {
                fetchToilets(for: location)
                fetchUserCity(for: location)
            }
        }
    }

    private func fetchToilets(for location: CLLocation) {
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
                    OverpassToiletFetcher.fetchToilets(forCities: [city]) { fetchedToilets in
                        if let fetchedToilets = fetchedToilets {
                            DispatchQueue.main.async {
                                toilets = fetchedToilets
                                fetchedForCity = city
                                print("Toilets fetched for \(currentCity ?? ""): \(fetchedToilets.count)")
                            }
                        } else {
                            print("Failed to fetch toilets")
                        }
                    }
                }
            }
        }
    }

    private func fetchUserCity(for location: CLLocation) {
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

struct CityChangePopupViewToilet: View {
    @Binding var currentCity: String?
    @Binding var shouldShowPopup: Bool
    @Binding var toilets: [Toilet]
    @State private var newCity: String = ""
    @State private var isLoading = false
    @State private var lastFetchedCity: String?
    @State private var fetchedCities: [String] = []
    private var fetchToiletsSubject = PassthroughSubject<String, Never>()

    init(currentCity: Binding<String?>, shouldShowPopup: Binding<Bool>, toilets: Binding<[Toilet]>) {
        _currentCity = currentCity
        _shouldShowPopup = shouldShowPopup
        _toilets = toilets
    }

    var body: some View {
        VStack {
            TextField("Enter new city", text: $newCity)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

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
                .frame(height: 50)
            }

            HStack {
                Button("Change City") {
                    fetchToiletsSubject.send(newCity)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.main) // Adjust the color as needed
                .cornerRadius(8)
                .disabled(newCity.isEmpty || isLoading)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding()
        .onReceive(fetchToiletsSubject) { newCity in
            isLoading = true

            fetchedCities.append(newCity)

            OverpassToiletFetcher.fetchToilets(forCities: [newCity]) { fetchedToilets in
                if let fetchedToilets = fetchedToilets, !fetchedToilets.isEmpty {
                    DispatchQueue.main.async {
                        toilets = fetchedToilets
                        currentCity = newCity
                        lastFetchedCity = newCity

                        shouldShowPopup = false
                        isLoading = false
                    }
                } else {
                    print("Failed to fetch toilets")
                    if let index = fetchedCities.firstIndex(of: newCity) {
                        fetchedCities.remove(at: index)
                    }

                    isLoading = false
                }
            }
        }
    }
}
