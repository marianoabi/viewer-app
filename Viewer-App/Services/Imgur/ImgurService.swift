//
//  ImgurService.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import Moya

enum ImgurService {
    case getImage
}

extension ImgurService: BaseService {
    var baseURL: URL {
        return URL(string: "https://imgur.com")!
    }
    
    var path: String {
        switch self {
        case .getImage:
            return "/3/gallery"
        }
    }
    
        var method: Moya.Method {
        switch self {
        case .getImage:
            return .get
        }
  
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getImage:
            return .requestPlain

        }
    }
    
    
}
