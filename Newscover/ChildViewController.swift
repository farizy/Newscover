//
//  ChildViewController.swift
//  Newscover
//
//  Created by Ahmad Farizy on 30/01/18.
//  Copyright © 2018 PT. Code Development Indonesia. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum ChildVC {
    case childOne
    case childTwo
    case childThree
}

class ChildViewController: UIViewController, IndicatorInfoProvider {
    
    var child: ChildVC?
    
    @IBOutlet weak var pageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch child {
        case .childOne?:
            pageLabel.text = "PAGE 1"
        case .childTwo?:
            pageLabel.text = "PAGE 2"
        case .childThree?:
            pageLabel.text = "PAGE 3"
        case .none:
            pageLabel.text = "Mbuh wis"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        switch child {
        case .childOne?:
            return IndicatorInfo(title: "Child 1")
        case .childTwo?:
            return IndicatorInfo(title: "Child 2")
        case .childThree?:
            return IndicatorInfo(title: "Child 3")
        case .none:
            return IndicatorInfo(title: nil)
        }
    }
    
}
