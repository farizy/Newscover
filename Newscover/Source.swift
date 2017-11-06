//
//  Source.swift
//  Newscover
//
//  Created by Ahmad Farizy on 11/6/17.
//  Copyright © 2017 PT. Code Development Indonesia. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Category: String {
    case general = "general"
    case business = "business"
    case entertaiment = "entertainment"
    case gaming = "gaming"
    case music = "music"
    case politics = "politics"
    case science = "science-and-nature"
    case sport = "sport"
    case technology = "technology"
}

enum SortBy: String{
    case top = "top"
    case latest = "latest"
    case popular = "popular"
}

struct Source {
    let id: String
    let name: String
    let description: String
    let url: URL
    let category: Category
    let language: String
    let country: String
    let sortBy: [SortBy]
}

extension Source{
    init?(json: JSON) {
        guard
            let id = json["id"].string,
            let name = json["name"].string,
            let description = json["description"].string,
            let url = URL(string: json["url"].stringValue),
            let category = Category(rawValue: json["category"].stringValue),
            let language = json["language"].string,
            let country = json["country"].string,
            let sortByArray = json["sortBysAvailable"].arrayObject
        else { return nil }
        
        self.id = id
        self.name = name
        self.description = description
        self.url = url
        self.category = category
        self.language = language
        self.country = country
        self.sortBy = sortByArray.flatMap({ SortBy(rawValue: String(describing: $0)) })
    }
}
