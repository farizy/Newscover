//
//  APIServices.swift
//  Newscover
//
//  Created by Ahmad Farizy on 11/6/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import Alamofire
import RxSwift
import RxAlamofire

enum Result<T, E: Error> {
    case success(payload: T)
    case failure(E?)
}

class APIServices {
    public static let shared = APIServices()
    
//    // MARK: - GetFriends
//    enum GetFriendsFailureReason: Int, Error {
//        case unAuthorized = 401
//        case notFound = 404
//    }
//
//    typealias GetFriendsResult = Result<[Friend], GetFriendsFailureReason>
//    typealias GetFriendsCompletion = (_ result: GetFriendsResult) -> Void
//
//    func getFriends(completion: @escaping GetFriendsCompletion) {
    enum GetArticleFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    
    typealias GetArticlesResult = Result<[Article], GetArticleFailureReason>
    typealias GetArticlesCompletion = (_ result: GetArticlesResult) -> Void
    
    func getArticles(completion: @escaping GetArticlesCompletion) {
        //hardcoded
        let param = ["source" : "bbc-sport",
                     "sortBy" : "top",
                     "apiKey" : "b73643fbbd3e4c75851fb9d485af385c"]
        
//        Alamofire.request("https://newsapi.org/v1/articles",
//                          method: HTTPMethod.get,
//                          encoding: .default,
//                          headers: nil)
//            .validate()
    }
    
    func getArticles() -> Observable<[Article]> {
        let url = "https://newsapi.org/v1/articles"
        return RxAlamofire.requestJSON(.get, url)
            .debug()
            .map { (response, json) -> [Article] in
                let articles:[Article] = []
                
                return articles
            }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
