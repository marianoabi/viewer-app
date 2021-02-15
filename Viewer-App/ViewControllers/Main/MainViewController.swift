//
//  MainViewController.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import UIKit

// MARK: - Properties/Overrides
class MainViewController: BaseViewController {
    var contentView: MainView?
    var xmlParser: XMLParser?
        
    var currentParsedElement = String()
    var weAreInsideAnItem = false
    var writing = false
    
    var pdfFiles: [PDF]?
    var count = 1
    
    var items: [Any] = [] {
        didSet {
            print("items = \(items)")
            self.contentView?.itemsTableView.reloadData()
        }
    }
    var item: Any?
    
    var pdfFile: PDF?
    
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
        self.contentView?.itemsTableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemTableViewCell")
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
            self.items.append(item as! Image)
        }
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        self.goToItemDetailsPage(self, item: item)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell
        
        let item = self.items[indexPath.row]
        cell?.updateData(item: item)
            
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
