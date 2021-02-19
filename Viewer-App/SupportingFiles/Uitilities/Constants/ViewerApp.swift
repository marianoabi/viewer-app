//
//  ViewerApp.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import UIKit

struct ViewerApp {
    
    struct Fonts {
        static let primaryRegular = "RobotoCondensed-Regular"
        static let primaryBold = "RobotoCondensed-Bold"
    }
    
    struct Colors {
        static let content = UIColor(named: "content")
        static let content50 = UIColor(named: "content50")
        static let background = UIColor(named: "background")
        static let lightGray = UIColor(named: "lightGray")
    }
    
    struct ErrorMessages {
        static let byDefault = "An error ocurred."
        static let fileNotFoundError = "File not found."
        static let invalidImageDataError = "Invalid Image data."
        static let parsingXMLError = "Error parsing XML."
        static let fetchingImageError = "Error fetching image."
        static let mapJSONError = "An error ocurred while mapping JSON."
        static let decodeDataError = "Failed to decode data. Invalid response from server."
    }
    
    struct Str {
        static let error = "Error"
        static let okay = "Okay"
        static let home = "Home"
    }
    
    struct XMLKeys {
        static let viewer = "viewer"
//        static let
    }
    
    struct ViewControllers {
        static let mainViewController = "MainViewController"
    }
    
    struct Storyboards {
        static let main = "Main"
    }
}
