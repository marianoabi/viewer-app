//
//  Image.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import ObjectMapper

class Image: Mappable {
    var retrieveItems: Bool = false
    var count: Int? = 0
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        retrieveItems <- map["retrieve_items"]
        count <- map["count"]
    }
}
