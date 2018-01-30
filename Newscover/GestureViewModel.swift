//
//  GestureViewModel.swift
//  Newscover
//
//  Created by Ahmad Farizy on 11/9/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import Foundation
import RxSwift

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

