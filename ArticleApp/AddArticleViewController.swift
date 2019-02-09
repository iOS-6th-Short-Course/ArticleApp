//
//  AddArticleViewController.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/9/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import UIKit
import Kingfisher

class AddArticleViewController: UIViewController {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var button: UIButton!
    
    var articleService: ArticleService!
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let article = article {
            titleTextField.text = article.title
            authorTextField.text = article.author
            descriptionTextView.text = article.description
            categoryTextField.text = "\(article.category.id)"
            thumbnailImageView.kf.setImage(with: URL(string: article.thumbnail))
            
            title = "Update Article"
            button.setTitle("Update", for: .normal)
        }
        
        articleService = ArticleService()
    }
    

    @IBAction func buttonTapped(_ sender: Any) {
        if var article = article {
            article = Article(id: article.id,
                              title: titleTextField.text!,
                              description: descriptionTextView.text!,
                              author: authorTextField.text!,
                              thumbnail: article.thumbnail,
                              cateId: Int(categoryTextField.text!)!)
            
            articleService.updateArticle(article: article) { (message, status) in
                let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    if status {
                        self.navigationController?.popViewController(animated: true)
                    }
                }))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let article = Article(id: 0,
                                  title: titleTextField.text!,
                                  description: descriptionTextView.text!,
                                  author: authorTextField.text!,
                                  thumbnail: "https://ichef.bbci.co.uk/images/ic/720x405/p0517py6.jpg",
                                  cateId: Int(categoryTextField.text!)!)
            
            articleService.addArticle(article: article) { (message, status) in
                let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    if status {
                        self.navigationController?.popViewController(animated: true)
                    }
                }))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
}
