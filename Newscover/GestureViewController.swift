//
//  GestureViewController.swift
//  Newscover
//
//  Created by Ahmad Farizy on 11/9/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView
import WebKit

class GestureViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var gestureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var dissmissViewButton: UIButton!
    @IBOutlet weak var webViewContainer: UIView!
    var contentWebView: WKWebView = WKWebView()

    let progressView = CGSize(width: 50, height: 50)
    var viewModel: GestureViewModel?
    let disposeBag = DisposeBag()
    
    let book = [#imageLiteral(resourceName: "norwegianwood"), #imageLiteral(resourceName: "norwegianwood2"), #imageLiteral(resourceName: "running"), #imageLiteral(resourceName: "windupbird"), #imageLiteral(resourceName: "windupbird2") ]
    var index: Int = 0
//    
//    init(viewModel: GestureViewModel) {
//        self.viewModel = viewModel
//
//        super.init(nibName: nil, bundle: nil)
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addGesture()
        guard let viewModel = viewModel else{
            return
        }
        viewModel.getArticle()
        configureViewModelObserver()
    
        startAnimating(progressView, message: "\(viewModel.selectedSource.name)", type: .ballClipRotateMultiple, color: UIColor.white, backgroundColor: UIColor.clear, textColor: UIColor.white)
        //loadingActivityIndicatorView.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        let height = self.view.frame.height
        topViewConstraint.constant = height
        self.view.layoutIfNeeded()
        
        dissmissViewButton.addTarget(self, action: #selector(dissmissView(_:)), for: .touchUpInside)
        
        webViewContainer.clipsToBounds = true
        
        contentWebView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        contentWebView.translatesAutoresizingMaskIntoConstraints = false
        contentWebView.scrollView.layer.masksToBounds = false
        
        webViewContainer.addSubview(contentWebView)
        
        let constraints = [
            contentWebView.topAnchor.constraint(equalTo: webViewContainer.topAnchor),
            contentWebView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor),
            contentWebView.leadingAnchor.constraint(equalTo: webViewContainer.leadingAnchor),
            contentWebView.trailingAnchor.constraint(equalTo: webViewContainer.trailingAnchor)
        ]
        constraints.forEach({ anchor in
            anchor.isActive = true
        })
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
        viewModel?.articles
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self](articles) in
                self?.stopAnimating()
                //    self?.textLabel.text = articles.first?.title
               // self?.loadingActivityIndicatorView.stopAnimating()
                guard let first = articles.first else { return }
                self?.setArticle(article: first)
                
            })
            .addDisposableTo(disposeBag)
        
        viewModel?.errorObserver
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (errorMesage) in
                self?.stopAnimating()
                let alert = UIAlertController(title: nil, message: errorMesage, preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { [weak self] _ in
                    self?.dismiss(animated: true, completion: nil)
                })
                alert.addAction(noAction)
                self?.present(alert, animated: true, completion: nil)
                //self?.loadingActivityIndicatorView.stopAnimating()
                
            })
            .addDisposableTo(disposeBag)
    }
    
    func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setArticle(article: Article)  {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        gestureImageView.af_setImage(withURL: article.urlToImage)
        shadowedFont()
        
        let request = URLRequest(url: article.url)
        contentWebView.load(request)
    }
    
    func shadowedFont(){
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        titleLabel.layer.shadowRadius = 3.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.masksToBounds = false
        
        descriptionLabel.layer.shadowColor = UIColor.black.cgColor
        descriptionLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        descriptionLabel.layer.shadowRadius = 3.0
        descriptionLabel.layer.shadowOpacity = 1.0
        descriptionLabel.layer.masksToBounds = false
    }
    func tapImage(_ sender: UIGestureRecognizer) {
        guard let viewModel = viewModel else{
            return
        }
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
        if index > viewModel.articles.value.count-1 {
            index = viewModel.articles.value.count-1
        }
        let article = viewModel.articles.value[index]
        self.setArticle(article: article)
    }
    
    func swipeImage(_ gesture: UIGestureRecognizer) {
        
        guard let gesture = gesture as? UISwipeGestureRecognizer else { return }
        
        if gesture.direction == UISwipeGestureRecognizerDirection.up {
//            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewControllerID") as? DetailViewController else { return }
//            let article = viewModel?.articles.value[index]
//
//            vc.url = article?.url
//            self.present(vc, animated: true, completion: nil)

            UIView.animate(withDuration: 1.0, animations: {
                self.topViewConstraint.constant = 0.0
                self.view.layoutIfNeeded()
            })
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            print("Swipe Down")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func dissmissView(_ sender: UIButton) {
        let height = self.view.frame.height
        UIView.animate(withDuration: 1.0, animations: {
            self.topViewConstraint.constant = height
            self.view.layoutIfNeeded()
        })
    }
    
}
