//
//  ViewController.swift
//  Newscover
//
//  Created by CODE-MAC1 on 11/6/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getArticle()
        bindArticles()
        setupCellTapHandling()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindArticles() {
        
        viewModel.articles
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)){
                row, article, cell in
                cell.textLabel?.text = article.title
            }
//            .subscribe(onNext: { [weak self](articles) in
//                self?.textLabel.text = articles.first?.title
//                })
            .addDisposableTo(disposeBag)

        viewModel.errorObserver
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (errorMesage) in
                let alert = UIAlertController(title: nil, message: errorMesage, preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(noAction)
                self?.present(alert, animated: true, completion: nil)

                self?.textLabel.isHidden = false
            })
            .addDisposableTo(disposeBag)
    }
    
    func setupCellTapHandling() {
        tableView
            .rx
            .modelSelected(Article.self)
            .subscribe({ [weak self] (article) in
                guard let article = article.element else { return }
                let alert = UIAlertController(title: article.title, message: article.description, preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(noAction)
                self?.present(alert, animated: true, completion: nil)
                
                if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow{
                    self?.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
            })
        .addDisposableTo(disposeBag)
    }
}
