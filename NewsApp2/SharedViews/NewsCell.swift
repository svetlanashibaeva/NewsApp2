//
//  NewsCell.swift
//  NewsApp2
//
//  Created by Света Шибаева on 01.08.2022.
//

import UIKit
import Kingfisher

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    func config(news: Article) {
        titleLabel.text = news.title
        dataLabel.text = news.date
        contentLabel.text = news.content
        setImage(urlToImage: news.urlToImage)
    }
    
    private func setImage(urlToImage: String?) {
        guard let urlToImage = urlToImage else {
            imageViewCell.image = UIImage(named: "default-image.jpg")
            return
        }
        let url = URL(string: urlToImage)
        imageViewCell.kf.indicatorType = .activity
        imageViewCell.kf.setImage(
            with: url,
            placeholder: UIImage(named: "default-image.jpg")
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        dataLabel.text = nil
        contentLabel.text = nil
        imageViewCell.image = nil
    }

}
