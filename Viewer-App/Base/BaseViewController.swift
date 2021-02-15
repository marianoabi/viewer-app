//
//  BaseViewController.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import UIKit

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
}

// MARK: - Navigation functions
extension BaseViewController {
    func goToItemDetailsPage(_ viewController: UIViewController, item: Any) {
        // Safe Push VC
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailsViewController") as? ItemDetailsViewController {
            viewController.item = item
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}
