//
//  TableViewCell.swift
//  ArticleApp
//
//  Created by Chhaileng Peng on 2/9/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(article: Article) {
        titleLabel.text = article.title
        authorLabel.text = article.author
        createdDateLabel.text = article.createdDate
        
//        DispatchQueue.main.async {
//            let imageData = try? Data(contentsOf: URL(string: article.thumbnail)!)
//            self.thumbnailImageView.image = UIImage(data: imageData!)
//        }
        thumbnailImageView.kf.indicatorType = .activity
//        thumbnailImageView.kf.setImage(with: URL(string: article.thumbnail))
        thumbnailImageView.kf.setImage(with: URL(string: article.thumbnail), placeholder: #imageLiteral(resourceName: "default-image"))
        
    }
    
}
