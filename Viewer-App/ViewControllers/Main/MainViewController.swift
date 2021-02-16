//
//  MainViewController.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import UIKit

// MARK: - Properties/Overrides
class MainViewController: BaseViewController {
    private var contentView: MainView?
    
    private var xmlParser: XMLParser?
    private var currentParsedElement = String()
    private var weAreInsideAnItem = false
        
    private var items: [Any] = []
    private var pdfFile: PDF?
    
    private var images: [UIImage]?
    
    private var picsumProvider = BaseMoyaProvider<PicsumService>()
    private lazy var presenter = MainPresenter(self, picsumProvider: picsumProvider)
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        super.loadNibNamed("MainView")
        self.contentView = self.view as? MainView
    }
}

// MARK: - Lifecycle
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        
        self.parseXML()
    }
}

// MARK: - Functions/Methods
extension MainViewController {
    func setupViews() {
        self.navigationItem.title = "Home"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.contentView?.itemsTableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemTableViewCell")
        self.contentView?.itemsTableView.register(UINib(nibName: "FileNotFoundTableViewCell", bundle: nil), forCellReuseIdentifier: "FileNotFoundTableViewCell")
        self.contentView?.itemsTableView.delegate = self
        self.contentView?.itemsTableView.dataSource = self
    }
    
    private func parseXML() {
        if let xmlUrl = Bundle.main.url(forResource: "contents", withExtension: "xml") {
            print("xml path \(xmlUrl)")
            do {
                let myData = try Data(contentsOf: xmlUrl)
                self.xmlParser = XMLParser(data: myData)
                self.xmlParser?.delegate = self
                self.xmlParser?.parse()
            } catch {
                print("Error")
            }
        }
    }
    
    private func insertRetrievedItem(item: Any, type: FileType) {
        switch type {
        case .pdf:
            self.items.append(item as! PDF)
            
        case .image:
            self.items.append(item as! ImageList)
        }
    }
    
    func getImageList(count: Int) {
        self.presenter.getImageList(limit: count)
    }
    
    private func prepareResource(item: Any) -> [UIImage]? {
        if let file = item as? PDF {

            let fileArray = file.fileName?.components(separatedBy: ".")
            
            guard let fileURL = Bundle.main.url(forResource: fileArray?.first, withExtension: fileArray?.last) else { return nil }

            guard let drawnImages = self.drawImagesFromPDF(withUrl: fileURL) else { return nil }
            return drawnImages

        } else if let file = item as? Image, let url = file.url {

            self.images = []
            guard let convertedImage = convertImageUrlToImage(url) else { return nil }
            self.images?.append(convertedImage)
            return self.images
        }
        return nil
    }
    
    private func convertImageUrlToImage(_ urlString: String) -> UIImage? {
        guard let imageURL = URL(string: urlString) else { return nil }
        var image: UIImage?

        guard let imageData = try? Data(contentsOf: imageURL) else { return nil }
        image = UIImage(data: imageData)

        return image
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
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        if let images = self.prepareResource(item: item) {
                self.goToItemDetailsPage(self, images: images)
        } else {
            let errorMessage = "File not found."
            let alert = UIAlertController(title: "Error",
                                          message: errorMessage,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == self.items.count {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "FileNotFoundTableViewCell", for: indexPath) as? FileNotFoundTableViewCell
//            cell?.isUserInteractionEnabled = false
//            return cell!
//        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell
        let item = self.items[indexPath.row]
        cell?.updateData(item: item)
        
        if indexPath.row % 2 == 0 {
            print("even")
            cell?.backgroundColor = ViewerApp.Colors.lightGray
        } else {
            print("odd")
            cell?.backgroundColor = ViewerApp.Colors.background
        }
            
        return cell!
    }
}

// MARK: - XMLParserDelegate
extension MainViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "viewer" {
            weAreInsideAnItem = true
        }
        
        if weAreInsideAnItem {
            switch elementName {
            
            case "pdf-item":
                currentParsedElement = "pdf-item"
            
            case "filename":
                currentParsedElement = "filename"
            
            case "description":
                currentParsedElement = "description"
            
            case "image-list":
                currentParsedElement = "image-list"
                print("image-list")
              
                if let attribute1 = attributeDict["retrieve_images"], let attribute2 = attributeDict["image_count"] {
                    let image = ImageList()
                    image.retrieveItems = attribute1.boolValue
                    image.count = Int(attribute2) ?? 0
                    
                    if image.retrieveItems {
                        self.getImageList(count: image.count)
                    }
                }
            
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
      if weAreInsideAnItem {
        switch currentParsedElement {
        
        case "filename":
            self.pdfFile = PDF()
            self.pdfFile?.fileName = string
            break

        case "description":
            self.pdfFile?.description = string
            break
        
        default:
            break
        }
      }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if weAreInsideAnItem {
            print("element name = \(elementName)")

            switch elementName {
            
            case "filename":
                currentParsedElement = ""
            
            case "description":
                currentParsedElement = ""
                
            case "pdf-item":
                currentParsedElement = ""
                if let pdf = self.pdfFile {
                    self.insertRetrievedItem(item: pdf, type: .pdf)
                }
                                
            default:
                break
            }

            if elementName == "viewer" {
                weAreInsideAnItem = false
            }
        }
    }
}

// MARK: - XMLParserDelegate
extension MainViewController: MainPresenterView {
    func successGetImageList(_ presenter: MainPresenter, list: [Image]) {
        for image in list {
            self.items.append(image)
        }
        
        self.contentView?.itemsTableView.reloadData()
    }
    
    func onError(_ presenter: MainPresenter, error: String) {
        let alert = UIAlertController(title: "Error",
                                      message: error,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoadingView(_ presenter: MainPresenter) {
        self.showLoadingView()
    }
    
    func removeLoadingView(_ presenter: MainPresenter) {
        self.removeLoadingView()
    }
}
