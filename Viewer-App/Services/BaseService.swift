//
//  BaseService.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import Moya

protocol BaseService: TargetType {}

extension BaseService {
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json",
            "Authorization": "Client-ID f477922025843d4"
        ]
    }
    
}
