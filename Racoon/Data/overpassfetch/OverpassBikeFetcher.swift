import Foundation

struct BicycleRepairStation: Codable {
    let id: Int
    let latitude: Double
    let longitude: Double
}

extension OverpassFetcher {
    static func fetchBicycleRepairStations(forCities cities: [String], completion: @escaping ([BicycleRepairStation]?) -> Void) {
        let group = DispatchGroup()
        var repairStations: [BicycleRepairStation] = []
        for city in cities {
            group.enter()
            fetchBicycleRepairStations(forCity: city) { stations in
                if let stations = stations {
                    repairStations.append(contentsOf: stations)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(repairStations)
        }
    }

    private static func fetchBicycleRepairStations(forCity city: String, completion: @escaping ([BicycleRepairStation]?) -> Void) {
        let query = """
        [out:json];
        (
          area["name:en"="\(city)"];
          area["name"="\(city)"];
        )->.searchArea;

        (
          nwr[amenity=bicycle_repair_station](area.searchArea);
        );
        out center;
        """

        guard let apiUrl = "https://overpass-api.de/api/interpreter?data=\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: apiUrl) else {
            completion(nil)
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received from the API.")
                completion(nil)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let elements = json?["elements"] as? [[String: Any]] else {
                    print("JSON response does not have the expected structure.")
                    completion(nil)
                    return
                }

                var repairStations: [BicycleRepairStation] = []
                for element in elements {
                    if let id = element["id"] as? Int,
                       let lat = element["lat"] as? Double,
                       let lon = element["lon"] as? Double {
                        let station = BicycleRepairStation(id: id, latitude: lat, longitude: lon)
                        repairStations.append(station)
                    }
                }

                completion(repairStations)
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
