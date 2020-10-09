import Foundation
import Moya

class NetworkDataProvider {
    
    private let provider = MoyaProvider<MoyaAPI.Endpoint>()
    
    func performTodayPictureRequest(completion: @escaping ((APODData?, Error?) -> Void)) {
        self.provider.request(.fetchTodayPicture) { result in
            switch result {
            case .success(let data):
                do {
                    if let mappedJSON = try data.mapJSON() as? [String : String] {
                        let apodData = mappedJSON.map { json -> APODData in
                            
                            return APODData(date: mappedJSON["date"] ?? "",
                                            explanation: mappedJSON["explanation"] ?? "",
                                            hdurl: mappedJSON["hdurl"] ?? "",
                                            title: mappedJSON["title"] ?? "",
                                            url: mappedJSON["url"] ?? "")
                        }.first
                        completion(apodData, nil)
                    }
                    
                } catch {
                    debugPrint(error)
                    completion(nil, error)
                }
            case .failure(let error):
                debugPrint(error)
                completion(nil, error)
            }
        }
        
    }
}
