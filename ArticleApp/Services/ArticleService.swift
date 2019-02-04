//
//  ArticleService.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/3/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import Foundation

class ArticleService {
    
    let URL_GET_ARTICLE = "http://www.chhaileng.com:9999/api/v1/articles"
    
    func getArticles(title: String?, page: Int, completionHandler: @escaping (_ articles: [Article]) -> Void) {
        let url = URL(string: "\(URL_GET_ARTICLE)?page=\(page)&title=\(title ?? "")")
        
        var request = URLRequest(url: url!)
        request.addValue("Basic YXBpOmFwaQ==", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let res = jsonObject as! [String: Any]
                let status = res["status"] as! Bool
                if status {
                    var articles = [Article]()
                    let data = res["data"] as! NSArray
                    for d in data {
                        let a = d as! [String: Any]
                        let id = a["id"] as! Int
                        let title = a["title"] as! String
                        let description = a["description"] as! String
                        let thumbnail = a["thumbnail"] as! String
                        let author = a["author"] as! String
                        let createdDate = a["createdDate"] as! String
                        
                        let cate = a["category"] as! [String: Any]
                        let cateId = cate["id"] as! Int
                        let cateName = cate["name"] as! String
                        let category = Category(id: cateId, name: cateName)
                        
                        let article = Article(id: id, title: title, category: category, description: description, thumbnail: thumbnail, author: author, createdDate: createdDate)
                        
                        articles.append(article)
                    }
                    
                    completionHandler(articles)
                }
            }
        }
        
        task.resume()

    }
    
    
}
