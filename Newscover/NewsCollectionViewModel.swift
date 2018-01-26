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
    var sources: Variable<[Source]> = Variable<[Source]>([])
    
    fileprivate let errorSubject = PublishSubject<String>()
    var errorObserver: Observable<String> {
        return errorSubject.asObserver()
    }
    let disposeBag = DisposeBag()
        
    func getSource() {
        /*
        RxAlamofire.requestJSON(NewsEndPoint.sources(language: "en", category: nil))
            .debug()
            .map { [weak self] (response, data) -> [Source] in
                let json = JSON(data)
                guard let sourcesJSON = json["sources"].array else{
                    let errorMsg = json["message"].string ?? "JSON Parse Error"
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
         */
        let services = NewsServices()
        services.getSources { (result) in
            switch result{
            case .success(let sources):
                self.sources.value = sources
            case .failure(let error):
                self.errorSubject.onNext(error.localizedDescription)
            }
        }
    }
}
