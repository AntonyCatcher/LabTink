//
//  RetryCell.swift
//  NewsApp
//
//  Created by Anton on 04.02.2023.
//

import UIKit

final class RetryCell: UITableViewCell {
    
    private var onRetry: Block?
    
    func setup(onRetry: Block?) {
        self.onRetry = onRetry
    }
    
    @IBAction func retryDidPress() {
        onRetry?()
    }
    
}
