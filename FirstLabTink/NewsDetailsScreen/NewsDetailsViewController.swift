//
//  NewsDetailsViewController.swift
//  NewsApp
//
//  Created by Anton on 05.02.2023.
//

import UIKit

final class NewsDetailsViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var newsTitle: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var author: UILabel!

    private let newsItem: NewsItem
    
    init(newsItem: NewsItem) {
        self.newsItem = newsItem
        super.init(nibName: "NewsDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = newsItem.title
        imageView.load(imageUrl: newsItem.imageUrl)
        newsTitle.text = newsItem.title
        descriptionLabel.text = newsItem.description
        date.text = newsItem.date
        author.text = newsItem.author
    }
    
    @IBAction private func readFullNewsDidPress() {
        let vc = FullNewsViewController(url: newsItem.fullNewsUrl)
        self.present(vc, animated: true)
    }
    
}
