//
//  APIServices.swift
//  Newscover
//
//  Created by Ahmad Farizy on 11/6/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum Result<T> {
    case success(T)
    case failure(Error)
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
    
    func getArticles(source: String, sortBy: String? = nil,
                     completion: @escaping(Result<[Article]>) -> Void) {
        Alamofire.request(NewsEndPoint.articles(source: source, sortBy: sortBy))
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    guard let json = JSON(response.result.value) as? JSON,
                        json.isEmpty == false
                    else {
                        completion(.failure(APIError.jsonConversionFailure))
                        return
                    }
                    
                    guard let articleJSON = json["articles"].array else {
                        completion(.failure(APIError.invalidData))
                        return
                    }
                    let article = articleJSON.flatMap({ Article(json: $0) })
                    completion(.success(article))

                    break
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
        }
    }
    
    func getSources(language: String? = "en", category: String? = nil,
                    completion: @escaping (Result<[Source]>) -> Void) {

        Alamofire.request(NewsEndPoint.sources(language: language, category: category))
            .responseJSON { (response) in
                if let error = response.error{
                    completion(.failure(error))
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
        }
    }
    
}
