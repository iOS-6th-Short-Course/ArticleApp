//
//  ArticleService.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/3/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import Foundation

//class ArticleService {
//
//    let URL_ARTICLE = "http://ams.chhaileng.com/api/v1/articles"
//
//    func getArticles(title: String?, page: Int, completionHandler: @escaping (_ articles: [Article]) -> Void) {
//        let url = URL(string: "\(URL_ARTICLE)?page=\(page)&title=\(title ?? "")")
//
//        var request = URLRequest(url: url!)
//        request.addValue("Basic YXBpOmFwaQ==", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "GET"
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if error == nil {
//                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//                let res = jsonObject as! [String: Any]
//                let status = res["status"] as! Bool
//                if status {
//                    var articles = [Article]()
//                    let data = res["data"] as! NSArray
//                    for d in data {
//                        let a = d as! [String: Any]
//                        let id = a["id"] as! Int
//                        let title = a["title"] as! String
//                        let description = a["description"] as! String
//                        let thumbnail = a["thumbnail"] as! String
//                        let author = a["author"] as! String
//                        let createdDate = a["createdDate"] as! String
//
//                        let cate = a["category"] as! [String: Any]
//                        let cateId = cate["id"] as! Int
//                        let cateName = cate["name"] as! String
//                        let category = Category(id: cateId, name: cateName)
//
//                        let article = Article(id: id, title: title, category: category, description: description, thumbnail: thumbnail, author: author, createdDate: createdDate)
//
//                        articles.append(article)
//                    }
//
//                    completionHandler(articles)
//                }
//            }
//        }
//
//        task.resume()
//
//    }
//
//
//    func addArticle(article: Article, completionHandler: @escaping (_ message: String, _ status: Bool) -> Void) {
//        let url = URL(string: URL_ARTICLE)
//
//        var request = URLRequest(url: url!)
//        request.addValue("Basic YXBpOmFwaQ==", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//
//        let jsonObj: [String: Any] = [
//            "title": article.title,
//            "description": article.description,
//            "author": article.author,
//            "category": [
//                "id": article.category.id
//            ],
//            "thumbnail": article.thumbnail
//        ]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: [])
//        request.httpBody = jsonData!
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if error == nil {
//                let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//                let dict = jsonObj as! [String: Any]
//                let message = dict["message"] as! String
//                let status = dict["status"] as! Bool
//                completionHandler(message, status)
//            }
//        }.resume()
//
//    }
//
//
//    func updateArticle(article: Article, completionHandler: @escaping (_ message: String, _ status: Bool) -> Void) {
//        let url = URL(string: URL_ARTICLE)
//
//        var request = URLRequest(url: url!)
//        request.addValue("Basic YXBpOmFwaQ==", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "PUT"
//
//        let jsonObj: [String: Any] = [
//            "id": article.id,
//            "title": article.title,
//            "description": article.description,
//            "author": article.author,
//            "category": [
//                "id": article.category.id
//            ],
//            "thumbnail": article.thumbnail
//        ]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: [])
//        request.httpBody = jsonData!
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if error == nil {
//                let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//                let dict = jsonObj as! [String: Any]
//                let message = dict["message"] as! String
//                let status = dict["status"] as! Bool
//                completionHandler(message, status)
//            }
//        }.resume()
//
//
//    }
//
//    func deleteArticle(id: Int, completionHandler: @escaping (_ message: String, _ status: Bool) -> Void) {
//        let url = URL(string: "\(URL_ARTICLE)/\(id)")
//
//        var request = URLRequest(url: url!)
//        request.addValue("Basic YXBpOmFwaQ==", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "DELETE"
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if error == nil {
//                let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//                let dict = jsonObj as! [String: Any]
//                let message = dict["message"] as! String
//                let status = dict["status"] as! Bool
//                completionHandler(message, status)
//            }
//        }.resume()
//    }
//
//
//}



import Alamofire
import SwiftyJSON


class ArticleService {
    
    let URL_ARTICLE = "http://ams.chhaileng.com/api/v1/articles"
    let headers = [
        "Authorization": "Basic YXBpOmFwaQ==",
        "Content-Type": "application/json"
    ]
    
    func getArticles(title: String?, page: Int, completionHandler: @escaping (_ articles: [Article]) -> Void) {
        
        Alamofire.request("\(URL_ARTICLE)?limit=15&page=\(page)&title=\(title ?? "")", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(_):
                var articles = [Article]()
                
                let jsonObject = try? JSON(data: response.data!)
                let articleJsonArray = jsonObject!["data"].array
                for articleJson in articleJsonArray! {
                    let article = Article(json: articleJson)
                    articles.append(article)
                }
                completionHandler(articles)
                
            case .failure(_):
                print("Failed to fecth data")
            }
        }
        
    }
    
    
    func addArticle(article: Article, completionHandler: @escaping (_ message: String, _ status: Bool) -> Void) {
        
        let params: [String: Any] = [
            "title": article.title!,
            "description": article.description!,
            "author": article.author!,
            "category": [
                "id": article.category?.id
            ],
            "thumbnail": article.thumbnail!
        ]
        
        
        Alamofire.request(URL_ARTICLE, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let jsonObject = try? JSON(data: response.data!)
                let message = jsonObject!["message"].string
                let status = jsonObject!["status"].bool
                completionHandler(message!, status!)
                
            case .failure(_):
                print("Failed to add data")
            }
        }
        
    }
    
    
    func updateArticle(article: Article, completionHandler: @escaping (_ message: String, _ status: Bool) -> Void) {
       
        let params: [String: Any] = [
            "id": article.id!,
            "title": article.title!,
            "description": article.description!,
            "author": article.author!,
            "category": [
                "id": article.category?.id
            ],
            "thumbnail": article.thumbnail!
        ]
        
        Alamofire.request(URL_ARTICLE, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let jsonObject = try? JSON(data: response.data!)
                let message = jsonObject!["message"].string
                let status = jsonObject!["status"].bool
                completionHandler(message!, status!)
                
            case .failure(_):
                print("Failed to update data")
            }
        }
        
    }
    
    func deleteArticle(id: Int, completionHandler: @escaping (_ message: String, _ status: Bool) -> Void) {
        
        Alamofire.request("\(URL_ARTICLE)/\(id)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let jsonObject = try? JSON(data: response.data!)
                let message = jsonObject!["message"].string
                let status = jsonObject!["status"].bool
                completionHandler(message!, status!)
                
            case .failure(_):
                print("Failed to delete data")
            }
        }
    }
    
    func uploadImage(imageData: Data, article: Article, completionHandler: @escaping (_ msg: String, _ status: Bool) -> Void) {
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(imageData, withName: "file", fileName: "upload.jpg", mimeType: "image/*")
        }, usingThreshold: 0, to: "http://ams.chhaileng.com/api/v1/upload", method: .post, headers: headers) { (encodingResult) in
            
            switch encodingResult {
                
            case .success(let request, _, _):
                request.responseJSON(completionHandler: { (response) in
                    let url = String(data: response.data!, encoding: String.Encoding.utf8)
                    
                    article.thumbnail = url
                    
                    if article.id == 0 {
                        self.addArticle(article: article, completionHandler: { (msg, status) in
                            completionHandler(msg, status)
                        })
                    } else {
                        self.updateArticle(article: article, completionHandler: { (msg, status) in
                            completionHandler(msg, status)
                        })
                    }
                })
            case .failure(_):
                print("UPLOAD FAILD")
            }
            
        }
    }
    
    
    func checkImageUpload(data: Data?, article: Article, completionHandler: @escaping (_ msg: String, _ status: Bool) -> Void) {
        
        if article.id != 0 {
            if let data = data {
                uploadImage(imageData: data, article: article) { (msg, status) in
                    completionHandler(msg, status)
                }
            } else {
                updateArticle(article: article) { (msg, status) in
                    completionHandler(msg, status)
                }
            }
        }
        
    }
    
    
}
