//
//  ProgressView.swift
//  NewsApp
//
//  Created by Anton on 05.02.2023.
//

import UIKit

final class ProgressView: UIProgressView {
    
    func startProgress() {
        alpha = 1.0
        setProgress(0.1, animated: true)
    }
    
    func setProgress(_ newProgress: Float) {
        guard alpha > 0 else { return }
        setProgress(newProgress, animated: true)
        if newProgress >= 1.0 {
           hideWithAnimation()
        }
    }
    
    func finishProgress() {
        setProgress(1.0, animated: true)
        hideWithAnimation()
    }
    
    private func hideWithAnimation() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.1,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let self = self else { return }
                self.alpha = 0.0
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                self.progress = 0
            }
        )
    }
    
}
