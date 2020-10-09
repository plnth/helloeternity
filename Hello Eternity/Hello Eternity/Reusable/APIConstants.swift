import Foundation

struct APIConstants {
    struct APOD {
        static let baseURL: URL = URL(string: "https://api.nasa.gov/planetary/apod") ?? URL(fileURLWithPath: "")
    }
}
