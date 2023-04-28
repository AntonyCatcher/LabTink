//
//  LoadingCell.swift
//  NewsApp
//
//  Created by Anton on 04.02.2023.
//

import UIKit

final class LoadingCell: UITableViewCell {
    
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    func startLoading() {
        loader.startAnimating()
    }
    
}
