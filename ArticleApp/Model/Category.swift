//
//  Category.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/3/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import Foundation
import SwiftyJSON

class Category {
    var id: Int?
    var name: String?
    
    init() { }

    init(json: JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
