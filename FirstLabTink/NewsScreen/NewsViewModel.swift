//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Anton on 04.02.2023.
//

import Foundation

final class NewsViewModel {
    
    var onUpdate: Callback<[NewsViewController.Cell]>?
    
    private let repository: NewsRepository
    private var limitReached = false
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    private var isLoading = false {
        didSet {
            if isLoading {
                guard !currentState.contains(where: { $0.isLoading }) else { return }
                
                currentState.append(.loading)
            } else {
                currentState.removeAll(where: { $0.isLoading })
            }
        }
    }
    
    private var isRetry = false {
        didSet {
            if isRetry {
                guard !currentState.contains(where: { $0.isRetry }) else { return }

                currentState.append(.retry({ [weak self] in
                    self?.loadMore(force: true)
                }))
            } else {
                currentState.removeAll(where: { $0.isRetry })
            }
        }
    }
    
    private var currentState: [NewsViewController.Cell] = []
    
    func viewDidLoad() {
        loadMore(force: true)
    }
    
    func newsItemDidPress(_ item: NewsItem) {
        item.incrementViewCount()
        
        repository.incrementViewCount(for: item)
    }
    
    func refreshAll() {
        guard !isLoading else { return }
        isLoading = true
        isRetry = false
        limitReached = false
        updateUIState()
        
        repository.refreshAll { result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                
                switch result {
                case .success(let items) where !items.isEmpty:
                    self?.currentState = items.map { .news($0) }
                    self?.isRetry = false
                case .success:
                    self?.limitReached = true //Сервер отдал все возможные новости
                    self?.isRetry = false
                case .failure:
                    self?.isRetry = true
                }
                self?.updateUIState()
            }
        }
    }
    
    func loadMore(force: Bool = false) {
        guard !limitReached, !isLoading, (force || !isRetry) else { return }
        isLoading = true
        isRetry = false
        updateUIState()
        
        repository.loadMore { result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                
                switch result {
                case .success(let items) where !items.isEmpty:
                    self?.currentState += items.map { .news($0) }
                    self?.isRetry = false
                case .success:
                    self?.limitReached = true //Сервер отдал все возможные новости
                    self?.isRetry = false
                case .failure:
                    self?.isRetry = true
                }
                self?.updateUIState()
            }
        }
    }
    
    private func updateUIState() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.onUpdate?(self.currentState)
        }
    }
    
}
