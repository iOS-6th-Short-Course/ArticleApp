//
//  Article.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/3/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import Foundation
import SwiftyJSON

class Article {
    var id: Int?
    var title: String?
    var category: Category?
    var description: String?
    var thumbnail: String?
    var author: String?
    var createdDate: String?
    
    init() { }
    
    init(json: JSON) {
        self.id = json["id"].int
        self.title = json["title"].string
        self.category = Category(json: json["category"])
        self.description = json["description"].string
        self.thumbnail = json["thumbnail"].string
        self.author = json["author"].string
        self.createdDate = json["createdDate"].string
    }
    
    
    init(id: Int, title: String, category: Category, description: String, thumbnail: String, author: String, createdDate: String) {
        self.id = id
        self.title = title
        self.category = category
        self.description = description
        self.thumbnail = thumbnail
        self.author = author
        self.createdDate = createdDate
    }
    
    init(id: Int, title: String, description: String, author: String, thumbnail: String, cateId: Int) {
        self.id = id
        self.title = title
        self.category = Category(id: cateId, name: "")
        self.description = description
        self.thumbnail = thumbnail
        self.author = author
        self.createdDate = ""
    }
    
    
    
    
    
}

