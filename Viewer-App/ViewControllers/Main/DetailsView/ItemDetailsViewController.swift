//
//  ItemDetailsViewController.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import UIKit

// MARK: - Properties/Overrides
class ItemDetailsViewController: BaseViewController {
    var contentView: ItemDetailsView?
    
    var scrollView: UIScrollView?
    var imageView = UIImageView()
    
    var images: [UIImage]? {
        didSet {
            guard let images = images else { return }
            self.loadImagesOnViewer(images: images)
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
    
    func loadImagesOnViewer(images: [UIImage]) {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        guard let scrollView = scrollView else { return }
        
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.isPagingEnabled = true
        scrollView.bouncesZoom = false
        scrollView.alwaysBounceVertical = false
        scrollView.delegate = self
        scrollView.backgroundColor = ViewerApp.Colors.background
        scrollView.clipsToBounds = false
        view.addSubview(scrollView)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(zoomImage(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        for (index, image) in images.enumerated() {
            
            let yOrigin = CGFloat(index) * scrollView.frame.size.height

            let imageView = UIImageView(frame: CGRect(x: 0, y: yOrigin, width: scrollView.frame.width, height: scrollView.frame.height))
            imageView.image = image
            self.imageView = imageView
            imageView.contentMode = .scaleAspectFit
            
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height * CGFloat(images.count))
    }
    
    @objc func zoomImage(_ sender: UITapGestureRecognizer) {
        if let scrollView = self.scrollView {
            if scrollView.zoomScale > scrollView.minimumZoomScale {
                scrollView.zoomScale = scrollView.minimumZoomScale
            } else {
                scrollView.zoom(to: zoomRectForScale(scale: 5.0, center: sender.location(in: sender.view)), animated: true)
            }
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
            var zoomRect = CGRect.zero
            zoomRect.size.height = imageView.frame.size.height / scale
            zoomRect.size.width  = imageView.frame.size.width  / scale
            let newCenter = imageView.convert(center, from: scrollView)
            zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
            zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
            return zoomRect
        }
}

// MARK: - UIScrollViewDelegate
extension ItemDetailsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
        }
}
