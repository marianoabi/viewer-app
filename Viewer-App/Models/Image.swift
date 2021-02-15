//
//  Image.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import ObjectMapper

class Image: Mappable {
    
    var hash: String?
    var url: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
    }
}
