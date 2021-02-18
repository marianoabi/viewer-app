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
        static let fileNotFound = "File not found."
        static let invalidImageData = "Invalid Image data."
        static let errorParsingXML = "Error parsing XML."
        static let errorFetchingImage = "Error fetching image."
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
