//
//  NewsViewCountCache.swift
//  NewsApp
//
//  Created by Anton on 05.02.2023.
//

import Foundation

protocol NewsViewCountCache {
    func read() -> [URL: Int]?
    func increment(url: URL)
    func removeAll()
}

final class DiskNewsViewCountCache: NewsViewCountCache {
    
    private let filePath = FileManager.default.urls(
        for: .cachesDirectory, in: .userDomainMask
    )[0].appendingPathComponent("newsViewCountCache", isDirectory: false).path

    func read() -> [URL: Int]? {
        guard let data = FileManager.default.contents(atPath: filePath) else { return nil }
        return (try? NewsItemCodable.decoder.decode([URL: Int].self, from: data))
    }
    
    func increment(url: URL) {
        if var currentData = read() {
            let currentCount = currentData[url] ?? 0
            currentData[url] = currentCount + 1
            
            FileManager.default.createFile(
                atPath: filePath,
                contents: try! JSONEncoder().encode(currentData)
            )
        } else {
            let cache: [URL: Int] = [url: 1]
            FileManager.default.createFile(
                atPath: filePath,
                contents: try! JSONEncoder().encode(cache)
            )
        }
    }
    
    func removeAll() {
        try? FileManager.default.removeItem(atPath: filePath)
    }
    
}
