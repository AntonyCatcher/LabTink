//
//  NewsItem.swift
//  NewsApp
//
//  Created by Anton on 04.02.2023.
//

import Foundation

final class NewsItem {
    
    var onUpdateViewedCount: Callback<String>?
    
    let title: String
    let imageUrl: URL?
    let description: String
    let date: String
    let author: String
    let fullNewsUrl: URL
    
    private var viewedCountInt: Int {
        didSet {
            onUpdateViewedCount?(viewedCount)
        }
    }
    
    var viewedCount: String {
        "Просмотрено: \(viewedCountInt)"
    }
    
    init(title: String, imageUrl: URL? = nil, description: String, date: String, author: String, fullNewsUrl: URL, viewedCountInt: Int) {
        self.title = title
        self.imageUrl = imageUrl
        self.description = description
        self.date = date
        self.author = author
        self.fullNewsUrl = fullNewsUrl
        self.viewedCountInt = viewedCountInt
    }
    
    func incrementViewCount() {
        viewedCountInt += 1
    }
    
}

extension NewsItem {
    func update(viewedCount: Int) {
        self.viewedCountInt = viewedCount
    }
}
