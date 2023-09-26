import Foundation

struct WaterFountain {
    let id: Int
    let latitude: Double
    let longitude: Double
}

class OverpassFetcher {
    static func fetchWaterFountains(completion: @escaping ([WaterFountain]?) -> Void) {
        // Define the Overpass API query
        let query = """
        [out:json];
        (
          area["name"="London"]->.a;
          node["amenity"="drinking_water"](area.a);
        );
        out;
        """

        // Construct the Overpass API URL
        let apiUrl = "https://overpass-api.de/api/interpreter?data=\(query)"
        if let encodedUrl = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedUrl) {

            // Create an HTTP request
            let request = URLRequest(url: url)

            // Perform the request
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
                    // Attempt to parse the JSON response
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                    // Check if the JSON has the expected structure
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
    }

}

