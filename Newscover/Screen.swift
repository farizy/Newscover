//
//  Screen.swift
//  Newscover
//
//  Created by CODE-MAC1 on 11/14/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import UIKit

internal protocol Screen {
    func build() -> UIViewController
}

internal class ViewController<T>: Screen {
    var input: T
    
    required init(_ input: T) {
        self.input = input
    }
    
    func build() -> UIViewController {
        return UIViewController()
    }
}
