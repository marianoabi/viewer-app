//
//  ItemDetailsViewController.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import UIKit
import WebKit

// MARK: - Properties/Overrides
class ItemDetailsViewController: BaseViewController {
    private var contentView: ItemDetailsView?
    
    private var webView = WKWebView()
    
    var request: URLRequest? {
        didSet {
            self.setupWKWebView()
            self.loadResource()
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        super.loadNibNamed("ItemDetailsView")
        self.contentView = self.view as? ItemDetailsView
    }
}

// MARK: - Lifecycle
extension ItemDetailsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK: - Functionalities/Methods
extension ItemDetailsViewController {
    
    private func setupWKWebView() {
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup AutoLayout
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadResource() {
        if let request = request {
            webView.load(request)
        }
    }
}
