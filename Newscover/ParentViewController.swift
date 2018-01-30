//
//  ParentViewController.swift
//  Newscover
//
//  Created by Ahmad Farizy on 30/01/18.
//  Copyright © 2018 PT. Code Development Indonesia. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ParentViewController: ButtonBarPagerTabStripViewController {
    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        guard
            let child1 = UIStoryboard(name: "NewsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ChildViewControllerID") as? ChildViewController,
            let child2 = UIStoryboard(name: "NewsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ChildViewControllerID") as? ChildViewController,
            let child3 = UIStoryboard(name: "NewsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ChildViewControllerID") as? ChildViewController
        else { return [] }
        
        child1.child = ChildVC.childOne
        child2.child = ChildVC.childTwo
        child3.child = ChildVC.childThree
        
        return [child1, child2, child3]
    }
}
