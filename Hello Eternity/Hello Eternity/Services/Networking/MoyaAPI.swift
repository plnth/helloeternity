import Foundation
import Moya

final class MoyaAPI {
    
    enum Endpoint: TargetType {
        
        case fetchTodayPicture
        
        var baseURL: URL {
            return APIConstants.APOD.baseURL
        }
    
        var path: String {
            return ""
        }
    
        var method: Moya.Method {
            return .get
        }
    
        var sampleData: Data {
            return "Hello eternity".data(using: .utf8) ?? Data()
        }
    
        var task: Task {
            return .requestParameters(parameters: ["api_key" : "DEMO_KEY"], encoding: URLEncoding())
        }
    
        var headers: [String : String]? {
            return nil
        }
    }
}

