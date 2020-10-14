import Foundation
import Moya

final class MoyaAPI {
    
    enum Endpoint: TargetType {
        
        case fetchTodayPictureInfo
        case fetchTodayPictureFromURL(PictureFromURLRequest)
        
        var baseURL: URL {
            switch self {
            case .fetchTodayPictureInfo:
                return APIConstants.APOD.basePlanetaryURL
            case .fetchTodayPictureFromURL:
                return APIConstants.APOD.baseImageURL
            }
        }
    
        var path: String {
            switch self {
            case .fetchTodayPictureInfo:
                return ""
            case .fetchTodayPictureFromURL(let request):
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
            case .fetchTodayPictureInfo:
                //TODO: temporary stub until video handling is introduced
                return .requestParameters(parameters: ["api_key" : "DEMO_KEY", "date": "2020-09-20"], encoding: URLEncoding())
            case .fetchTodayPictureFromURL:
                return .requestPlain
            }
        }
    
        var headers: [String : String]? {
            return nil
        }
    }
}

