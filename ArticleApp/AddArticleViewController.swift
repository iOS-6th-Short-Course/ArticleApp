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
    
    var imagePickerController: UIImagePickerController!
    
    var article: Article?
    
    var firstImage: UIImage?
    var secondImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let article = article {
            titleTextField.text = article.title
            authorTextField.text = article.author
            descriptionTextView.text = article.description
            categoryTextField.text = "\(article.category!.id!)"
            thumbnailImageView.kf.setImage(with: URL(string: article.thumbnail!))
            
            title = "Update Article"
            button.setTitle("Update", for: .normal)
            
            firstImage = thumbnailImageView.image
            secondImage = firstImage
        }
        
        articleService = ArticleService()
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        thumbnailImageView.addGestureRecognizer(tapGesture)
        thumbnailImageView.isUserInteractionEnabled = true
        
    }
    
    @objc func pickImage() {
        present(imagePickerController, animated: true, completion: nil)
    }
    

    @IBAction func buttonTapped(_ sender: Any) {
        if var article = article {
            article = Article(id: article.id!,
                              title: titleTextField.text!,
                              description: descriptionTextView.text!,
                              author: authorTextField.text!,
                              thumbnail: article.thumbnail!,
                              cateId: Int(categoryTextField.text!)!)
            
            var imageData: Data? = nil
            
            if firstImage != secondImage {
                imageData = UIImage.pngData(thumbnailImageView.image!)()
            }
            
            articleService.checkImageUpload(data: imageData, article: article, completionHandler: { (msg, status) in
                let alert = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    if status {
                        self.navigationController?.popViewController(animated: true)
                    }
                }))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                
            })
        } else {
            let article = Article(id: 0,
                                  title: titleTextField.text!,
                                  description: descriptionTextView.text!,
                                  author: authorTextField.text!,
                                  thumbnail: "",
                                  cateId: Int(categoryTextField.text!)!)

            let imageData = UIImage.pngData(thumbnailImageView.image!)()
            
            articleService.uploadImage(imageData: imageData!, article: article) { (message, status) in
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


extension AddArticleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            thumbnailImageView.image = image
            secondImage = image
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
}
