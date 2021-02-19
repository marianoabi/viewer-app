//
//  VerbosePlugin.swift
//  Viewer-App
//
//  Created by Abigail Mariano on 2/15/21.
//

import Foundation
//import Moya
//
//struct VerbosePlugin: PluginType {
//    let verbose: Bool
//    
//    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//        #if DEBUG
//        if let body = request.httpBody,
//            let str = String(data: body, encoding: .utf8) {
//            if verbose {
//                print("body: \(request)")
//                print("request to send: \(str)")
//            }
//        }
//        #endif
//        return request
//    }
//    
//    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
//        #if DEBUG
//        switch result {
//        case .success(let body):
//            if verbose {
//                print("Response:")
//                if let json = try? JSONSerialization.jsonObject(with: body.data, options: .mutableContainers) {
//                    print(json)
//                } else {
//                    let response = String(data: body.data, encoding: .utf8)!
//                    print(response)
//                }
//            }
//        case .failure:
//            break
//        }
//        #endif
//    }
//    
//    func willSend(_ request: RequestType, target: TargetType) {
//        #if DEBUG
//        print("---REQUEST: \(String(describing: request.request))")
//        #endif
//    }
//}
