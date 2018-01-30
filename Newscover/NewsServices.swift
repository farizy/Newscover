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
                case .success(let value):
                    guard let json = JSON(rawValue: value) else {
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
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    guard let json = JSON(rawValue: value) else {
                        completion(.failure(APIError.jsonConversionFailure))
                        return
                    }
                    
                    guard let sourcesJSON = json["sources"].array else{
                        completion(.failure(APIError.invalidData))
                        return
                    }
                    
                    let sources = sourcesJSON.flatMap({ Source(json: $0) })
                    completion(.success(sources))

                    break
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
        }
    }
    
}
