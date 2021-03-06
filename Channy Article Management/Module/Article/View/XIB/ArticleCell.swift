//
//  ArticleCell.swift
//  Channy Article Management
//
//  Created by sok channy on 12/13/16.
//  Copyright © 2016 channy-origin. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configuration(_ article : Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.articleDescription
        do {
            let url = URL(string: article.image!) ?? URL(string : "http://120.136.24.174:1301/image-thumbnails/thumbnail-9350859e-6565-40f1-b5b3-7d1e0f859a73.jpg")
            let data = try Data(contentsOf: url!)
            articleImageView.image = UIImage(data: data)
        }catch {}
    }
    
    
    
}
