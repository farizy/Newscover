//
//  NewsCollectionViewModel.swift
//  Newscover
//
//  Created by CODE-MAC1 on 11/9/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import Foundation
import RxSwift

class NewsCollectionViewModel{    
    var sources: Variable<[Source]> = Variable<[Source]>([])
    
    var selectedCategory: Category?
    
    fileprivate let errorSubject = PublishSubject<String>()
    var errorObserver: Observable<String> {
        return errorSubject.asObserver()
    }
    let disposeBag = DisposeBag()
    
    init(category: Category? = nil) {
        self.selectedCategory = category
    }
        
    func getSource() {
        let services = NewsServices()
        services.getSources(category: self.selectedCategory?.rawValue) { (result) in
            switch result{
            case .success(let sources):
                self.sources.value = sources
            case .failure(let error):
                self.errorSubject.onNext(error.localizedDescription)
            }
        }
    }
}
