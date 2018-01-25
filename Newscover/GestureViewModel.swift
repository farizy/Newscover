//
//  GestureViewModel.swift
//  Newscover
//
//  Created by Ahmad Farizy on 11/9/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import Foundation

import Foundation
import RxSwift
import RxAlamofire
import SwiftyJSON

class GestureViewModel {
    var articles: Variable<[Article]> = Variable<[Article]>([])

    var selectedSource: Source
        
    fileprivate let errorSubject = PublishSubject<String>()
    var errorObserver: Observable<String> {
        return errorSubject.asObserver()
    }
    
    let disposeBag = DisposeBag()
    
    init(source: Source) {
        self.selectedSource = source
    }
    func getArticle() {
        let baseURL = "https://newsapi.org/v1/articles"
        var param: [String : String] = [:]
        param["sortBy"] = "top"
        param["source"] = selectedSource.id
        param["apiKey"] = "b73643fbbd3e4c75851fb9d485af385c"
        RxAlamofire.json(.get, baseURL, parameters: param)
            .debug()
            .map { [weak self] (data) -> [Article] in
                let jsonArray = JSON(data)
                guard let articlesJSON = jsonArray["articles"].array else{
                    let errorMsg = jsonArray["message"].string ?? "JSON Parse Error"
                    self?.errorSubject.onNext(errorMsg)
                    return []
                }
                let articles = articlesJSON.flatMap({Article(json: $0)})
                
                return articles
            }
            .subscribe({ [weak self] (event) in
                switch event{
                case .next(let response):
                    self?.articles.value = response
                case .error(let error):
                    print(error)
                    self?.errorSubject.onNext(error.localizedDescription)
                default:
                    break
                }
            })
            .addDisposableTo(disposeBag)
    }
}

