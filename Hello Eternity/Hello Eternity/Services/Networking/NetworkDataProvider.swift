import Foundation
import Moya

class NetworkDataProvider {
    
    private let provider = MoyaProvider<MoyaAPI.Endpoint>()
    
    func performTodayPictureInfoRequest(completion: @escaping ((APODData?, Error?) -> Void)) {
        self.provider.request(.fetchTodayPictureInfo) { result in
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
    
    func performTodayPictureFromURLRequest(pictureURL: String, completion: @escaping ((Data?, Error?) -> Void)) {
        self.provider.request(.fetchTodayPictureFromURL(PictureFromURLRequest(path: pictureURL))) { result in
            switch result {
            case .success(let imageData):
                completion(imageData.data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
