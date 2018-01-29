//
//  WebViewController.swift
//  Newscover
//
//  Created by Ahmad Farizy on 29/01/18.
//  Copyright © 2018 PT. Code Development Indonesia. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var article: Article? = nil
    var contentWebView: WKWebView = WKWebView()
    
    @IBOutlet weak var doneButton: UIBarButtonItem!{
        didSet{
            doneButton.target = self
            doneButton.action = #selector(doneAction(sender:))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebViewLayout()
        configureWebViewArticle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureWebViewLayout() {
        contentWebView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        contentWebView.translatesAutoresizingMaskIntoConstraints = false
        contentWebView.scrollView.layer.masksToBounds = false
        
        view.addSubview(contentWebView)
        
        let constraints = [
            contentWebView.topAnchor.constraint(equalTo: view.topAnchor),
            contentWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        constraints.forEach({ anchor in
            anchor.isActive = true
        })
    }
    
    func configureWebViewArticle() {
        guard let article = self.article else { return }
        navigationItem.title = article.title
        
        let request = URLRequest(url: article.url)
        contentWebView.load(request)
    }
    
    func doneAction(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
