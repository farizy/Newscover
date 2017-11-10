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

    let viewModel = GestureViewModel()
    let disposableBag = DisposeBag()
    
    let book = [#imageLiteral(resourceName: "norwegianwood"), #imageLiteral(resourceName: "norwegianwood2"), #imageLiteral(resourceName: "running"), #imageLiteral(resourceName: "windupbird"), #imageLiteral(resourceName: "windupbird2") ]
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureImageView.isUserInteractionEnabled = true
        gestureImageView.image = book[index]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
        gestureImageView.addGestureRecognizer(tap)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeImage(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        gestureImageView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeImage(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        gestureImageView.addGestureRecognizer(swipeDown)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if index > book.count-1 { index = book.count-1}

        gestureImageView.image = book[index]
    }
    
    func swipeImage(_ gesture: UIGestureRecognizer) {
        
        guard let gesture = gesture as? UISwipeGestureRecognizer else { return }
        
        if gesture.direction == UISwipeGestureRecognizerDirection.up {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewControllerID") as? DetailViewController else { return }
            self.present(vc, animated: true, completion: nil)
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            print("Swipe Down")
            
            let alert = UIAlertController(title: nil, message: "Swipe Down", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
