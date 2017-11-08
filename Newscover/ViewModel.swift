//
//  ViewModel.swift
//  Newscover
//
//  Created by Ahmad Farizy on 11/8/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import SwiftyJSON

class ViewModel {
    let url = "https://newsapi.org/v1/articles?source=bbc-sport&sortBy=top&apiKey=b73643fbbd3e4c75851fb9d485af385c"
    var articles: Variable<[Article]> = Variable<[Article]>([])
    let disposeBag = DisposeBag()
    
    func getArticle() {
        RxAlamofire.json(.get, url)
            .map { (data) -> [Article] in
                let jsonArray = JSON(data)
                let articlesJSON = jsonArray["articles"].arrayValue
                let articles = articlesJSON.flatMap({Article(json: $0)})
                
                return articles
            }
            .subscribe(
                onNext: { (articles) in
                    self.articles.value = articles
            }, onError: { (error) in
                print(error)
            }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
    }
}
