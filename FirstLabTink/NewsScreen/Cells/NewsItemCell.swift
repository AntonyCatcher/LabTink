//
//  NewsItemCell.swift
//  NewsApp
//
//  Created by Anton on 04.02.2023.
//

import UIKit

final class NewsItemCell: UITableViewCell {
    
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var newsTitle: UILabel!
    @IBOutlet private weak var viewedCount: UILabel!
    
    override func prepareForReuse() {
        self.newsImage.image = nil
    }

    func setup(with newsItem: NewsItem) {
        newsTitle.text = newsItem.title
        viewedCount.text = newsItem.viewedCount
        newsImage.load(imageUrl: newsItem.imageUrl)
        
        newsItem.onUpdateViewedCount = { [weak self] viewedCountText in
            self?.viewedCount.text = viewedCountText
        }
    }

}
