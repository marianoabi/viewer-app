//
//  Indicator.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/16/21.
//

import UIKit

class Indicator {
    static let sharedInstance = Indicator()
    var blurImageView = UIImageView()
    var indicator = UIActivityIndicatorView()
    
    private init() {
        blurImageView.frame = UIScreen.main.bounds
        blurImageView.backgroundColor = ViewerApp.Colors.content50
        blurImageView.isUserInteractionEnabled = true
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.color = .red
        indicator.startAnimating()
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            execute: do {
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(self.blurImageView)
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(self.indicator)
            }
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            execute: do {
                self.blurImageView.removeFromSuperview()
                self.indicator.removeFromSuperview()
            }
        }
    }
}
