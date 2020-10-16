import Foundation
import Moya

final class MoyaAPI {
    
    enum Endpoint: TargetType {
        
        case mediaFromURL(MediaFromURLRequest)
        case apodForDate(ApodForDateRequest)
        
        var baseURL: URL {
            switch self {
            case .apodForDate:
                return APIConstants.Apod.basePlanetaryURL
            case .mediaFromURL:
                return APIConstants.Apod.baseImageURL
            }
        }
    
        var path: String {
            switch self {
            case .apodForDate:
                return ""
            case .mediaFromURL(let request):
                return request.path
            }
        }
    
        var method: Moya.Method {
            return .get
        }
    
        var sampleData: Data {
            return "Hello eternity".data(using: .utf8) ?? Data()
        }
    
        var task: Task {
            switch self {
            case .apodForDate(let request):
                guard let date = request.date else {
                    //TODO: temporary stub until video handling is introduced
                    return .requestParameters(parameters: ["api_key" : "DEMO_KEY"], encoding: URLEncoding())
                }
                return .requestParameters(parameters: ["api_key" : "DEMO_KEY", "date" : date], encoding: URLEncoding())
            case .mediaFromURL:
                return .requestPlain
            }
        }
    
        var headers: [String : String]? {
            return nil
        }
    }
}

