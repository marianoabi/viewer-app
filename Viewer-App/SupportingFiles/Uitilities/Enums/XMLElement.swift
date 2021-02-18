//
//  XMLElement.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/17/21.
//

import Foundation

enum XMLElement {
    case viewer
    case pdfItem
    case fileName
    case description
    case imageList
    
    var description: String {
        switch self {
        case .viewer:
            return "viewer"
        case .pdfItem:
            return "pdf-item"
            
        case .fileName:
            return "filename"
            
        case .description:
            return "description"
            
        case .imageList:
            return "image-list"
        }
    }
}
