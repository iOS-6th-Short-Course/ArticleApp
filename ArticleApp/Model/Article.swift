//
//  Article.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/3/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import Foundation

class Article {
    var id: Int
    var title: String
    var category: Category
    var description: String
    var thumbnail: String
    var author: String
    var createdDate: String
    
    init(id: Int, title: String, category: Category, description: String, thumbnail: String, author: String, createdDate: String) {
        
        self.id = id
        self.title = title
        self.category = category
        self.description = description
        self.thumbnail = thumbnail
        self.author = author
        self.createdDate = createdDate
        
    }
    
}
