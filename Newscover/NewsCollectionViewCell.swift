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

        shadowedFont()
    }
    
    func configureCell(source: Source)  {
        newsAuthorLabel.text = source.name
        titleLabel.text = source.description
        imageCell.image = UIImage(named: source.id)
        
        shadowedFont()
    }
    
    func shadowedFont(){
        newsAuthorLabel.layer.shadowColor = UIColor.black.cgColor
        newsAuthorLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        newsAuthorLabel.layer.shadowRadius = 3.0
        newsAuthorLabel.layer.shadowOpacity = 1.0
        newsAuthorLabel.layer.masksToBounds = false
        
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
        titleLabel.layer.shadowRadius = 1.0
        titleLabel.layer.shadowOpacity = 5.0
        titleLabel.layer.masksToBounds = false
    }
}
