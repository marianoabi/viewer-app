//
//  PDF.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import ObjectMapper

class PDF: Mappable {
    
    var fileName: String?
    var description: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        fileName <- map["fileName"]
        description <- map["description"]
    }
}
