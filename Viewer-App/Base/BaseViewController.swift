//
//  BaseViewController.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import UIKit

fileprivate var aView: UIView?

// MARK: - Properties/Overrides
class BaseViewController: UIViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadNibNamed(_ nibName: String) {
        if let nibs: Array = Bundle.main.loadNibNamed(nibName, owner: self, options: nil) {
            self.view = nibs.first as? UIView
        } else {
            print("Xib named \(nibName) not found.")
        }
    }
    
    deinit {
        print("Deallocated - \(self)")
    }
    
    func showLoadingView() {
        
        DispatchQueue.main.async {
            aView = UIView(frame: self.view.bounds)
            aView?.backgroundColor = ViewerApp.Colors.content50
            let ai = UIActivityIndicatorView(style: .large)
            ai.color = .white
            ai.center = aView!.center
            ai.startAnimating()
            aView?.addSubview(ai)
            self.view.addSubview(aView!)
        }
    }
        
    final func removeLoadingView() {
        aView?.removeFromSuperview()
        aView = nil
    }
}

// MARK: - Navigation functions
extension BaseViewController {
    func goToItemDetailsPage(_ viewController: UIViewController, request: URLRequest) {
        // Safe Push VC
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailsViewController") as? ItemDetailsViewController {
            viewController.request = request
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}
