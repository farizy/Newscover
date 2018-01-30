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
            let all = UIStoryboard(name: "NewsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "NewsCollectionViewControllerID") as? NewsCollectionViewController,
            let general = UIStoryboard(name: "NewsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "NewsCollectionViewControllerID") as? NewsCollectionViewController,
            let sport = UIStoryboard(name: "NewsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "NewsCollectionViewControllerID") as? NewsCollectionViewController,
            let tech = UIStoryboard(name: "NewsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "NewsCollectionViewControllerID") as? NewsCollectionViewController,
            let enter = UIStoryboard(name: "NewsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "NewsCollectionViewControllerID") as? NewsCollectionViewController,
            let business = UIStoryboard(name: "NewsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "NewsCollectionViewControllerID") as? NewsCollectionViewController,
            let science = UIStoryboard(name: "NewsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "NewsCollectionViewControllerID") as? NewsCollectionViewController
        else { return [] }
        
        all.category = ChildCategory.all
        general.category = ChildCategory.general
        sport.category = ChildCategory.sport
        tech.category = ChildCategory.technology
        enter.category = ChildCategory.entertaiment
        business.category = ChildCategory.business
        science.category = ChildCategory.science
        
        return [all, general, sport, tech, enter, business, science]
    }
}
