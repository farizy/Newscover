//
//  ViewController.swift
//  Newscover
//
//  Created by CODE-MAC1 on 11/6/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getArticle()
        bindArticles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func bindArticles() {
        viewModel.articles
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self](articles) in
                self?.textLabel.text = articles.first?.title
                })
            .addDisposableTo(disposeBag)
        
        viewModel.errorObserver
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (errorMesage) in
                let alert = UIAlertController(title: nil, message: errorMesage, preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(noAction)
                self?.present(alert, animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
}

