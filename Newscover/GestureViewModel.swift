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
        /*RxAlamofire.requestJSON(NewsEndPoint.articles(source: selectedSource.id, sortBy: nil))
            .debug()
            .map { [weak self] (response, data) -> [Article] in
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
         */
        let services = NewsServices()
        services.getArticles(source: selectedSource.id) { (result) in
            switch result{
            case .success(let articles):
                self.articles.value = articles
            case .failure(let error):
                print(error.localizedDescription)
                self.errorSubject.onNext(error.localizedDescription)
            }
        }
    }
}

