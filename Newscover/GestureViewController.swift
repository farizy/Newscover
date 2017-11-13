//
//  GestureViewController.swift
//  Newscover
//
//  Created by Ahmad Farizy on 11/9/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import UIKit
import RxSwift

class GestureViewController: UIViewController {
    @IBOutlet weak var gestureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    
    let viewModel = GestureViewModel()
    let disposeBag = DisposeBag()
    
    let book = [#imageLiteral(resourceName: "norwegianwood"), #imageLiteral(resourceName: "norwegianwood2"), #imageLiteral(resourceName: "running"), #imageLiteral(resourceName: "windupbird"), #imageLiteral(resourceName: "windupbird2") ]
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
        viewModel.getArticle()
        configureViewModelObserver()
        loadingActivityIndicatorView.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGesture() {
        gestureImageView.isUserInteractionEnabled = true
        //        gestureImageView.image = book[index]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
        gestureImageView.addGestureRecognizer(tap)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeImage(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        gestureImageView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeImage(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        gestureImageView.addGestureRecognizer(swipeDown)
    }
    
    func configureViewModelObserver(){
        viewModel.articles
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self](articles) in
                //    self?.textLabel.text = articles.first?.title
                self?.loadingActivityIndicatorView.stopAnimating()
                guard let first = articles.first else { return }
                self?.setArticle(article: first)
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
    
    func setArticle(article: Article)  {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        gestureImageView.af_setImage(withURL: article.urlToImage)
    }
    
    func tapImage(_ sender: UIGestureRecognizer) {
        let widthArea = self.view.bounds.width / 3
        let xTap = sender.location(in: gestureImageView).x
        if xTap < widthArea{
            index -= 1
        }else{
            index += 1
        }
        
        if index < 0 { index = 0 }
//        if index > book.count-1 { index = book.count-1}
//        gestureImageView.image = book[index]
        if index > viewModel.articles.value.count-1 { index = viewModel.articles.value.count-1}
        let article = viewModel.articles.value[index]
        self.setArticle(article: article)
    }
    
    func swipeImage(_ gesture: UIGestureRecognizer) {
        
        guard let gesture = gesture as? UISwipeGestureRecognizer else { return }
        
        if gesture.direction == UISwipeGestureRecognizerDirection.up {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewControllerID") as? DetailViewController else { return }
            let article = viewModel.articles.value[index]
            vc.url = article.url
            self.present(vc, animated: true, completion: nil)
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            print("Swipe Down")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
