//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Anton on 04.02.2023.
//

import UIKit

final class NewsViewController: UIViewController {
    
    enum Cell {
        case news(NewsItem)
        case loading
        case retry(Block)
        
        var isLoading: Bool {
            switch self {
            case .loading: return true
            case .news: return false
            case .retry: return false
            }
        }
        
        var isRetry: Bool {
            switch self {
            case .retry: return true
            case .loading: return false
            case .news: return false
            }
        }
    }
    
    private lazy var refreshControl = UIRefreshControl()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    private var items: [Cell] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let viewModel: NewsViewModel
    
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(UINib(nibName: "NewsItemCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        tableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "loadingCell")
        tableView.register(UINib(nibName: "RetryCell", bundle: nil), forCellReuseIdentifier: "retryCell")

        tableView.rowHeight = UITableView.automaticDimension
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        viewModel.refreshAll()
    }
    
    private func setupBindings() {
        viewModel.onUpdate = { [weak self] items in
            guard let self else { return }
            self.items = items
            self.refreshControl.endRefreshing()
        }
    }
    
}

extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        switch item {
        case .news(let newsItem):
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsItemCell
            cell.selectionStyle = .none
            cell.setup(with: newsItem)
            return cell
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.selectionStyle = .none
            cell.startLoading()
            return cell
        case .retry(let onRetry):
            let cell = tableView.dequeueReusableCell(withIdentifier: "retryCell", for: indexPath) as! RetryCell
            cell.selectionStyle = .none
            cell.setup(onRetry: onRetry)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == items.count - 1, cell is NewsItemCell else { return }
        viewModel.loadMore()
    }
    
}

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.row] {
        case .news(let item):
            viewModel.newsItemDidPress(item)
            
            let vc = NewsDetailsViewController(newsItem: item)
            navigationController?.pushViewController(vc, animated: true)
        case .retry, .loading:
            break
        }
    }
    
}
