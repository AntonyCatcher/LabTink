//
//  SceneDelegate.swift
//  FirstLabTink
//
//  Created by Anton  on 04.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let cache = DiskNewsCache()
        let workingQueue = DispatchQueue(
            label: "NewsApp.repository",
            qos: .utility
        )
        let networkService = UrlSessionNewsService(
            queue: workingQueue
        )
        let serviceWithCache = NewsServiceWithCache(
            service: networkService,
            cache: cache
        )
        let viewedCountCache = DiskNewsViewCountCache()
        let repository = NewsRepository(
            queue: workingQueue,
            service: serviceWithCache,
            viewCountCache: viewedCountCache
        )
        let viewModel = NewsViewModel(repository: repository)
        
        let newsFeedViewController = NewsViewController(viewModel: viewModel)
        window?.rootViewController = UINavigationController(
            rootViewController: newsFeedViewController
        )
        
        window?.makeKeyAndVisible()
    }

}
