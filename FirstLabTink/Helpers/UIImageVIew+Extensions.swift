//
//  UIImageVIew+Extensions.swift
//  NewsApp
//
//  Created by Anton on 04.02.2023.
//

import UIKit

extension UIImageView {
    
    func load(imageUrl: URL?) {
        guard let imageUrl else { return }
        self.tag = imageUrl.absoluteString.hashValue
        URLSession.shared.dataTask(
            with: URLRequest(url: imageUrl)
        ) { [weak self] data, _, _ in
            guard let self, let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self, self.tag == imageUrl.absoluteString.hashValue else { return }
                self.image = image
            }
        }.resume()
    }
    
}
