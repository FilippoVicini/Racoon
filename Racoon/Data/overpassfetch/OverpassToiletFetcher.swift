import Foundation
import UIKit
import MapKit

struct Toilet: Codable {
    let id: Int
    let latitude: Double
    let longitude: Double
}
struct ToiletDetail: Codable {
    let name: String?
    let fee: String?
    let image: String?
    let openingHours: String?
}


extension OverpassToiletFetcher {
    static func showLoadingPopup(on viewController: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        viewController.present(alert, animated: true, completion: nil)
        return alert
    }
}

class OverpassToiletFetcher {
    static func fetchToilets(forCities cities: [String], completion: @escaping ([Toilet]?) -> Void) {
        let group = DispatchGroup()
        var toilets: [Toilet] = []
        for city in cities {
            group.enter()
            fetchToilets(forCity: city) { fetchedToilets in
                if let fetchedToilets = fetchedToilets {
                    toilets.append(contentsOf: fetchedToilets)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(toilets)
        }
    }

    private static func fetchToilets(forCity city: String, completion: @escaping ([Toilet]?) -> Void) {
        let query = """
        [out:json];
        (
          area["name:en"="\(city)"];
          area["name"="\(city)"];
        )->.searchArea;

        (
          nwr[amenity=toilets](area.searchArea);

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

                var toilets: [Toilet] = []
                for element in elements {
                    if let id = element["id"] as? Int,
                       let lat = element["lat"] as? Double,
                       let lon = element["lon"] as? Double {
                        let toilet = Toilet(id: id, latitude: lat, longitude: lon)
                        toilets.append(toilet)
                    }
                }

                completion(toilets)
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
