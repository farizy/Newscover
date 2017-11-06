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
    let author: String
    let title: String
    let description: String
    let url: URL
    let urlToImage: URL
    let publishedAt: String
}

extension Article{
    init?(json: JSON) {
        guard
            let author = json["author"].string,
            let title = json["title"].string,
            let description = json["description"].string,
            let url = URL(string: json["url"].stringValue),
            let urlImage = URL(string: json["urlToImage"].stringValue),
            let publishedAt = json["publishedAt"].string else
        { return nil }
        
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlImage
        self.publishedAt = publishedAt
    }
}
