//
//  API.swift
//  FoodFlyDist
//
//  Created by Seungjin on 20/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Foundation
import Alamofire


enum API {
    case pingCheck
    case fileUpload
    case revisionHistory(String)
}

extension API : TargetType {

    var baseURL: URL {
        #if DEBUG
        return URL(string: "http://45.76.220.229:8888")!
        #else
        return URL(string: "http://45.76.220.229:8888")!
        #endif
    }

    var path: String {
        switch self {
        case .pingCheck:
            return ""
        case .fileUpload:
            return "/api/v1/appfile/upload"
        case .revisionHistory(let flatform):
            return "/api/v1/appfile/\(flatform)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .pingCheck, .revisionHistory:
            return .get
        case .fileUpload:
            return .post
        }
        
        
    }
    
    public var parameter: Parameters {
        switch self {
        case .pingCheck, .fileUpload, .revisionHistory:
            return [:]
//        case .fileUpload(let appFile):
//            return [
//                "flatform_type" : "ios",
//                "version" : "1.0.0",
//                "revision_history" : "revision history area",
//                "registrant" : "admin",
//                "app_type" : "auto",
//                "appfile" : appFile,
//                "app_environment" : "development"
//            ]
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .pingCheck, .fileUpload, .revisionHistory:
            return ["Content-Type" : "application/x-www-form-urlencoded"]
        }
    }

}

extension API: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        
        let url = self.baseURL.appendingPathComponent(self.path)
        var urlRequest = try URLRequest(url: url, method: self.method, headers: self.header)
        
        switch self {
        case .pingCheck, .revisionHistory:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: self.parameter)
            print("Router .\(self) URL : ", urlRequest)
        case .fileUpload:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        return urlRequest
    }
}
