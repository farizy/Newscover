//
//  NewsEndPoint.swift
//  Newscover
//
//  Created by CODE-MAC1 on 11/13/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import Foundation
import Alamofire

enum NewsEndPoint: URLRequestConvertible {
    
    case articles(source: String, sortBy: String?)//sort by, source id
    case sources(language: String?, category: String?)//language + category

    static let baseURLString = "https://newsapi.org/v1"

    var apiKey: String {
        return "b73643fbbd3e4c75851fb9d485af385c"
    }

    var method: HTTPMethod {
        switch self {
        case .articles(_, _):
            return .get
        case .sources(_, _):
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .articles(let source, let sort):
            params["apiKey"] = self.apiKey
            params["source"] = source
            if let sort = sort{
                params["sortBy"] = sort
            }
            
            return params
        case .sources(let language, let category):
            params["apiKey"] = self.apiKey
            if let lang = language{
                params["language"] = lang
            }
            if let category = category{
                params["category"] = category
            }
            
            return params
        }
    }

    var path: String {
        switch self {
        case .articles(source: _, sortBy: _):
            return "articles"
        case .sources(language: _, category: _):
            return "sources"
        }
    }
    
    
    var encoding: ParameterEncoding {
        switch method{
        case .post:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try NewsEndPoint.baseURLString.asURL()
        
        let relativeURL = url.appendingPathComponent(path)
        var urlRequest = URLRequest(url: relativeURL)
        urlRequest.httpMethod = method.rawValue
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}
