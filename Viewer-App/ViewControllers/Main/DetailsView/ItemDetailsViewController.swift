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
    
    var item: Any? {
        didSet {
            self.prepareResource()
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
    
    func prepareResource() {
        if let file = self.item as? PDF {
            
            let fileArray = file.fileName?.components(separatedBy: ".")
            guard let fileURL = Bundle.main.url(forResource: fileArray?.first, withExtension: fileArray?.last) else { return }
            guard let images = drawImagesFromPDF(withUrl: fileURL) else { return }
            
            self.loadImagesOnViewer(images: images)
            
        } else {
            // TODO: Process image file here
            
        }
    }
}

// MARK: - Functionalities/Methods
extension ItemDetailsViewController {
    
    func loadImagesOnViewer(images: [UIImage]) {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        guard let scrollView = scrollView else { return }
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(zoomImage(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
//            scrollView.isPagingEnabled = true
        scrollView.bouncesZoom = false
        scrollView.alwaysBounceVertical = false
        scrollView.delegate = self
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        
        for (index, image) in images.enumerated() {
            
            let yOrigin = CGFloat(index) * scrollView.frame.size.height

            let imageView = UIImageView(frame: CGRect(x: 0, y: yOrigin, width: scrollView.frame.width, height: scrollView.frame.height))
            imageView.image = image
            self.imageView = imageView
            imageView.contentMode = .scaleAspectFit
            
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height * CGFloat(images.count))
        print(scrollView.frame.size.height)
        print(scrollView.frame.size.width)
    }
    
    private func drawImagesFromPDF(withUrl url: URL) -> [UIImage]? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        let pages = document.numberOfPages
        var imageArray: [UIImage] = []
        var count = 0
        
        while count < pages {
            guard let page = document.page(at: count + 1) else { return nil }

            let pageRect = page.getBoxRect(.mediaBox)
            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
            let img = renderer.image { ctx in
                UIColor.white.set()
                ctx.fill(pageRect)

                ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

                ctx.cgContext.drawPDFPage(page)
            }
            
            imageArray.append(img)
            count += 1
        }

        return imageArray
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
