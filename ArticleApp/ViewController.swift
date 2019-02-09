//
//  ViewController.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/3/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var articleService: ArticleService!
    
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleService = ArticleService()
        
//        // get article data from API
//        articleService.getArticles(title: nil, page: 1) { (articles) in
//            self.articles = articles
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // get article data from API
        articleService.getArticles(title: nil, page: 1) { (articles) in
            self.articles = articles
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: [:])?.first as! TableViewCell
        
        cell.setupCell(article: articles[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            let editVC = self.storyboard?.instantiateViewController(withIdentifier: "addArticleVC") as! AddArticleViewController
            editVC.article = self.articles[indexPath.row]
            self.navigationController?.pushViewController(editVC, animated: true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.articleService.deleteArticle(id: self.articles[indexPath.row].id, completionHandler: { (msg, status) in
                
                if status {
                    DispatchQueue.main.async {
                        self.articles.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.reloadData()
                    }
                }
                
                let alert = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }


}

