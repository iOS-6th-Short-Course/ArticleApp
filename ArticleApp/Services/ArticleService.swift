//
//  ArticleService.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/3/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import Foundation

class ArticleService {
    
    let URL_ARTICLE = "http://ams.chhaileng.com/api/v1/articles"
    
    func getArticles(title: String?, page: Int, completionHandler: @escaping (_ articles: [Article]) -> Void) {
        let url = URL(string: "\(URL_ARTICLE)?page=\(page)&title=\(title ?? "")")
        
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
    
    
    func addArticle(article: Article, completionHandler: @escaping (_ message: String, _ status: Bool) -> Void) {
        let url = URL(string: URL_ARTICLE)
        
        var request = URLRequest(url: url!)
        request.addValue("Basic YXBpOmFwaQ==", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let jsonObj: [String: Any] = [
            "title": article.title,
            "description": article.description,
            "author": article.author,
            "category": [
                "id": article.category.id
            ],
            "thumbnail": article.thumbnail
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: [])
        request.httpBody = jsonData!
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let dict = jsonObj as! [String: Any]
                let message = dict["message"] as! String
                let status = dict["status"] as! Bool
                completionHandler(message, status)
            }
        }.resume()
        
    }
    
    
    func updateArticle(article: Article, completionHandler: @escaping (_ message: String, _ status: Bool) -> Void) {
        let url = URL(string: URL_ARTICLE)
        
        var request = URLRequest(url: url!)
        request.addValue("Basic YXBpOmFwaQ==", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        let jsonObj: [String: Any] = [
            "id": article.id,
            "title": article.title,
            "description": article.description,
            "author": article.author,
            "category": [
                "id": article.category.id
            ],
            "thumbnail": article.thumbnail
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: [])
        request.httpBody = jsonData!
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let dict = jsonObj as! [String: Any]
                let message = dict["message"] as! String
                let status = dict["status"] as! Bool
                completionHandler(message, status)
            }
        }.resume()
        
        
    }
    
    func deleteArticle(id: Int, completionHandler: @escaping (_ message: String, _ status: Bool) -> Void) {
        let url = URL(string: "\(URL_ARTICLE)/\(id)")
        
        var request = URLRequest(url: url!)
        request.addValue("Basic YXBpOmFwaQ==", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let dict = jsonObj as! [String: Any]
                let message = dict["message"] as! String
                let status = dict["status"] as! Bool
                completionHandler(message, status)
            }
        }.resume()
    }
    
    
}
