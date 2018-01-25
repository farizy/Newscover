//
//  NewsCollectionViewModel.swift
//  Newscover
//
//  Created by CODE-MAC1 on 11/9/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import RxSwift
import RxAlamofire
import SwiftyJSON
import Foundation
import Alamofire

class NewsCollectionViewModel{
    
//    var articles: Variable<[Article]> = Variable<[Article]>([])
    var sources: Variable<[Source]> = Variable<[Source]>([])
    var source: Source?
    
    fileprivate let errorSubject = PublishSubject<String>()
    var errorObserver: Observable<String> {
        return errorSubject.asObserver()
    }
    let disposeBag = DisposeBag()
        
    func getSource() {
        let url = "https://newsapi.org/v1/sources?language=en" //&category=sport
        
        RxAlamofire.json(.get, url)
            .debug()
            .map { [weak self] (data) -> [Source] in
                let jsonArray = JSON(data)
                guard let sourcesJSON = jsonArray["sources"].array else{
                    let errorMsg = jsonArray["message"].string ?? "JSON Parse Error"
                    self?.errorSubject.onNext(errorMsg)
                    return []
                }
                let sources = sourcesJSON.flatMap({Source(json: $0)})
                
                return sources
            }
            
            .subscribe({ [weak self] (event) in
                switch event{
                case .next(let response):
                    self?.sources.value = response
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
