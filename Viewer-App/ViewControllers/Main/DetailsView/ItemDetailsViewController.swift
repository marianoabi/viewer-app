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

        self.setupScrollView()
    }
}

// MARK: - Functionalities/Methods
extension ItemDetailsViewController {
    
    func loadImagesOnViewer(images: [UIImage]) {
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        guard let scrollView = scrollView else { return }

        self.view.addSubview(scrollView)
        
        var imageViewWidth = 0.0
        var scrollViewHeight = 0.0
        
        for (index, image) in images.enumerated() {
            var ratio = 0.0
            
            let height = image.size.height
            let width = image.size.width
            
            if height > width {
                ratio = Double(height / width)
            } else {
                ratio = Double(width / height)
            }
            
            
            imageViewWidth = Double(scrollView.frame.size.width) * ratio
            let yOrigin = CGFloat(imageViewWidth + 50) * CGFloat(index)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: yOrigin, width: scrollView.frame.size.width, height: CGFloat(imageViewWidth)))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            
            scrollViewHeight = scrollViewHeight + imageViewWidth
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: CGFloat(scrollViewHeight) * CGFloat(images.count))
        scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width, y: scrollView.frame.size.height)
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
    
    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    private func setupScrollView() {
        guard let scrollView = scrollView else { return }
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.bouncesZoom = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.backgroundColor = ViewerApp.Colors.background
        scrollView.clipsToBounds = false
    }
}

// MARK: - UIScrollViewDelegate
extension ItemDetailsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
        }
}
