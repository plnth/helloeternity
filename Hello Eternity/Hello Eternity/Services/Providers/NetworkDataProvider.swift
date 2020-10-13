import Foundation
import Moya

class NetworkDataProvider {
    
    private let provider = MoyaProvider<MoyaAPI.Endpoint>()

    func performTodayPictureInfoRequest(completion: @escaping ((Result<APODDataFromAPI, MoyaError>) -> Void)) {
        
        self.provider.request(.fetchTodayPictureInfo) { result in
            
            let convertedResult = result.mapError { error in
                return MoyaError.underlying(error, nil)
            }
            
            .flatMap { response -> Result<APODDataFromAPI, MoyaError> in
                guard let json = try? JSONSerialization.jsonObject(with: response.data, options: []),
                      let jsonDictionary = json as? [String: String] else {
                    return .failure(MoyaError.jsonMapping(response))
                }
                
                let apodData = APODDataFromAPI(
                    date: jsonDictionary["date"] ?? "",
                    explanation: jsonDictionary["explanation"] ?? "",
                    hdurl: jsonDictionary["hdurl"] ?? "",
                    title: jsonDictionary["title"] ?? "",
                    url: jsonDictionary["url"] ?? "")
                
                return .success(apodData)
            }
            
            completion(convertedResult)
        }
    }
    
    func performTodayPictureFromURLRequest(pictureURL: String, completion: @escaping ((Result<Data, MoyaError>) -> Void)) {
        self.provider.request(.fetchTodayPictureFromURL(PictureFromURLRequest(path: pictureURL))) { result in
            let convertedResult = result.mapError { error in
                return MoyaError.underlying(error, nil)
            }
            .flatMap { image in
                return .success(image.data)
            }
            completion(convertedResult)
        }
    }
}
