import Foundation

struct APIConstants {
    struct Apod {
        static let basePlanetaryURL: URL = URL(string: "https://api.nasa.gov/planetary/apod") ?? URL(fileURLWithPath: "")
        static let baseImageURL: URL = URL(string: "https://apod.nasa.gov/apod/image/") ?? URL(fileURLWithPath: "")
    }
}
