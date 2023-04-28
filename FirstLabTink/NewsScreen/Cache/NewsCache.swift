//
//  NewsCache.swift
//  NewsApp
//
//  Created by Anton on 05.02.2023.
//

import Foundation

struct NewsCacheItem: Codable {
    let page: Int
    let items: [NewsItemCodable]
}

protocol NewsCache {
    func read() -> NewsCacheItem?
    func save(cacheItem: NewsCacheItem)
    func removeAll()
}

final class DiskNewsCache: NewsCache {
    
    private let filePath = FileManager.default.urls(
        for: .cachesDirectory, in: .userDomainMask
    )[0].appendingPathComponent("newsCache", isDirectory: false).path
    
    func read() -> NewsCacheItem? {
        guard let data = FileManager.default.contents(atPath: filePath) else { return nil }
        return (try? NewsItemCodable.decoder.decode(NewsCacheItem.self, from: data))
    }
    
    func save(cacheItem: NewsCacheItem) {
        guard let data = try? NewsItemCodable.encoder.encode(cacheItem) else { return }
        FileManager.default.createFile(atPath: filePath, contents: data)
    }
    
    func removeAll() {
        try? FileManager.default.removeItem(atPath: filePath)
    }
    
}
