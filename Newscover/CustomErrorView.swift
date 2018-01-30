//
//  CustomErrorView.swift
//  Newscover
//
//  Created by CODE-MAC1 on 11/20/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import UIKit
import Reusable

class CustomErrorView: UIView, NibOwnerLoadable{
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var retryButton: UIButton!
    
    var retryButtonTapped: ((Void) -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit(){
        self.loadNibContent()
        configureRetrybutton()
    }
    
    fileprivate func configureRetrybutton(){
        retryButton.layer.masksToBounds = true
        retryButton.layer.cornerRadius = 8.0
    }
    
    func setMessage(_ message: String){
        messageLabel.text = message
    }
    
    @IBAction func tapRetryButton(_ sender: UIButton) {
        retryButtonTapped?()
    }
    
}
