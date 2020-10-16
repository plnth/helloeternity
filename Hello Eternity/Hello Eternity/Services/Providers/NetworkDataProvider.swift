import Foundation
import Moya

class NetworkDataProvider {
    
    private let provider = MoyaProvider<MoyaAPI.Endpoint>()
    
    func performApodMediaRequest(fromURL url: String, completion: @escaping ((Result<Data, MoyaError>) -> Void)) {
        self.provider.request(.mediaFromURL(MediaFromURLRequest(path: url))) { result in
            let convertedResult = result.mapError { error in
                return MoyaError.underlying(error, nil)
            }
            .flatMap { image in
                return .success(image.data)
            }
            completion(convertedResult)
        }
    }
    
    func performApodDataRequest(forDate date: String? = nil, completion: @escaping (Result<ApodDataFromAPI, MoyaError>) -> Void) {
        self.provider.request(.apodForDate(ApodForDateRequest(date: date))) { result in
            let convertedResult = result.mapError { error in
                return MoyaError.underlying(error, nil)
            }
            .flatMap { response -> Result<ApodDataFromAPI, MoyaError> in
                guard let json = try? JSONSerialization.jsonObject(with: response.data, options: []),
                      let jsonDictionary = json as? [String: String] else {
                    return .failure(MoyaError.jsonMapping(response))
                }

                let apodData = ApodDataFromAPI(
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
}
