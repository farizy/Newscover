//
//  GestureViewController.swift
//  Newscover
//
//  Created by Ahmad Farizy on 11/9/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import UIKit

class GestureViewController: UIViewController {

    @IBOutlet weak var gestureImageView: UIImageView!
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
    let swipeLeft:UISwipeGestureRecognizer = {
        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(swipeImage(_:)))
        swipeleft.direction = UISwipeGestureRecognizerDirection.left

        return swipeleft
    }()//UISwipeGestureRecognizer(target: self, action: #selector(swipeImage))

    let swipeUp:UISwipeGestureRecognizer = {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeImage(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        
        return swipeUp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureImageView.isUserInteractionEnabled = true
//        swipeLeft.delegate = self
//        swipeUp.delegate = self
//        gestureImageView.addGestureRecognizer(tap)
        gestureImageView.addGestureRecognizer(swipeLeft)
        gestureImageView.addGestureRecognizer(swipeUp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapImage(_ sender: UIGestureRecognizer) {
//        print("tapped")
    
        let asu = sender.location(in: gestureImageView)
        let alert = UIAlertController(title: nil, message: "tapped @ \(asu.x),\(asu.y)", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func swipeImage(_ gesture: UIGestureRecognizer) {
        
        guard let gesture = gesture as? UISwipeGestureRecognizer else { return }
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            print("Swipe Right")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            print("Swipe Left")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.up {
            print("Swipe Up")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            print("Swipe Down")
        }
    }
    
}

extension GestureViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
