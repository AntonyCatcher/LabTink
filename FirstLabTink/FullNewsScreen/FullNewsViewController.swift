//
//  FullNewsViewController.swift
//  NewsApp
//
//  Created by Anton on 05.02.2023.
//

import UIKit
import WebKit

final class FullNewsViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var progressView: ProgressView = {
        let progressView = ProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = .blue
        return progressView
    }()
    
    private var estimatedProgressObserver: NSKeyValueObservation?
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupProgressObserver()
        webView.load(URLRequest(url: url))
    }
    
}

private extension FullNewsViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        webView.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: webView.topAnchor)
        ])
    }
    
    func setupProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] object, _ in
            guard let self else { return }
            self.progressView.setProgress(Float(object.estimatedProgress))
        }
    }
    
}
