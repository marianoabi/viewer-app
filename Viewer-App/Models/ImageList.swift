//
//  ImageList.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import ObjectMapper

class ImageList: Mappable {
    var images: [Image]?
    var retrieveItems: Bool = false
    var count: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        retrieveItems <- map["retrieve_items"]
        count <- map["count"]
    }
}
