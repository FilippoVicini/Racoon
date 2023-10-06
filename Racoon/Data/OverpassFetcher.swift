import Foundation

struct WaterFountain {
    let id: Int
    let latitude: Double
    let longitude: Double
}

class OverpassFetcher {
    private static var cachedWaterFountains: [String: (data: [WaterFountain], timestamp: Date)] = [:]
    private static let cacheTTL: TimeInterval = 3600 // Cache data for 1 hour

    static func fetchWaterFountains(forCities cities: [String], completion: @escaping ([WaterFountain]?) -> Void) {
        let group = DispatchGroup()
        var waterFountains: [WaterFountain] = []

        for city in cities {
            // Check if data is cached and not expired
            if let cachedData = cachedWaterFountains[city], isCacheValid(cachedData) {
                waterFountains.append(contentsOf: cachedData.data)
                continue
            }

            group.enter()
            fetchWaterFountains(forCity: city) { fountains in
                if let fountains = fountains {
                    waterFountains.append(contentsOf: fountains)
                    // Cache the fetched data with a timestamp
                    cachedWaterFountains[city] = (data: fountains, timestamp: Date())
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(waterFountains)
        }
    }

    private static func fetchWaterFountains(forCity city: String, completion: @escaping ([WaterFountain]?) -> Void) {
        let query = """
        [out:json];
        area["name"="\(city)"]->.\(city);
        node["amenity"="drinking_water"](area.\(city));
        out;
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

                var waterFountains: [WaterFountain] = []
                for element in elements {
                    if let id = element["id"] as? Int,
                        let lat = element["lat"] as? Double,
                        let lon = element["lon"] as? Double {
                        let waterFountain = WaterFountain(id: id, latitude: lat, longitude: lon)
                        waterFountains.append(waterFountain)
                    }
                }

                completion(waterFountains)
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }

    private static func isCacheValid(_ cachedData: (data: [WaterFountain], timestamp: Date)) -> Bool {
        // Check if cached data is not expired
        return Date().timeIntervalSince(cachedData.timestamp) < cacheTTL
    }
}
