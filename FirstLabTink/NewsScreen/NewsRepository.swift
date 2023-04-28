//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Anton on 04.02.2023.
//

import Foundation

final class NewsRepository {

    private let queue: DispatchQueue
    private var page = 1
    private let service: NewsService
    private let viewCountCache: NewsViewCountCache

    init(queue: DispatchQueue, service: NewsService, viewCountCache: NewsViewCountCache) {
        self.service = service
        self.queue = queue
        self.viewCountCache = viewCountCache
    }
    
    func refreshAll(_ completion: @escaping Callback<Result<[NewsItem], Error>>) {
        queue.async { [weak self] in
            guard let self else { return }
            self.page = 1
            self.loadData(completion: completion)
        }
    }
    
    func loadMore(_ completion: @escaping Callback<Result<[NewsItem], Error>>) {
        queue.async { [weak self] in
            guard let self else { return }
            self.loadData(completion: completion)
        }
    }
    
    func incrementViewCount(for newsItem: NewsItem) {
        queue.async { [weak self] in
            guard let self else { return }
            self.viewCountCache.increment(url: newsItem.fullNewsUrl)
        }
    }
    
    private func loadData(completion: @escaping Callback<Result<[NewsItem], Error>>) {
        service.load(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.page = data.page + 1
                let viewedCountData = self.viewCountCache.read()
                let domainItems = self.map(
                    news: data.news,
                    viewCountCache: viewedCountData
                )
                completion(.success(domainItems))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func map(
        news: [NewsItemCodable],
        viewCountCache: [URL : Int]?
    ) -> [NewsItem] {
        guard let viewCountCache else { return news.map { $0.toModel } }
        
        let domainNews = news.map { newsItem in
            if let countForNews = viewCountCache[newsItem.url] {
                let model = newsItem.toModel
                model.update(viewedCount: countForNews)
                return model
            } else {
                return newsItem.toModel
            }
        }

        return domainNews
    }
    
}
