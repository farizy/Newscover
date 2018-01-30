//
//  Article.swift
//  Newscover
//
//  Created by Ahmad Farizy on 11/6/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Article {
    let author: String?
    let title: String
    let description: String
    let url: URL
    let urlToImage: URL
    let publishedAt: String?
    var isSelected: Bool = false
}

extension Article{
    init?(json: JSON) {
        guard
            let title = json["title"].string,
            let description = json["description"].string,
            let url = URL(string: json["url"].stringValue),
            let urlImage = URL(string: json["urlToImage"].stringValue)
        else { return nil }
        
        self.author = json["author"].string
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlImage
        self.publishedAt = json["publishedAt"].string
    }
}
