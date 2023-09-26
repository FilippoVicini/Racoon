import Foundation

// MARK: - Welcome
struct Water: Codable {
    let version: Double
    let generator: String
    let osm3S: Osm3S
    let elements: [Element]

    enum CodingKeys: String, CodingKey {
        case version, generator
        case osm3S = "osm3s"
        case elements
    }
    static let allWaters: [Water] = Bundle.main.decode(file: "example.json", as: [Water].self)
     static let sampleWater: Water = allWaters[0]
}

// MARK: - Element
struct Element: Codable {
    let type: TypeEnum
    let id: Int
    let lat, lon: Double
    let tags: [String: String]
}

enum TypeEnum: String, Codable {
    case node = "node"
}

// MARK: - Osm3S
struct Osm3S: Codable {
    let timestampOsmBase: Date
    let copyright: String

    enum CodingKeys: String, CodingKey {
        case timestampOsmBase = "timestamp_osm_base"
        case copyright
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode the timestampOsmBase as a string
        let timestampString = try container.decode(String.self, forKey: .timestampOsmBase)

        // Create a DateFormatter and specify the date format used in your JSON
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'" // Adjust the format as needed

        // Try to convert the timestampString to a Date
        if let date = dateFormatter.date(from: timestampString) {
            timestampOsmBase = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .timestampOsmBase, in: container, debugDescription: "Date string is not in the expected format")
        }

        // Decode other properties as usual
        copyright = try container.decode(String.self, forKey: .copyright)
    }
}



// Extension to decode JSON locally
extension Bundle {
    func decode<T: Decodable>(file: String, as type: T.Type) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        do {
            let loadedData = try decoder.decode(T.self, from: data)
            return loadedData
        } catch {
            fatalError("Could not decode \(file) from bundle. Error: \(error)")
        }
    }
}
