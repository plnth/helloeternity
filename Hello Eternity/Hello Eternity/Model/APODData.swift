import UIKit

struct APODDataFromAPI: Decodable {
    let date: String
    let explanation: String
    let hdurl: String
    let title: String
    let url: String
}
