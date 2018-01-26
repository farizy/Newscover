//
//  APIServices.swift
//  Newscover
//
//  Created by Ahmad Farizy on 11/6/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import Alamofire
//import RxSwift
//import RxAlamofire
import SwiftyJSON

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}


class NewsServices {
//    public static let shared = NewsServices()
    
    func getSources(language: String? = "en", category: String? = nil,
                           completion: @escaping (Result<[Source], APIError>) -> Void) {

        let lang = language ?? "en"
        Alamofire.request(NewsEndPoint.sources(language: lang, category: category))
            .responseJSON { (response) in
                if let error = response.error{
                    print(error.localizedDescription)
                    completion(.failure(APIError.requestFailed))
                    return
                }
                
                guard response.response?.statusCode == 200 else {
                    completion(.failure(APIError.responseUnsuccessful))
                    return
                }
                
                guard let value = response.result.value,
                    let json = JSON(value) as? JSON,
                    let sourceJSON = json["sources"].array
                else{
                    completion(.failure(APIError.invalidData))
                    return
                }
                let sources = sourceJSON.flatMap({ Source(json: $0) })

                completion(.success(sources))
                
//                if let value = response.result.value,
//                    let json = JSON(value) as? JSON,
//                    let sourceJSON = json["sources"].array {
//
//                    let sources = sourceJSON.flatMap({ Source(json: $0) })
//
//                    completion(.success(sources))
//                }else{
//                    completion(.failure(APIError.jsonParsingFailure))
//                }
        }
    }
    
}
