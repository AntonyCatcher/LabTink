//
//  NewsService.swift
//  NewsApp
//
//  Created by Anton on 05.02.2023.
//

import Foundation

typealias NewsServiceResult = Callback<Result<(news: [NewsItemCodable], page: Int), Error>>

protocol NewsService {
    func load(
        page: Int,
        completion: @escaping NewsServiceResult
    )
}

final class UrlSessionNewsService: NewsService {
    
    private enum Endpoints: String {
        case news = "https://newsapi.org/v2/everything?q=bank&language=ru&pageSize=20&apiKey=4d9bc3f37c684f6e850e9f5dc36ae373"
    }
    
    private let queue: DispatchQueue
    
    init(queue: DispatchQueue) {
        self.queue = queue
    }
    
    private struct Wrap: Decodable {
        let articles: [NewsItemCodable]
    }
    
    func load(page: Int, completion: @escaping NewsServiceResult) {
        log("start loading \(page)")
        let request = prepareRequest(page: page)
        URLSession.shared.dataTask(with: request) { [weak self] data, resp, error in
            guard let self else { return completion(.failure(NSError.unexpectedError)) }
            
            log("finish loading \(page)")
            
            if let error {
                log("error \(error)")
                self.queue.async {
                    completion(.failure(error))
                }
            } else if let data {
                do {
                    let wrap = try NewsItemCodable.decoder.decode(Wrap.self, from: data)
                    log("success \(wrap.articles.count)")
                    self.queue.async {
                        completion(.success((news: wrap.articles, page: page)))
                    }
                } catch {
                    log("failed \(error)")
                    self.queue.async {
                        completion(.failure(NSError.unexpectedError))
                    }
                }
            }
        }.resume()
    }
    
    private func prepareRequest(page: Int) -> URLRequest {
        var components = URLComponents(string: Endpoints.news.rawValue)!
        components.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
        return URLRequest(url: components.url!)
    }
    
}
