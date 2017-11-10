//
//  DetailViewController.swift
//  Newscover
//
//  Created by Ahmad Farizy on 11/9/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
//    @IBOutlet weak var contentWebView: WKWebView!
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var webViewContainer: UIView!
    
    var contentWebView: WKWebView = WKWebView()
    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

        
        guard let url = self.url else { return }
        let request = URLRequest(url: url)
        contentWebView.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeView(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        view.addGestureRecognizer(swipeDown)
    }
    
    func swipeView(_ gesture: UIGestureRecognizer) {
        guard let gesture = gesture as? UISwipeGestureRecognizer else { return }
        if gesture.direction == UISwipeGestureRecognizerDirection.down {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
