//
//  NewsServiceWithCache.swift
//  NewsApp
//
//  Created by Anton on 05.02.2023.
//

import Foundation

final class NewsServiceWithCache: NewsService {

    private let service: NewsService
    private let cache: NewsCache
    
    private var isPrefetched = false
    private var currentNews: [NewsItemCodable] = []
    
    init(service: NewsService, cache: NewsCache) {
        self.service = service
        self.cache = cache
    }
    
    func load(page: Int, completion: @escaping NewsServiceResult) {
        if let cachedValues = prefetch() {
            isPrefetched = true
            currentNews = cachedValues.items
            completion(.success((news: cachedValues.items, page: cachedValues.page)))
        } else {
            if page == 1 {
                log("Clear cache")
                currentNews = []
                cache.removeAll()
            }
            
            service.load(page: page) { [weak self] result in
                completion(result)

                switch result {
                case .success(let items):
                    self?.save(page: page, items: items.news)
                case.failure:
                    break
                }
            }
        }
    }
    
    private func prefetch() -> NewsCacheItem? {
        guard !isPrefetched else { return nil }
        isPrefetched = true
        
        guard let cachedValues = cache.read(), !cachedValues.items.isEmpty else { return nil }
        return cachedValues
    }
    
    func save(page: Int, items: [NewsItemCodable]) {
        currentNews += items
        cache.save(cacheItem: NewsCacheItem(page: page, items: currentNews))
    }
    
}
