//
//  NewsCollectionViewCell.swift
//  Newscover
//
//  Created by CODE-MAC1 on 11/9/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import UIKit
import Reusable
import AlamofireImage

internal final class NewsCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var newsAuthorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var data: Article? = nil
    
    func configureCell(data: Article){
        self.data = data
        newsAuthorLabel.text = data.author
        titleLabel.text = data.title
        
        imageCell.af_setImage(withURL: data.urlToImage)
        
    }
    
}
