//
//  NewsItemCodable.swift
//  NewsApp
//
//  Created by Anton on 05.02.2023.
//

import Foundation

struct NewsItemCodable: Codable {
    let author: String?
    let title: String
    let description: String?
    let url: URL
    let urlToImage: URL?
    let publishedAt: Date
}

extension NewsItemCodable {
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}

extension NewsItemCodable {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()
    
    var toModel: NewsItem {
        NewsItem(
            title: self.title,
            imageUrl: self.urlToImage,
            description: self.description ?? "",
            date: NewsItemCodable.dateFormatter.string(from: self.publishedAt),
            author: self.author ?? "",
            fullNewsUrl: self.url,
            viewedCountInt: 0
        )
    }
}
