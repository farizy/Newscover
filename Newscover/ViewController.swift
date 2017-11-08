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
                    .subscribe(onNext: { [weak self](articles) in
                        self?.textLabel.text = articles.first?.title
                    },
                    onError: nil,
                    onCompleted: nil,
                    onDisposed: nil)
    }
}

