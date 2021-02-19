//
//  Image.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

class Image: Codable {
    var author: String?
    var url: String?
    
    private enum CodingKeys : String, CodingKey {
        case author, url = "download_url"
    }
}
