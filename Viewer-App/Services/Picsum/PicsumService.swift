//
//  PicsumService.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

//import Moya
//
//enum PicsumService {
//    case getImageList(limit: Int)
//}
//
//extension PicsumService: BaseService {
//    var baseURL: URL {
//        return URL(string: CoreService.picsumBaseURLString)!
//    }
//    
//    var path: String {
//        switch self {
//        case .getImageList:
//            return "/v2/list"
//
//        }
//    }
//    
//    var method: Moya.Method {
//        switch self {
//        case .getImageList:
//            return .get
//
//        }
//    }
//    
//    var sampleData: Data {
//        return Data()
//    }
//    
//    var task: Task {
//        switch self {
//        case let .getImageList(limit):
//            return .requestParameters(parameters: [
//                "limit": limit
//            ], encoding: URLEncoding.default)
//   
//        }
//    }
//    
//    
//}
